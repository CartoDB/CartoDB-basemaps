var util = require('./util.js');

function make(name) {
  var json = util.node()[name];
  return JSON.stringify({
    "name": name ,
    "auth":"open",
    "version": "0.0.1",
    'layergroup': json 
  })
}

console.log(make(process.argv[2]));
