var abaculus = require("abaculus");
var tilelive = require("tilelive");
var fs = require("fs");
var request = require('request');
var util = require('./util.js');

require("tilelive-http")(tilelive);
require("http").globalAgent.maxSockets = 1;

var SF = {x: -122.4195, y: 37.7649, file_prefix: "sf_"};
var MADRID = {x: -3.7005, y: 40.4345, file_prefix: "madrid_"};
var cities = [SF, MADRID];
var CONFIG = JSON.parse(fs.readFileSync("config.json"));

// light set
var images_list_light = [];
for(var z = 0; z <= 18; z++) {
  cities.forEach(function(city) {
    images_list_light.push({filename: "previews/" + city.file_prefix + z + ".png", x: city.x, y: city.y, z:z});
  });
}
var get_light = {
  method: "post",
  uri: CONFIG.cdb_url + '/api/v1/map?map_key=' + CONFIG.api_key,
  json: util.node().mapconfig_light
}

// light set no labels
var images_list_light_nolabels = [];
for(var z = 0; z <= 18; z++) {
  cities.forEach(function(city) {
    images_list_light_nolabels.push({filename: "previews/nolabels_" + city.file_prefix + z + ".png", x: city.x, y: city.y, z:z});
  });
}
var get_light_nolabels = {
  method: "post",
  uri: CONFIG.cdb_url + '/api/v1/map?map_key=' + CONFIG.api_key,
  json: util.node().mapconfig_light_nolabels
}

// dark set
var images_list_dark = [];
for(var z = 0; z <= 18; z++) {
  cities.forEach(function(city) {
    images_list_dark.push({filename: "previews/dark_" + city.file_prefix + z + ".png", x: city.x, y: city.y, z:z});
  });
}
var get_dark = {
  method: "post",
  uri: CONFIG.cdb_url + '/api/v1/map?map_key=' + CONFIG.api_key,
  json: util.node().mapconfig_dark
}

// dark set no labels
var images_list_dark_nolabels = [];
for(var z = 0; z <= 18; z++) {
  cities.forEach(function(city) {
    images_list_dark_nolabels.push({filename: "previews/dark_nolabels_" + city.file_prefix + z + ".png", x: city.x, y: city.y, z:z});
  });
}
var get_dark_nolabels = {
  method: "post",
  uri: CONFIG.cdb_url + '/api/v1/map?map_key=' + CONFIG.api_key,
  json: util.node().mapconfig_dark_nolabels
}

function getImages(the_get, the_image_list) {
  request(the_get, function (error, response, body) {
    if (error) {
      console.log(error);
      return
    }

    if (response.statusCode != 200) {
      console.log(body);
      return
    }

    tilelive.load(CONFIG.cdb_url + "/api/v1/map/" + body.layergroupid + "/{z}/{x}/{y}.png?map_key=" + CONFIG.api_key, function(err,source) {
      var makeImage = function(x,y,z,filename) {
        var params = {
          zoom: z,
          scale: 1,
          center: {
            x: x,
            y: y,
            w: 600,
            h: 400
          },
          format: "png",
          getTile: source.getTile.bind(source)
        };

        abaculus(params, function(err, image){
          if (err) return err;
          fs.open(filename,"w+",function(err,fd) {
            fs.write(fd, image,0,image.length,null, function(err) {
              fs.close(fd, function() {
                console.log("Wrote " + filename);
              });
            })
          });
        });
      }

      the_image_list.forEach(function(i) {
        makeImage(i.x,i.y,i.z,i.filename);
      });
    });
  })
}

getImages(get_light, images_list_light)
getImages(get_light_nolabels, images_list_light_nolabels)
getImages(get_dark, images_list_dark)
getImages(get_dark_nolabels, images_list_dark_nolabels)
