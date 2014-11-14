.PHONY: previews dev

##### Development tasks for rendering the map all on local machine #####
# Prepare the local database using the CartoDB hstore style
san_francisco:
	dropdb --if-exists cartodb_basemaps
	createdb cartodb_basemaps
	psql -d cartodb_basemaps -c "create extension postgis"
	psql -d cartodb_basemaps -c "create extension hstore"
	imposm3 import -mapping imposm3_mapping.json -read /Volumes/Work/osm/sf-bay-area.osm.pbf -connection="postgis://localhost/cartodb_basemaps" -write -deployproduction -overwritecache
	psql -d cartodb_basemaps -c "ALTER TABLE osm_planet rename to planet"

# zooms 8 and below, use simplified Land polygons
# zooms 9 and above, use split Water polygons so the coast can be drawn over parks that jut into the water
coastline:
	ogr2ogr -lco GEOMETRY_NAME=the_geom_webmercator -lco FID=cartodb_id -overwrite -f "PostgreSQL" PG:"host=localhost dbname=cartodb_basemaps" simplified-land-polygons-complete-3857/simplified_land_polygons.shp
	ogr2ogr -lco GEOMETRY_NAME=the_geom_webmercator -lco FID=cartodb_id -overwrite -f "PostgreSQL" PG:"host=localhost dbname=cartodb_basemaps" water-polygons-split-3857/water_polygons.shp

generalizations:
	node generalizations_sql.js public postgres://localhost/cartodb_basemaps

globals:
	psql cartodb_basemaps -f global_functions.sql

# Install project into user's TileMill 1 directory
install:
	mkdir -p ${HOME}/Documents/MapBox/project
	ln -sf "`pwd`/tilemill" ${HOME}/Documents/MapBox/project/cartodb-basemap

##### Development tasks that interact with CartoDB #####
# Generate image previews

dev: config.json
	python -m SimpleHTTPServer 8080 .

previews: config.json
	node generate_previews.js

##### Deployment tasks #####

named_maps:
	node generate_named_maps.js

cartodb_globals:
	node cartodb_sql.js -f global_functions.sql

stat_reset:
	node cartodb_sql.js -c "select stat_reset();"

cartodb_generalizations:
	ifndef DATABASE_URL
		$(error DATABASE_URL is undefined)
	endif
	ifndef VIEW_SCHEMA 
		$(error VIEW_SCHEMA is undefined)
	endif
	node generalizations_sql.js $(VIEW_SCHEMA) $(DATABASE_URL)
