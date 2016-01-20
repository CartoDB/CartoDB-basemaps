# CartoDB Basemaps

This is the source code and styles for the [CartoDB Basemaps](http://cartodb.com/basemaps), designed by [Stamen](http://stamen.com).

The code and styles here are intended for serving the basemaps on your own local CartoDB instance, if you just want to use them for your own map, you should use our [hosted version](http://cartodb.com/basemaps).

### What does what?

This style is designed to work with CartoDB and Windshaft, so is structured differently than a standard CartoCSS project.

* All CartoCSS styles live in [`/styles`](styles/). Layers for a map style are defined in named YAML files in the root directory, and select layers from the layers catalog in [`layers.yml`](layers.yml).

* The map style layers file is combined with the catalog using [cartodb-yaml](https://github.com/stamen/cartodb-yaml)

* There's two places where database stuff (materialized views, PL/PGSQL functions) is defined.
	* [`global_functions.sql`](data/global_functions.sql) is where all the functions go. This needs to be loaded first.
	* [`generalizations.yml`](data/generalizations.yml) describes the materialized views, this is read by `generalizations_sql.js` to output either raw SQL or issue queries.

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

