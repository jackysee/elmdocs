const fs = require("fs");
const path = require("path");
const download = require("download");
const mkdirp = require("mkdirp");
const pify = require("pify");
const fsP = pify(fs);
const beautify = require("json-beautify");

const site = "http://package.elm-lang.org/";
const target = "src/json/"

function get(file, dest){
    process.stdout.write("Fetching " + file + " ... ");
    return download(site + file).then(
        data => {
            if(!dest){
                process.stdout.write("done.\n");
                return Promise.resolve(data);
            }
            process.stdout.write("saved.\n");
            return pify(mkdirp)(path.dirname(dest))
                .then(() => fsP.writeFileSync(dest, data))
                .then(() => data);
        },
        err => {
            process.stdout.write("failed.\n");
            console.error("cannot get file ", err);
            return Promise.reject(err);
        }
    );
}

function getList(list, count){
    if(list.length == 0){
        return Promise.resolve(count);
    }

    if(count === undefined){
        count = 0;
    }

    var dest = list[0].dest;
    var file = list[0].file;


    if(fs.existsSync(dest)){
        //console.log("File existed, skipped : " + dest);
        return getList(list.slice(1), count);
    }

    return get(file, dest).then(
        data => {
            return getList(list.slice(1), count + 1);
        },
        err => {
            console.error("Cannot get file ", err);
            return Promise.reject(err);
        }
    );

}

Promise.all(
    [ get("all-packages")
    , get("new-packages")
    ]
)
.then( arr =>{
    var allPackages = JSON.parse(arr[0]);
    var newPackages = JSON.parse(arr[1]);

    var list = allPackages
        .map(p => {
            var p = "packages/" +  p.name + "/" + p.versions[0];
            var arr =  [
                {
                    file: p + "/documentation.json" ,
                    dest: target + p + "/documentation.json"
                },
                {
                    file: p + "/README.md" ,
                    dest: target + p + "/README.md"
                }
            ];
            return arr;
        })
        .reduce((sum, current) => {
            return sum.concat(current);
        }, []);

    getList(list).then(function(count){
        if(count == 0){
            console.log("Nothing to update");
            return Promise.resolve();
        }

        var allPackages_ = allPackages.map(p => {
            var folder = target + "packages/" + p.name;
            var versions = fs.readdirSync(folder).filter(file =>
                fs.statSync(path.join(folder, file)).isDirectory()
            );
            p.availableVersions = versions;
            return p;
        });

        console.log("updating new-packages.json");
        fs.writeFileSync(target + "new-packages.json", beautify(newPackages));

        console.log("updating all-packages.json");
        return fsP.writeFileSync(
            target +"all-packages.json",
            beautify(allPackages_, null, 2, 100)
        );

    });
});





