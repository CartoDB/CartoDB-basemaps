
var yaml = require('js-yaml');
var fs   = require('fs');
var pg   = require('pg'); 
var async = require('async');
var request = require('request');
var _ = require('underscore');

var ORIGIN_SCHEMA='planet_green'
var ORIGIN_URL="https://originaccount.cartodb.com"
var ORIGIN_API_KEY="CHANGE_ME"
var FILTER_QUERY="WHERE the_geom_webmercator && ST_Transform(ST_SetSRID('BOX(-122.737 37.449,-122.011 37.955)'::box2d, 4326), 3857) OR the_geom_webmercator && ST_Transform(ST_SetSRID('BOX(-4.293 39.8,-3.057 41.03)'::box2d, 4326), 3857)"


// fully qualified table name
function tname(table_name) {
  if (table_name.indexOf(".") >= 0) return table_name;
  return default_schema + "." + table_name;
}


var getTables = function(callback) {
  // Get existing tables from CartoDB account
    var get = {
      method: "POST",
      uri: CARTODB_URL + '/api/v1/sql?skipfields=the_geom_webmercator&api_key=' + API_KEY,
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
      uri: CARTODB_URL + '/api/v1/imports?api_key=' + API_KEY,
      json: {'url': wantedUrl}
    }
    request(get, function (error, response, body) {
      if (error) callback(error);
      checkImport(wantedUrl.split("/").pop(), body['item_queue_id'], callback)
    });
  }
}

var doc = yaml.safeLoad(fs.readFileSync('generalizations.yml', 'utf8'));
var generalizationTables = _.pluck(doc, 'name');

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

var checkImport = function(url, import_id, callback) {
    var get = {
      method: "GET",
      uri: CARTODB_URL + '/api/v1/imports/' + import_id + '?api_key=' + API_KEY
    }
    request(get, function(error, response, body) {
      if(error) return callback(error);
      json = JSON.parse(body);
      console.log(import_id+": "+json['state']);
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
  missingTables = _.filter(generalizationTables, function(t) {
    return (uploaded_tables.indexOf(t) == -1 && uploaded_tables.indexOf(t+"_shp") == -1 && t != "")
  })
  console.log(missingTables.length+" files need to be imported:\n", missingTables);
  urls = _.map(missingTables, function(table) {
    query="SELECT *, the_geom_webmercator AS the_geom FROM "+ORIGIN_SCHEMA+"."+table+" "+FILTER_QUERY
    return ORIGIN_URL+"/api/v1/sql?q="+escape(query)+"&api_key="+ORIGIN_API_KEY+"&format=csv&filename="+table+".csv";
  })
  var reqs = [];
  urls.forEach(function(w) {
    reqs.push(startImport(w));
  });
  async.parallelLimit(reqs, 3, function(err, results) {
    if (err) console.log(err);
  });
});
