# CartoDB Basemaps Data

Some parts of loading data onto a CartoDB instance require direct access, not access through the SQL API.

## Loading data
### Installing static data and coastlines
2. run `node import_files.js` to import Natural Earth and Coastline data to your instance. This requires your CartoDB instance have external internet connectivity. A total of about 750MB of space is required, of which 600MB is for coastline data.
3. Use [workarounds for z4to10](https://github.com/CartoDB/CartoDB-basemaps/issues/42)

### Importing OSM data

1. Install imposm3, e.g. from [Imposm3 static releases](http://imposm.org/static/rel/) or [building from source](https://github.com/omniscale/imposm3). The machine with Imposm3 must have PostgreSQL access to your CartoDB instance.
2. Download OpenStreetMap data from [planet.openstreetmap.org](http://planet.openstreetmap.org/), [Geofabrik Extracts](http://download.geofabrik.de/), or [Mapzen Metro Extracts](https://mapzen.com/data/metro-extracts).
3. Change the default statement timeout with ``export PGOPTIONS="-c statement_timeout=0"``. Also setting `PGHOST`, `PGUSER`, and `PGDATABASE` can simplify command lines.
4. Enable hstore on the database with ``psql -U postgres -d cartodb_user_databaseid` -c 'CREATE EXTENSION hstore;'``
5. Import an OSM extract into your db, using `imposm3_mapping.json`. This can be done with
  ```sh
  imposm3 import -mapping imposm3_mapping.json \
    -read path/to/extract.osm.pbf -write \
    -deployproduction -overwritecache
  ```
  If `PGHOST` and other libpq environment variables are set, the connection string can be simplified to `-connection='postgis://?prefix=NONE'`

6. Import `global_functions.sql` into your DB with `node cartodb_sql.js -f global_functions.sql`
7. run `node generalizations_sql.js public postgres:///` into your DB, setting the connection string as appropriate.

8. Grant usage of the materialized views with `GRANT SELECT ON ALL TABLES IN SCHEMA public TO PUBLIC`

8. Ensure the Azo Sans, DejaVu unicode, unifont fonts are available on your instance.
9. Open index.html to see your basemap being rendered from CartoDB. The styles will be regenerated on refresh.
