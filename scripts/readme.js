const fs = require("fs");
const path = require("path");
const download = require("download");
const mkdirp = require("mkdirp");
const pify = require("pify");
const fsP = pify(fs);
const beautify = require("json-beautify");

const site = "http://package.elm-lang.org/";
const target = "src/json/"

function ls(folder){
    return fs.readdirSync(folder).filter(file => 
        fs.statSync(path.join(folder, file)).isDirectory()
    )
}

var folders = ls(path.join(target, "packages")).reduce((sum, user) => {
    return sum.concat(
        ls(path.join(target, "packages", user)).reduce((sum, pkg) => {
            return sum.concat(
                ls(path.join(target, "packages", user, pkg)).map(ver => {
                    return { 
                        file : ["packages", user, pkg, ver, "README.md"].join("/") ,
                        dest: path.join(target, "packages", user, pkg, ver, "README.md") 
                    };
                })
            );
        }, [])
    );

}, []);


getList(folders);

function get(file, dest){
    process.stdout.write("Fetching " + file + " ... ");
    return download(site + file).then(
        data => {
            process.stdout.write("saved.\n");
            return pify(mkdirp)(path.dirname(dest))
                .then(() => fsP.writeFileSync(dest, data));
                //.then(() => JSON.parse(data));
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
        //console.log("File existed, skipped : " + dest);
        return getList(list.slice(1));
    }

    return get(file, dest).then(
        data => {
            return getList(list.slice(1));
        }, 
        err => {
            console.error("Cannot get file ", err);
            return Promise.reject(err);
        }
    );
}

