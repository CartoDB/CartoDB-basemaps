var fs = require("fs");
var request = require('request');
var CONFIG = JSON.parse(fs.readFileSync("../config.json"));
var SQL = "SELECT calls, (total_time / 1000 / 60) as total_minutes, (total_time/calls) as average_time, query FROM pg_stat_statements ORDER BY average_time DESC LIMIT 100;"

var post = {
  method: "post",
  uri: CONFIG.cdb_url + '/api/v1/sql?api_key=' + CONFIG.api_key,
  form: {q: SQL}
}
request(post, function (error, response, body) {
  if (error || response.statusCode != 200) {
    console.log(error);
    console.log(body);
    return
  }

  body = JSON.parse(body);
  body.rows.forEach(function(row) {
    if (row.query.indexOf("<insufficient") == -1) {
      console.log(row.calls + "\t" + Math.round(row.average_time) + "\t" + row.query);
    }
  });
})

