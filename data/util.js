// A utilities module for common tasks related to rendering our basemaps on CartoDB, including
// * Knowing how to manipulate project.json into MapConfigs for variant styles: 
//    light-labels, dark-labels, light-no-labels, dark-no-labels
// * Making authenticated requests to the CartoDB API.

// Please ensure that this file can be interpreted by both a NodeJS process and in the browser:
// It is useful in the browser for editing styles interactively,
// and useful from the command line for automating tasks like creating/updating Named Maps and generating static images.


var node = function() {
  var fs = require("fs");
  var md5 = require('MD5');
  var _ = require('underscore');

  var PROJECT = JSON.parse(fs.readFileSync("project.json"));
  var IMAGES_HOST = 'http://libs.cartocdn.com.s3.amazonaws.com/stamen-base/';

  var mapconfig_light = {'layers':[]};
  var mapconfig_dark = {'layers':[]};
  var mapconfig_light_nolabels = {'layers':[]};
  var mapconfig_dark_nolabels = {'layers':[]};
  var mapconfig_light_only_labels = {'layers':[]};
  var mapconfig_dark_only_labels = {'layers':[]};
  var mapconfig_light_only_lines = {'layers':[]};
  var mapconfig_dark_only_lines = {'layers':[]};
  var mapconfig_light_only_background = {'layers':[]};
  var mapconfig_dark_only_background = {'layers':[]};

  // change the host for the images
  function replaceImages(cartocss) {
    var images = cartocss.match(/https:\/\/dl.dropboxusercontent.com\/u\/[0-9]+\/[^\/]*(.*\.[ps][nv]g)/g);
    for (var i in images) {
      var image = images[i].split('/');
      image = image[image.length - 1];
      var hash = md5(fs.readFileSync('styles/images/' + image));
      cartocss = cartocss.replace(
        new RegExp('https:\/\/dl.dropboxusercontent.com\/u\/[0-9]+\/.*' + image, 'g'),
        IMAGES_HOST + image 
        // disabled hash: https://github.com/CartoDB/Windshaft-cartodb/issues/228
        //+ "?h=" + hash
      );
    }
    return cartocss;
  }


  PROJECT.layers.forEach(function(l) {
    // populate mapconfig_light with all layers except "global_variables_labels"
    new_layer = {'type':'cartodb','options':{'cartocss_version':'2.1.1'}};

    new_layer.name = l.name;
    new_layer.options.sql = l.options.sql;
    new_layer.options.cartocss = fs.readFileSync(l.options.cartocss_file).toString();
    if (l.name != "global_variables_labels") {
      //console.log(l.name);
      mapconfig_light.layers.push(new_layer);
    }
  });

  PROJECT.layers.forEach(function(l) {
    // populate mapconfig_dark with all layers except "global_variables_labels"
    // also, override the global_variables file with global_variables_dark.mss
    new_layer = {'type':'cartodb','options':{'cartocss_version':'2.1.1'}};

    new_layer.name = l.name;
    new_layer.options.sql = l.options.sql;
    if (l.name == "global_variables") {
      new_layer.options.cartocss = replaceImages(fs.readFileSync("styles/global_variables_dark.mss").toString())
    } else {
      new_layer.options.cartocss = replaceImages(fs.readFileSync(l.options.cartocss_file).toString())
    }
    if (l.name != "global_variables_labels") {
      mapconfig_dark.layers.push(new_layer);
    }
  });

  PROJECT.layers.forEach(function(l) {
    new_layer = {'type':'cartodb','options':{'cartocss_version':'2.1.1'}};
    // populate mapconfig_light_nolabels with all layers, but with empty data if layer toggle[2] is false

    new_layer.name = l.name;
    new_layer.options.sql = l.options.sql;
    if (!l.toggle[2]) new_layer.options.sql = new_layer.options.sql + " LIMIT 0;";
    new_layer.options.cartocss = replaceImages(fs.readFileSync(l.options.cartocss_file).toString());
    mapconfig_light_nolabels.layers.push(new_layer);
  });

  PROJECT.layers.forEach(function(l) {
    new_layer = {'type':'cartodb','options':{'cartocss_version':'2.1.1'}};
    // populate mapconfig_dark_nolabels with all layers, but with empty data if layer toggle[2] is false
    // also, override the global_variables file with global_variables_dark.mss

    new_layer.name = l.name;
    new_layer.options.sql = l.options.sql;
    if (!l.toggle[2]) new_layer.options.sql = new_layer.options.sql + " LIMIT 0;";
    if (l.name == "global_variables") {
      new_layer.options.cartocss = replaceImages(fs.readFileSync("styles/global_variables_dark.mss").toString());
    } else {
      new_layer.options.cartocss = replaceImages(fs.readFileSync(l.options.cartocss_file).toString());
    }
    mapconfig_dark_nolabels.layers.push(new_layer);
  });


  PROJECT.layers.forEach(function(l) {
    new_layer = {'type':'cartodb','options':{'cartocss_version':'2.1.1'}};
    // populate mapconfig_light_only_labels only if layer toggle[3] is true, or name is global_variables
    // also, override the global_variables file with global_variables_only_labels.mss

    new_layer.name = l.name;
    new_layer.options.sql = l.options.sql;
    if (l.name == "global_variables") {
      new_layer.options.cartocss = replaceImages(fs.readFileSync("styles/global_variables_only_labels.mss").toString());
      mapconfig_light_only_labels.layers.push(new_layer);
    } else if (l.toggle[3]) {
      new_layer.options.cartocss = replaceImages(fs.readFileSync(l.options.cartocss_file).toString());
      mapconfig_light_only_labels.layers.push(new_layer);
    }
  });

  PROJECT.layers.forEach(function(l) {
    new_layer = {'type':'cartodb','options':{'cartocss_version':'2.1.1'}};
    // populate mapconfig_dark_only_labels only if layer toggle[3] is true, or name is global_variables
    // also, override the global_variables file with global_variables_dark_only_labels.mss

    new_layer.name = l.name;
    new_layer.options.sql = l.options.sql;
    if (l.name == "global_variables") {
      new_layer.options.cartocss = replaceImages(fs.readFileSync("styles/global_variables_dark_only_labels.mss").toString());
      mapconfig_dark_only_labels.layers.push(new_layer);
    } else if (l.toggle[3]) {
      new_layer.options.cartocss = replaceImages(fs.readFileSync(l.options.cartocss_file).toString());
      mapconfig_dark_only_labels.layers.push(new_layer);
    }
  });

  PROJECT.layers.forEach(function(l) {
    new_layer = {'type':'cartodb','options':{'cartocss_version':'2.1.1'}};
    // populate mapconfig_light_only_lines only if layer toggle[4] is true, or name is global_variables
    // also, override the global_variables file with global_variables_only_labels.mss

    new_layer.name = l.name;
    new_layer.options.sql = l.options.sql;
    if (l.name == "global_variables") {
      new_layer.options.cartocss = replaceImages(fs.readFileSync("styles/global_variables_only_labels.mss").toString());
      mapconfig_light_only_lines.layers.push(new_layer);
    } else if (l.toggle[4]) {
      new_layer.options.cartocss = replaceImages(fs.readFileSync(l.options.cartocss_file).toString());
      mapconfig_light_only_lines.layers.push(new_layer);
    }
  });

  PROJECT.layers.forEach(function(l) {
    new_layer = {'type':'cartodb','options':{'cartocss_version':'2.1.1'}};
    // populate mapconfig_dark_only_lines with all layers, but with empty data if layer toggle[4] is false
    // also, override the global_variables file with global_variables_dark_only_labels.mss

    new_layer.name = l.name;
    new_layer.options.sql = l.options.sql;
    if (l.name == "global_variables") {
      new_layer.options.cartocss = replaceImages(fs.readFileSync("styles/global_variables_dark_only_labels.mss").toString());
      mapconfig_dark_only_lines.layers.push(new_layer);
    } else if (l.toggle[4]) {
      new_layer.options.cartocss = replaceImages(fs.readFileSync(l.options.cartocss_file).toString());
      mapconfig_dark_only_lines.layers.push(new_layer);
    }
  });

  PROJECT.layers.forEach(function(l) {
    new_layer = {'type':'cartodb','options':{'cartocss_version':'2.1.1'}};
    // populate mapconfig_light_only_background with all layers, but with empty data if layer toggle[5] is false

    new_layer.name = l.name;
    new_layer.options.sql = l.options.sql;
    if (!l.toggle[5]) new_layer.options.sql = new_layer.options.sql + " LIMIT 0;";
    new_layer.options.cartocss = replaceImages(fs.readFileSync(l.options.cartocss_file).toString());
    mapconfig_light_only_background.layers.push(new_layer);
  });

  PROJECT.layers.forEach(function(l) {
    new_layer = {'type':'cartodb','options':{'cartocss_version':'2.1.1'}};
    // populate mapconfig_dark_only_background with all layers, but with empty data if layer toggle[5] is false
    // also, override the global_variables file with global_variables_dark.mss

    new_layer.name = l.name;
    new_layer.options.sql = l.options.sql;
    if (!l.toggle[5]) new_layer.options.sql = new_layer.options.sql + " LIMIT 0;";
    if (l.name == "global_variables") {
      new_layer.options.cartocss = replaceImages(fs.readFileSync("styles/global_variables_dark.mss").toString());
    } else {
      new_layer.options.cartocss = replaceImages(fs.readFileSync(l.options.cartocss_file).toString());
    }
    mapconfig_dark_only_background.layers.push(new_layer);
  });

  PROJECT.layers.forEach(function(l) {
    new_layer = {'type':'cartodb','options':{'cartocss_version':'2.1.1'}};
    // populate mapconfig_light_only_buildings with all layers, but with empty data if layer toggle[6] is false
    // also, override the global_variables file with global_variables_only_labels.mss

    new_layer.name = l.name;
    new_layer.options.sql = l.options.sql;
    if (!l.toggle[5]) new_layer.options.sql = new_layer.options.sql + " LIMIT 0;";
    if (l.name == "global_variables") {
      new_layer.options.cartocss = replaceImages(fs.readFileSync("styles/global_variables_only_labels.mss").toString());
      mapconfig_light_only_buildings.layers.push(new_layer);
    } else if (l.toggle[5]) {
      new_layer.options.cartocss = replaceImages(fs.readFileSync(l.options.cartocss_file).toString());
      mapconfig_light_only_buildings.layers.push(new_layer);
    }
  });

  PROJECT.layers.forEach(function(l) {
    new_layer = {'type':'cartodb','options':{'cartocss_version':'2.1.1'}};
    // populate mapconfig_dark_only_buildings with all layers, but with empty data if layer toggle[6] is false
    // also, override the global_variables file with global_variables_dark_only_lables.mss

    new_layer.name = l.name;
    new_layer.options.sql = l.options.sql;
    if (!l.toggle[5]) new_layer.options.sql = new_layer.options.sql + " LIMIT 0;";
    if (l.name == "global_variables") {
      new_layer.options.cartocss = replaceImages(fs.readFileSync("styles/global_variables_dark_only_labels.mss").toString());
    } else {
      new_layer.options.cartocss = replaceImages(fs.readFileSync(l.options.cartocss_file).toString());
    }
    mapconfig_dark_only_buildings.layers.push(new_layer);
  });


  return {
    'mapconfig_light': mapconfig_light,
    'mapconfig_dark': mapconfig_dark,
    'mapconfig_light_nolabels': mapconfig_light_nolabels,
    'mapconfig_dark_nolabels': mapconfig_dark_nolabels,
    'mapconfig_light_only_labels': mapconfig_light_only_labels,
    'mapconfig_dark_only_labels': mapconfig_dark_only_labels,
    'mapconfig_light_only_lines': mapconfig_light_only_lines,
    'mapconfig_dark_only_lines': mapconfig_dark_only_lines,
    'mapconfig_light_only_background': mapconfig_light_only_background,
    'mapconfig_dark_only_background': mapconfig_dark_only_background,
    'mapconfig_light_only_buildings': mapconfig_light_only_buildings,
    'mapconfig_dark_only_buildings': mapconfig_dark_only_buildings
  };
}

module.exports = {'node':node};
