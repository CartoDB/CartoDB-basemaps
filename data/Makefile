.PHONY: previews dev

##### Development tasks that interact with CartoDB #####
# Generate image previews

dev: ../config.json
	python -m SimpleHTTPServer 8080 .

previews: ../config.json
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
