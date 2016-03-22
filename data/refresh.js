// Converts yaml to sql

var yaml = require('js-yaml');
var fs   = require('fs');

function tname(table_name) {
return table_name;
}


// Write SQL to STDOUT
var doc = yaml.safeLoad(fs.readFileSync('generalizations.yml', 'utf8'));
console.log("SET client_min_messages TO WARNING;");
console.log("SET statement_timeout = 0;\n")
doc.forEach(function(view) {
    // Regular views require no refreshing
    if (view.materialized) {
        console.log("REFRESH MATERIALIZED VIEW CONCURRENTLY " + tname(view.name) + ";");
    }
});
console.log("\nRESET client_min_messages;");
    