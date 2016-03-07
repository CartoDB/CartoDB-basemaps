# CartoDB Basemaps Data

Some parts of loading data onto a CartoDB instance require direct access, not access through the SQL API.

## Loading data
### Installing static data and coastlines
1. Run `node import_files.js` to import Natural Earth and other static data. This requires your CartoDB instance have external internet connectivity. A total of about 150MB of space is required.
2. Run `node import_sync.js` to import coastline data. This requires your CartoDB instance have external internet connectivity. A total of about 600MB of space is required.

### Importing OSM data
1. Install imposm3, e.g. from [Imposm3 static releases](http://imposm.org/static/rel/) or [building from source](https://github.com/omniscale/imposm3). The machine with Imposm3 must have PostgreSQL access to your CartoDB instance.
2. Set PostgreSQL environment variables with
  ```sh
export PGUSER=cartodb_user_uid
export PGDATABASE="${PGUSER}_db"
# Required so imposm3 won't time out
export PGOPTIONS="-c statement_timeout=0"
# Setting PGHOST allows use of sockets. This may need adjusting on different OSes, or for network connections
# See https://github.com/omniscale/imposm3/issues/43
export PGHOST=/var/run/postgresql
```
3. Download OpenStreetMap data from [planet.openstreetmap.org](http://planet.openstreetmap.org/), [Geofabrik Extracts](http://download.geofabrik.de/), or [Mapzen Metro Extracts](https://mapzen.com/data/metro-extracts).
4. Enable hstore on the database with ``psql -U postgres -c 'CREATE EXTENSION IF NOT EXISTS hstore;'``
  *PostGIS was previously set up by the static data instructions.*
5. *Optional: Remove previous imposm3 imports with*
  ```sh
  psql -c 'DROP TABLE IF EXISTS planet CASCADE; DROP SCHEMA IF EXISTS import CASCADE; DROP SCHEMA IF EXISTS backup CASCADE;'
```
  *If planning on consuming replication updates from OSM, read the updating section before running these commands*
6. Import an OSM extract into your db, using `imposm3_mapping.json`. This can be done with
  ```sh
  imposm3 import -mapping imposm3_mapping.json \
    -connection='postgis://?prefix=NONE' \
    -read path/to/extract.osm.pbf -write \
    -deployproduction -overwritecache
  ```
*Imposm3 has additional options which are worth exploring for larger imports*

7. Import `core_functions.sql` into your DB with `node cartodb_sql.js -f core_functions.sql`
8. run `node generalizations_sql.js | node cartodb_sql.js -f /dev/stdin` into your DB. If dealing with a full planet extract, this should be done on the database server with `node generalizations_sql.js | psql`.
  *It can be more efficient to run this on the DB server in parallel*
9. Import `global_functions.sql` into your DB with `node cartodb_sql.js -f global_functions.sql`

10. Ensure the Azo Sans, DejaVu unicode, unifont fonts are available on your instance.

## Updating data
### Coastlines and other quasi-static data

TODO: Convert static data instructions to use sync tables

### OpenStreetMap data
Updating OpenStreetMap data requires importing the data slightly differently. Instead of the command line above, add the ``-cachedir`` option to set a persistent cache directory, and the ``-diff`` option to store some additional data.

The PGUSER and other libpq environment variables need to be set like above.

```sh
# Because we're going to use it a lot, set the cache directory to a variable
imposm3 import -mapping imposm3_mapping.json \
  -cachedir imposm3_cache -diff
  -connection='postgis://?prefix=NONE' \
  -read path/to/extract.osm.pbf -write \
  -deployproduction -overwritecache
```

The global functions and generalizations are created like normal.

A sample script that uses Osmosis to fetch diffs is included as replicate.sh. To
set up the script on Ubuntu using the user `ubuntu`, do

```sh
mkdir -p /home/ubuntu/replicate
cd /home/ubuntu/replicate
git clone https://github.com/CartoDB/CartoDB-basemaps.git # note: won't work until develop branch is merged
# download imposm3 into an imposm3 directory
# import, using replicate/imposm3_cache as a cache dir
osmosis --rrii
# edit configuration.txt if needed
# download an appropriate state.txt
```

For production purposes, you probably want to put the script into Chef or similar, and change some paths.

### Refreshing views
To generate the SQL necessary to update the views, run `node refresh.js`.
