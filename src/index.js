require('./main.css');
require('./assets/highlight/styles/default.css');

var Elm = require('./Main.elm');

var root = document.getElementById('root');

var app = Elm.Main.embed(root, getStoredModel(true));

app.ports.scrollToElement.subscribe(function(id){
    requestAnimationFrame(function() {
        if(!id){
            return;
        }
        var target = document.getElementById(id);
        if(!target){
            return;
        }
        target.scrollIntoView(true);
    });
});

function getStoredModel(returnUndefined) {
    var stored = window.localStorage.getItem("storeModel");
    if((!stored || stored === "null") && returnUndefined){
        return null;
    }
    if(stored){
        return  JSON.parse(stored) || {};
    }
    return {};
}

function docEqual(d1, d2){
    return d1.packageName === d2.packageName
        && d1.packageVersion === d2.packageVersion;
}

app.ports.saveLocal.subscribe(function(obj){
    var storedModel = getStoredModel();
    var docs = storedModel.docs || [];
    var found = docs.find(function(d){
        return docEqual(d, obj.doc);
    });
    if(!found){
        storedModel.docs = docs.concat(obj.doc);
        storedModel.searchIndex = obj.searchIndex;
        window.localStorage.setItem("storeModel", JSON.stringify(storedModel));
    }
});

app.ports.removeLocal.subscribe(function(obj) {
    var storedModel = getStoredModel();
    var docs = storedModel.docs || [];
    storedModel.docs = docs.filter(function(d){
        return !docEqual(d, obj.doc);
    }),
    storedModel.searchIndex = obj.searchIndex;
    window.localStorage.setItem("storeModel", JSON.stringify(storedModel));
});

app.ports.saveNavWidth.subscribe(function(navWidth){
    var storedModel = getStoredModel();
    storedModel.navWidth = navWidth;
    window.localStorage.setItem("storeModel", JSON.stringify(storedModel));
});

var keycode = require("./keycode");
document.onkeydown = function(ev){
    var key = keycode(ev);
    if(key){
        if (key === "up" || key === "down"){
            ev.preventDefault();
        }
        app.ports.keypress.send(key);
    }
};

app.ports.listScrollTo.subscribe(function(id){
    var el = document.getElementById(id);
    if(el){
        requestAnimationFrame(function(){
            var parent = el.offsetParent;
            var parentScrollTop = parent.scrollTop;
            var elOffsetTop = el.offsetTop;
            if(parentScrollTop > elOffsetTop){
                parent.scrollTop = elOffsetTop;
                return;
            }
            var parentOffsetHeight = parent.offsetHeight;
            var elOffsetHeight = el.offsetHeight;
            if(elOffsetTop + elOffsetHeight > parentScrollTop + parentOffsetHeight ){
                parent.scrollTop = elOffsetTop + elOffsetHeight - parentOffsetHeight;
            }
        });
    }
});

app.ports.openLink.subscribe(function(url){
    window.open(url, "_blank");
});
