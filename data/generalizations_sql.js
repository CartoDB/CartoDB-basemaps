// Converts yaml to sql

var yaml = require('js-yaml');
var fs   = require('fs');
var pg   = require('pg'); 
var async = require('async');

var default_schema = null;
var database_url = null;
var pg_type = 'MATERIALIZED VIEW';
var threads = 1;

process.argv.forEach(function (val, index, array) {
  if (index == 2) default_schema = val;
  if (index == 3) database_url = val;
  if (index == 4) threads = parseInt(val);
});

if (process.argv.length < 3) {
  console.log("arguments SCHEMA [DATABASE_URL] [PARALLEL_THREADS]");
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
  console.log("SET client_min_messages TO WARNING;\n");
  console.log("CREATE SCHEMA IF NOT EXISTS " + default_schema + " CASCADE;");
  doc.forEach(function(view) {
    console.log("DROP "+pg_type+" IF EXISTS " + tname(view.name) + ";");  
    console.log("CREATE "+pg_type+" " + tname(view.name) + " AS" +
                " SELECT " + view.select + 
                " FROM "  + tname(view.from) + 
                " WHERE " + view.where + 
                " ORDER BY ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(" + view.cluster_on + "), 3857), 4326));");
    console.log("CREATE INDEX " + view.name + "_" + view.index_by + "_gist ON " + 
                 tname(view.name) + " USING gist(" + view.index_by + ");");
    console.log("ANALYZE " + tname(view.name) + ";\n");
  });
  console.log("RESET client_min_messages;");
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
  arr.push(queryFunction("DROP "+pg_type+" IF EXISTS " + tname(view.name) + " CASCADE;"));
  arr.push(queryFunction("CREATE "+pg_type+" " + tname(view.name) + " AS" +
                " SELECT " + view.select + 
                " FROM "  + tname(view.from) + 
                " WHERE " + view.where + 
                " ORDER BY ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(" + view.cluster_on + "), 3857), 4326));"));
  arr.push(queryFunction("CREATE INDEX " + view.name + "_" + view.index_by + "_gist ON " + 
                 tname(view.name) + " USING gist(" + view.index_by + ");"));
  arr.push(queryFunction("ANALYZE " + tname(view.name) + ";"));
  return arr;
}

if (process.argv.length == 4 || process.argv.length == 5) {
  console.log("Using database " + database_url);
  var doc = yaml.safeLoad(fs.readFileSync('generalizations.yml', 'utf8'));
  var queryFunctions = [];
  // create an array of functions to call and stuff
  queryFunctions.push(queryFunction("CREATE SCHEMA IF NOT EXISTS " + default_schema + ";"));
  doc.forEach(function(view) {
    queriesFor(view).forEach(function(q) { queryFunctions.push(q) });
  });

  async.parallelLimit(queryFunctions, threads, function(err,results) {
    if(err) console.error(err);
  });
}
