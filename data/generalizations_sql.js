// Converts yaml to sql

var yaml = require('js-yaml');
var fs   = require('fs');

function tname(table_name) {
  return table_name;
}


if (process.argv.length == 2) {
  // Write SQL to STDOUT
  var doc = yaml.safeLoad(fs.readFileSync('generalizations.yml', 'utf8'));
  console.log("SET client_min_messages TO WARNING;");
  console.log("SET statement_timeout = 0;\n")
  doc.forEach(function(view) {
    console.log("DROP "+pg_type+" IF EXISTS " + tname(view.name) + " CASCADE;");
    console.log("CREATE "+pg_type+" " + tname(view.name) + " AS" +
                " SELECT id, " + view.select +
                " FROM "  + tname(view.from) + 
                " WHERE " + view.where + 
                " ORDER BY ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(" + view.cluster_on + "), 3857), 4326));");
    console.log("CREATE INDEX " + view.name + "_" + view.index_by + "_gist ON " + 
                 tname(view.name) + " USING gist(" + view.index_by + ");");
    console.log("CREATE UNIQUE INDEX ON " + tname(view.name) + " (id);");
    console.log("ANALYZE " + tname(view.name) + ";\n");
  });
  console.log("RESET client_min_messages;");
}


