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
    var pg_type = 'VIEW';
    if (view.materialized) {
      var pg_type = 'MATERIALIZED VIEW';
    }
    console.log("DROP "+pg_type+" IF EXISTS " + tname(view.name) + " CASCADE;");
    console.log("CREATE "+pg_type+" " + tname(view.name) + " AS");
    console.log("  SELECT id, " + view.select);
    console.log("    FROM "  + tname(view.from));
    console.log("    WHERE " + view.where);
    if (pg_type == 'MATERIALIZED VIEW') {
      if (view.cluster_on) {
        console.log("    ORDER BY ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(" + view.cluster_on + "), 3857), 4326));");
      } else {
        console.log(";");
      }
      console.log("CREATE INDEX " + view.name + "_" + view.index_by + "_gist ON " +
                   tname(view.name) + " USING gist(" + view.index_by + ");");
      console.log("CREATE UNIQUE INDEX ON " + tname(view.name) + " (id);");
      console.log("ANALYZE " + tname(view.name) + ";\n");
    } else {
      console.log(";"); // Don't ORDER BY
      console.log("CREATE INDEX IF NOT EXISTS \"" + view.from + "_view_" + view.name + "_idx\" ON " + tname(view.from) +
                  " USING GIST (" + view.index_by + ") WHERE (" + view.where + ");");
    }
    console.log("");
  });
  console.log("RESET client_min_messages;");
}


