.PHONY: previews dev

database:
	dropdb --if-exists cartodb_basemaps
	createdb cartodb_basemaps
	psql -d cartodb_basemaps -c "create extension postgis"
	psql -d cartodb_basemaps -c "create extension hstore"

##### Development tasks for rendering the map all on local machine #####
# Prepare the local database using the CartoDB hstore style

san_francisco:
	imposm3 import -mapping imposm3_mapping.json -read /Volumes/Work/osm/sf-bay-area.osm.pbf -connection="postgis://localhost/cartodb_basemaps" -write -deployproduction -overwritecache
	psql -d cartodb_basemaps -c "ALTER TABLE osm_planet rename to planet"

generalizations:
	npm install
	node generalizations_sql.js public postgres://localhost/cartodb_basemaps

globals:
	psql cartodb_basemaps -f global_functions.sql

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


basemap_light_only_labels:
	node make_named_map.js mapconfig_light_only_labels light_only_labels > /tmp/basemap.json
	curl -X DELETE -H 'content-type: application/json' -d @/tmp/basemap.json https://basemaps.cartodb.com/api/v1/map/named/light_only_labels\?api_key=$(CARTODB_API_KEY)
	curl -H 'content-type: application/json' -d @/tmp/basemap.json https://basemaps.cartodb.com/api/v1/map/named\?api_key=$(CARTODB_API_KEY)
	rm -rf /tmp/basempap.json

basemap_dark_only_labels:
	node make_named_map.js mapconfig_dark_only_labels dark_only_labels > /tmp/basemap.json
	curl -X DELETE -H 'content-type: application/json' -d @/tmp/basemap.json https://basemaps.cartodb.com/api/v1/map/named/dark_only_labels\?api_key=$(CARTODB_API_KEY)
	curl -H 'content-type: application/json' -d @/tmp/basemap.json https://basemaps.cartodb.com/api/v1/map/named\?api_key=$(CARTODB_API_KEY)
	rm -rf /tmp/basempap.json

basemap_light_all:
	node make_named_map.js mapconfig_light staging_light > /tmp/basemap.json
	curl -X DELETE -H 'content-type: application/json' -d @/tmp/basemap.json https://basemaps.cartodb.com/api/v1/map/named/staging_light\?api_key=$(CARTODB_API_KEY)
	curl -H 'content-type: application/json' -d @/tmp/basemap.json https://basemaps.cartodb.com/api/v1/map/named\?api_key=$(CARTODB_API_KEY)
	rm -rf /tmp/basempap.json
	open "tools/test_basemap.html"

basemap_dark_all:
	node make_named_map.js mapconfig_dark staging_dark > /tmp/basemap.json
	curl -X DELETE -H 'content-type: application/json' -d @/tmp/basemap.json https://basemaps.cartodb.com/api/v1/map/named/staging_dark\?api_key=$(CARTODB_API_KEY)
	curl -H 'content-type: application/json' -d @/tmp/basemap.json https://basemaps.cartodb.com/api/v1/map/named\?api_key=$(CARTODB_API_KEY)
	rm -rf /tmp/basempap.json
	open "tools/test_basemap.html"
