// Converts yaml to sql

var yaml = require('js-yaml');
var fs   = require('fs');
var request = require('request');

function tname(table_name) {
  return table_name;
}

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
request = request.defaults({"baseUrl": CARTODB_URL + '/api/v1/'});

var get_sql_from_view = function(view) {
    var pg_type = 'VIEW';
    if (view.materialized) {
      pg_type = 'MATERIALIZED VIEW';
    }
    var sql = "DROP "+pg_type+" IF EXISTS " + tname(view.name) + " CASCADE;";
    sql += "CREATE "+pg_type+" " + tname(view.name) + " AS";
    sql += "  SELECT id, " + view.select;
    sql += "    FROM "  + tname(view.from);
    sql += "    WHERE " + view.where;
    if (pg_type == 'MATERIALIZED VIEW') {
      if (view.cluster_on) {
        sql += "    ORDER BY ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(" + view.cluster_on + "), 3857), 4326));";
      } else {
        sql += ";";
      }
      sql += ("CREATE INDEX " + view.name + "_" + view.index_by + "_gist ON " +
                   tname(view.name) + " USING gist(" + view.index_by + ");");
      sql += ("CREATE UNIQUE INDEX ON " + tname(view.name) + " (id);");
      sql += ("ANALYZE " + tname(view.name) + ";\n");
    } else {
      sql += (";"); // Don't ORDER BY
      sql += ("CREATE INDEX IF NOT EXISTS \"" + view.from + "_view_" + view.name + "_idx\" ON " + tname(view.from) +
                  " USING GIST (" + view.index_by + ") WHERE (" + view.where + ");");
    }
    sql += ("");
  return sql;
};


if (process.argv.length == 2) {
  var doc = yaml.safeLoad(fs.readFileSync('generalizations.yml', 'utf8'));
  var views = {};
  var deps = {};

  doc.forEach(function(view) {
    deps[view.from] = deps[view.from] || [];
    deps[view.from].push(view.name);
    views[view.name] = view;
  });

  var getViewAndDependants = function(viewName) {
    sql = get_sql_from_view(views[viewName]);
    if(viewName in deps) {
      deps[viewName].forEach(function(dependant) {
        sql += getViewAndDependants(dependant);
      });
    }
    return sql;
  };

  deps.planet.forEach(function(viewName) {
    var sql = getViewAndDependants(viewName);
    request({
      method: 'POST',
      uri: 'sql/job',
      json: {
        query: sql,
        api_key: API_KEY
      }
    }, function(error, response, body) {
      console.log(body);
    });
  });
}


