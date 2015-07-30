var express = require('express');
var fs = require("fs");
var request = require('request');
var Handlebars = require('handlebars');
var async = require('async');

require("http").globalAgent.maxSockets = 1;

var source = fs.readFileSync("generate_template.handlebars");
var template = Handlebars.compile(source.toString());
var app = express();
app.set('port', (process.env.PORT || 5000))

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

var URL_T_PRE = CARTODB_URL + "/api/v1/map/";
var URL_T_POST = "/{z}/{x}/{y}.png";

var makereq = function(named_map_name) {
  return function(callback) {
    var get = {
      method: "post",
      uri: 'https://basemaps.cartodb.com/api/v1/map/named/' + named_map_name,
      json:{}
    }
    request(get, function (error, response, body) {
      if (error) callback(error);
      if (body.errors) {
        console.log(body);
        callback("Error");
      }
      callback(null, body.layergroupid);
    });
  }
}

app.get('/', function(req, res){

  async.series([
    makereq("light_all"),
    makereq("light_nolabels"),
    makereq("dark_all"),
    makereq("dark_nolabels")
  ], function(err, results) {
    if (err) console.log(err);
    var data = {
      "light_labels":URL_T_PRE + results[0] + URL_T_POST,
      "light_nolabels":URL_T_PRE + results[1] + URL_T_POST,
      "dark_labels":URL_T_PRE + results[2] + URL_T_POST,
      "dark_nolabels":URL_T_PRE + results[3] + URL_T_POST
    }
    var result = template(data);
    res.send(result);
  });
});

app.get('/assets/tutorial.mp4', function(req, res){
    var path = req.params[0] ? req.params[0] : 'index.html';
    res.sendFile("tutorial.mp4", {root: './assets'});
});
app.get('/assets/tutorial.ogv', function(req, res){
    var path = req.params[0] ? req.params[0] : 'index.html';
    res.sendFile("tutorial.ogv", {root: './assets'});
});

app.get('/previews/*.png', function(req, res){
    var path = req.params[0] ? req.params[0] : 'index.html';
    res.sendFile(path + ".png", {root: './previews'});
});

var server = app.listen(app.get("port"), function() {
    console.log('Listening on port %d', server.address().port);
});
