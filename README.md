# CartoDB Basemaps

This is the source code and styles for the [CartoDB Basemaps](http://cartodb.com/basemaps), designed by [Stamen](http://stamen.com).

The code and styles here are intended for serving the basemaps on your own local CartoDB instance, if you just want to use them for your own map, you should use our [hosted version](http://cartodb.com/basemaps).

### What does what?

* All CartoCSS styles live in `/styles`. The Tilemill Project MML (used for local Tilemill 1) and the `project.json` in the root (used for CartoDB) need to be manually kept in sync. Each layer should have a name the same as its CartoCSS ID, and a call to a SQL function.
	* The oddness here has to do with Tilemill and CartoDB parsing SQL differently, and also because CartoDB does not support zoom-dependent layers yet; so we instead make layers zoom-dependent by writing PL/PGSQL functions that take a mapnik `!scaleDenominator!`.
	* The stylesheet `global_variables` may be substituted in variant styles e.g. Dark Map.
	
* The `project.json` is transformed into a Windshaft MapConfig via `util.js`. All util does is inline text from stylesheets, and possibly toggles layers depending on which "toggle set" (e.g. Labels Off) they belong to. Disabling a layer is done by appending LIMIT 0 to the SQL query.

* There's two places where database stuff (materialized views, PL/PGSQL functions) is defined.
	* `global_functions.sql` is where all the functions go. This needs to be loaded first.
	* generalizations.yml describes the materialized views, this is read by `generalizations_sql.js` to output either raw SQL or issue queries.


### Getting started

Create a file in the root of this directory called `config.json` with your CartoDB host and API key like this:

```json
{
  "api_key": "API_KEY",
  "cdb_url": "https://myuser.cartodb.com"
}
```

### Development on a CartoDB instance

1. run `node import_files.js` to import Natural Earth and Coastline data to your instance
2. Import an OSM extract into your db, using `imposm3_mapping.json`. See the Makefile or https://github.com/cartodb/osm
3. import `global_functions.sql` into your DB.
4. run `generalizations_sql.js` into your DB.
5. Ensure the Azo Sans, DejaVu unicode, unifont fonts are available on your instance.
6. Open index.html to see your basemap being rendered from CartoDB. The styles will be regenerated on refresh.

### Development locally using Tilemill

1. run `sh download_datasets.sh` to get all the Natural Earth and OSM coastline files.
2. Run `make database` to create the `cartodb_basemaps` PostGIS database
2. Run `make coastline` to get the water/land polygons into your DB
3. Import an OSM extract into your db. see the Makefile and edit the example `san_francisco` task as needed.
4. run `sh ne2pgsql.sh` to import Natural Earth shapefiles locally such that they resemble CartoDB tables. This also imports the `z4to10.json` file from this repository, which is a hand-curated list of low zoom city points.
5. import `global_functions.sql` into your DB (or run `make globals`)
6. run `generalizations_sql.js` into your DB (or run `make generalizations`)
7. run `make install` to get a local TileMill project
8. You may need the Azo Sans, DejaVu unicode, unifont fonts installed.

That should be it for getting the project running in a local TileMill.

### Creating generalizations

The generalizations go into a different schema that the style (project.json) refers to. Creating all the materialized view takes 6-7 hours for the full planet (and requires that this be run on a machine with `psql` access).
You can speed up the generalization creation by using the script and specifying a bigger amount of threads.

To create these:

    nodejs generalizations_sql.js [TARGET_SCHEMA_NAME] [DATABASE_URL] [THREADS]
    
(On Debian, `nodejs` is the node executable.)

This creates `MATERIALIZED VIEWS` with the subsets of data required for each zoom.

As materialized view creation / refreshing is blocking process (as of PostgreSQL 9.3), you can use
`TARGET_SCHEMA_NAME` to create the generalizations into different schemas 
(`planet_blue` or `planet_green`, for example) and then, when done,
switch the schema referred to in project.json.

If you want to develop against CartoDB on an extract you can derive an extract from an existing OSM dump on `public.planet` like follows:

    CREATE MATERIALIZED VIEW sf_madrid AS
    SELECT id, osm_id, tags, the_geom
    FROM public.planet
    WHERE the_geom && ST_Transform(ST_SetSRID('BOX(-122.737 37.449,-122.011 37.955)'::box2d, 4326), 3857) OR
    the_geom && ST_Transform(ST_SetSRID('BOX(-4.293 39.8,-3.057 41.03)'::box2d, 4326), 3857) OR
    ORDER BY ST_GeoHash(ST_Transform(the_geom, 4326));
    CREATE INDEX planet_the_geom_gist ON sf_madrid USING GIST(the_geom);

and build your generalizations off this instead of public.planet.

### Named map creation

To create a "Named Map", so users can access the basemap without API key, running `make named_maps` will create them using the local styles.

