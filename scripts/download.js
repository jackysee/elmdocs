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
            process.stdout.write("saved.\n");
            return pify(mkdirp)(path.dirname(dest))
                .then(() => fsP.writeFileSync(dest, data))
                .then(() => JSON.parse(data));
        },
        err => {
            process.stdout.write("failed.\n");
            console.error("cannot get file ", err);
            return Promise.reject(err);
        }
    );
}

function getList(list){
    if(list.length == 0){
        return Promise.resolve(true);
    }

    var dest = list[0].dest;
    var file = list[0].file;

    if(fs.existsSync(dest)){
        console.log("File existed, skipped : " + dest);
        return getList(list.slice(1));
    }

    return get(file, dest).then(data => {
        return getList(list.slice(1));
    });
    
}

Promise.all(
    [ get("all-packages", target + "all-packages.json")
    , get("new-packages", target + "new-packages.json")
    ]
)
.then( arr =>{
    var allPackages = arr[0];

    var list = allPackages.map(p => {
        var p = "packages/" +  p.name + "/" + p.versions[0] + "/documentation.json"
        return { file: p , dest: target + p };
    });

    getList(list).then(function(){
        var allPackages_ = allPackages.map(p => {
            var folder = target + "packages/" + p.name;
            var versions = fs.readdirSync(folder).filter(file => 
                fs.statSync(path.join(folder, file)).isDirectory()
            );
            p.availableVersions = versions;
            return p;
        });
        console.log("updating all-packages.json");
        return fsP.writeFileSync(target +"all-packages.json", beautify(allPackages_, null, 2, 100));
    });
});






