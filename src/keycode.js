/* var codes = {
  'backspace': 8,
  'tab': 9,
  'enter': 13,
  'shift': 16,
  'ctrl': 17,
  'alt': 18,
  'pause/break': 19,
  'caps lock': 20,
  'esc': 27,
  'space': 32,
  'page up': 33,
  'page down': 34,
  'end': 35,
  'home': 36,
  'left': 37,
  'up': 38,
  'right': 39,
  'down': 40,
  'insert': 45,
  'delete': 46,
  'command': 91,
  'left command': 91,
  'right command': 93,
  'numpad *': 106,
  'numpad +': 107,
  'numpad -': 109,
  'numpad .': 110,
  'numpad /': 111,
  'num lock': 144,
  'scroll lock': 145,
  'my computer': 182,
  'my calculator': 183,
  ';': 186,
  '=': 187,
  ',': 188,
  '-': 189,
  '.': 190,
  '/': 191,
  '`': 192,
  '[': 219,
  '\\': 220,
  ']': 221,
  "'": 222
};
*/

var codes = {
    '27':'esc',
    '13':'enter',
    '40':'down',
    '38':'up',
    '39':'right',
    '37':'left'
};

function getSpecialKey(keyCode){
    return codes[keyCode+""]
}

module.exports = function(ev){
    var key = getSpecialKey(ev.which) || String.fromCharCode(ev.which).trim();
    // var key = ev.which === 0?
    //     getSpecialKey(ev.keyCode) :
    //     (
    //         String.fromCharCode(ev.which).trim() ||
    //         getSpecialKey(ev.keyCode)
    //     );

    if(!key){
        return "";
    }
    key = key.toLowerCase();
    if(ev.ctrlKey){
        key = "ctrl-"+key;
    }
    if(ev.shiftKey){
        key = "shift-"+key;
    }
    return key;
};
