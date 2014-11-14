// Converts yaml to sql

var yaml = require('js-yaml');
var fs   = require('fs');
var pg   = require('pg'); 
var async = require('async');

var default_schema = null;
var database_url = null;

process.argv.forEach(function (val, index, array) {
  if (index == 2) default_schema = val;
  if (index == 3) database_url = val;
});

if (process.argv.length < 3) {
  console.log("arguments SCHEMA DATABASE_URL");
  process.exit();
}

// fully qualified table name
function tname(table_name) {
  if (table_name.indexOf(".") >= 0) return table_name;
  return default_schema + "." + table_name;
}


if (process.argv.length == 3) {
  // Write SQL to STDOUT
  var doc = yaml.safeLoad(fs.readFileSync('generalizations.yml', 'utf8'));
  console.log("CREATE SCHEMA IF NOT EXISTS " + default_schema + ";");
  doc.forEach(function(view) {
    console.log("DROP MATERIALIZED VIEW IF EXISTS " + tname(view.name) + " CASCADE;");  
    console.log("CREATE MATERIALIZED VIEW " + tname(view.name) + " AS" +
                " SELECT " + view.select + 
                " FROM "  + tname(view.from) + 
                " WHERE " + view.where + 
                " ORDER BY ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(" + view.cluster_on + "), 3857), 4326));");
    console.log("CREATE INDEX " + view.name + "_" + view.index_by + "_gist ON " + 
                 tname(view.name) + " USING gist(" + view.index_by + ");");
  });
  console.log("ANALYZE;");
}

function queryFunction(sql) {
  return function(callback) {
    pg.connect(database_url, function(err,client,done) {
      if(err) {
        console.error('error fetching client from pool', err);
        callback(err);
      }
      console.log("Issuing query " + sql);
      console.time('query');
      client.query(sql, function(err, result) {
        //call `done()` to release the client back to the pool
        done();
          console.timeEnd('query');

        if(err) {
          console.error('error running query', err);
          callback(err);
        }
        callback(null,"Success");
      });
    });
  }
}

function queriesFor(view) {
  var arr = [];
  arr.push(queryFunction("DROP MATERIALIZED VIEW IF EXISTS " + tname(view.name) + " CASCADE;"));
  arr.push(queryFunction("CREATE MATERIALIZED VIEW " + tname(view.name) + " AS" +
                " SELECT " + view.select + 
                " FROM "  + tname(view.from) + 
                " WHERE " + view.where + 
                " ORDER BY ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(" + view.cluster_on + "), 3857), 4326));"));
  arr.push(queryFunction("CREATE INDEX " + view.name + "_" + view.index_by + "_gist ON " + 
                 tname(view.name) + " USING gist(" + view.index_by + ");"));
  return arr;
}

if (process.argv.length == 4) {
  console.log("Using database " + database_url);
  var doc = yaml.safeLoad(fs.readFileSync('generalizations.yml', 'utf8'));
  var queryFunctions = [];
  // create an array of functions to call and stuff
  queryFunctions.push(queryFunction("CREATE SCHEMA IF NOT EXISTS " + default_schema + ";"));
  doc.forEach(function(view) {
    queriesFor(view).forEach(function(q) { queryFunctions.push(q) });
  });

  async.series(queryFunctions, function(err,results) {
    if(err) console.error(err);
  });
}
