// issues requests to the CartoDB import api for all static files

var _ = require("underscore");
var fs = require("fs");
var request = require('request');
var async = require('async');

require("http").globalAgent.maxSockets = 1;

var API_KEY;
var CARTODB_URL;
if (process.env.CARTODB_API_KEY && process.env.CARTODB_URL) {
  API_KEY = process.env.CARTODB_API_KEY;
  CARTODB_URL = process.env.CARTODB_URL;
} else {
  console.log("Reading config variables from config.json");
  json = JSON.parse(fs.readFileSync("../config.json"));
  API_KEY = json.api_key;
  CARTODB_URL = json.cdb_url;
}

request = request.defaults({"baseUrl": CARTODB_URL + '/api/v1/'})

var wantedUrls = fs.readFileSync('syncdatasets.txt').toString().split("\n");

var getTables = function(callback) {
  // Get existing tables from CartoDB account
    var get = {
      method: "POST",
      uri: 'sql?api_key=' + API_KEY,
      json: {'q': "SELECT * FROM pg_tables WHERE tableowner=user and schemaname!='cdb_importer'"}
    }
    request(get, function (error, response, body) {
      if (error) callback(error);
      var uploaded_tables = _.pluck(body['rows'], 'tablename');
      callback(null, uploaded_tables);
    });
}

var startImport = function(wantedUrl) {
  return function(callback) {
    var get = {
      method: "POST",
      uri: 'imports?api_key=' + API_KEY,
      json: {'url': wantedUrl}
    }
    request(get, function (error, response, body) {
      if (error) callback(error);
      checkImport(wantedUrl.split("/").pop(), body['item_queue_id'], callback)
    });
  }
}

var checkImport = function(url, import_id, callback) {
    var get = {
      method: "GET",
      uri: 'imports/' + import_id + '?api_key=' + API_KEY
    }
    request(get, function(error, response, body) {
      if(error) return callback(error);
      json = JSON.parse(body);
      console.log(url+": "+json['state']);
      if(json['state'] == 'failure') return callback(json);
      if(json['state'] != 'complete') {
        setTimeout(function(){checkImport(url, import_id, callback)}, 500);
      }else{
        callback(null, body);
      }
    })
}

getTables(function(error, uploaded_tables) {
  if(error) throw "Can't get existing CartoDB tables, check the variables in config.json";
  missingTables = _.filter(wantedUrls, function(t) {
    // Clean names so they match the name they will have once imported in CartoDB
    cleanName = t.split("/").pop()
        .replace(/(\.zip$|\.json$)/,"")
        .replace(/-(complete|split)-3857/,"")
        .replace(/-/g,"_");
    return (uploaded_tables.indexOf(cleanName) == -1 && uploaded_tables.indexOf(cleanName+"_shp") == -1 && t != "")
  })
  console.log(missingTables.length+" files need to be imported:\n", missingTables);
  var reqs = [];
  missingTables.forEach(function(w) {
    reqs.push(startImport(w));
  });
  async.parallelLimit(reqs, 3, function(err, results) {
    if (err) console.log(err);
  });
});
