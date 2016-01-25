var fs = require("fs");
var request = require('request');
var CONFIG = JSON.parse(fs.readFileSync("../config.json"));

if (process.argv[2] == '-c') {
  var post = {
    method: "post",
    uri: CONFIG.cdb_url + '/api/v1/sql',
    form: {q: process.argv[3], api_key: CONFIG.api_key}
  }
  request(post, function (error, response, body) {
    if (error || response.statusCode != 200) {
      console.log(error);
      console.log(body);
      return
    }
    console.log(body);
  })
}

if (process.argv[2] == '-f') {
  var sql = fs.readFileSync(process.argv[3]);
  var post = {
    method: "post",
    uri: CONFIG.cdb_url + '/api/v1/sql',
    form: {q: sql, api_key: CONFIG.api_key}
  }
  request(post, function (error, response, body) {
    if (error || response.statusCode != 200) {
      console.log(error);
      console.log(body);
      return
    }
    console.log(body);
  })
}

