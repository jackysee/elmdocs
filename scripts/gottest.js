
const uri = 'http://package.elm-lang.org/all-packages';

/*
const got = require('got');
const caw = require('caw');
const url = require('url');

let protocol = url.parse(uri).protocol;
if(protocol){
    protocol = protocol.slice(0, -1);
}

got(uri, {agent:caw({protocol}), json:true})
    .then(
        r => console.log(r.body),
        e => console.log(e)
    );


*/

const request = require('request');
const download = function(uri){
    return new Promise((resolve, reject) => {
        request(uri, (err, resp, body) => {
            if(err){
                reject(err);
                return;
            }
            resolve(body);
        });
    });
};

(async () => {
    let body = await download(uri);
    console.log('body', body);
})();

