var util = require('./util.js');

function make(name, named_map_name) {
  named_map_name = named_map_name || name;
  var json = util.node()[name];
  return JSON.stringify({
    "name": named_map_name,
    "auth":"open",
    "version": "0.0.1",
    'layergroup': json 
  })
}

console.log(make(process.argv[2], process.argv[3]));
