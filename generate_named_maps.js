var fs = require("fs");
var request = require('request');
var async = require('async');
var util = require('./util.js');

require("http").globalAgent.maxSockets = 1;

var API_KEY;
var CARTODB_URL;
if (process.env.CARTODB_API_KEY && process.env.CARTODB_URL) {
  API_KEY = process.env.CARTODB_API_KEY;
  CARTODB_URL = process.env.CARTODB_URL;
} else {
  console.log("Reading config.json");
  json = JSON.parse(fs.readFileSync("config.json"));
  API_KEY = json.api_key;
  CARTODB_URL = json.cdb_url;
}

var URL_T_PRE = CARTODB_URL+"/api/v1/map/";
var URL_T_POST = "/{z}/{x}/{y}.png?map_key=" + API_KEY;

var makereq = function(named_map_name, the_json) {
  return function(callback) {
    var get = {
      method: "put",
      uri: CARTODB_URL+'/api/v1/map/named/'+ named_map_name + '?map_key=' + API_KEY,
      json: {"name":named_map_name,"auth":"open","version": "0.0.1",'layergroup':the_json}
    }
    request(get, function (error, response, body) {
      if (error) callback(error);
      console.log(body);
      if (body.errors) {
        console.log(body);
        callback("Error");
      }
      callback(null, body.layergroupid);
    });
  }
}

async.series([
  makereq("light_all",util.node().mapconfig_light),
  makereq("light_nolabels",util.node().mapconfig_light_nolabels),
  makereq("dark_all",util.node().mapconfig_dark),
  makereq("dark_nolabels",util.node().mapconfig_dark_nolabels)
], function(err, results) {
  if (err) console.log(err);
  console.log(results);
});
