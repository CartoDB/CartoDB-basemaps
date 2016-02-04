/**
 * Takes a YAML file for a map and uploads it as a named map
 * Usage: node create_named.js <map yaml file> <map name>
 *
 * This is roughly equivalent to
 *     cartodb-yaml foo.yaml > foo.json
 *     curl -X DELETE CARTODB_URL/api/v1/map/named/foo
 *     # fiddle with foo.json
 *     curl -X POST -d @foo.json CARTODB_URL/api/v1/map/named
*/
var fs = require("fs");
var request = require('request');
var compile = require('cartodb-yaml');
var async = require('async');

require("http").globalAgent.maxSockets = 1;

var API_KEY;
var CARTODB_URL;
if (process.env.CARTODB_API_KEY && process.env.CARTODB_URL) {
  API_KEY = process.env.CARTODB_API_KEY;
  CARTODB_URL = process.env.CARTODB_URL;
} else {
  console.log("Reading config variables from config.json");
  json = JSON.parse(fs.readFileSync("config.json"));
  API_KEY = json.api_key;
  CARTODB_URL = json.cdb_url;
}

request = request.defaults({"baseUrl": CARTODB_URL + '/api/v1/'})

var deleteNamed = function(name, callback) {
    var get = {
      method: "DELETE",
      uri: 'map/named/' + name + '?api_key=' + API_KEY
    }
    request(get, function(error, response, body) {
        if(error) return callback(error);
        if (response.statusCode == 404) {
            console.log("Map " + name + " does not exist, DELETE did not do anything")
        } else if (response.statusCode == 204) {
            console.log("Map " + name + " deleted")
        } else {
            throw "Unknown response deleting";
            callback(error);
        }
    })
}

var createNamed = function(json, name, callback) {
    json.auth = "open" // https://github.com/stamen/cartodb-yaml/issues/1
    json.name = name

    var post = {
      method: "POST",
      uri: 'map/named' + '?api_key=' + API_KEY,
      body: json,
      json: true
    }
    request(post, function(error, response, body) {
        if(error) return callback(error);

        console.log("Map " + name + " created as " + response.body.template_id);
    })
}


function make(filename, named_map_name) {
    var json = compile(fs.readFileSync(filename, "utf8"));

    deleteNamed(named_map_name, function(error){
        if(error) {
            throw "error deleting";
        }
    });
    
    createNamed(json, named_map_name, function(error){});
}

make(process.argv[2], process.argv[3]);
