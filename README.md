# CartoDB Basemaps

This is the source code and styles for the [CartoDB Basemaps](http://cartodb.com/basemaps), designed by [Stamen](http://stamen.com).

The code and styles here are intended for serving the basemaps on your own local CartoDB instance and developing the styles, if you just want to use them for your own map, you should use our [hosted version](http://cartodb.com/basemaps).

## What does what?

This style is designed to work with CartoDB and Windshaft, so is structured differently than a standard CartoCSS project.

* All CartoCSS styles live in [`/styles`](styles/). Layers for a map style are defined in named YAML files in the root directory, and it selects layers from the layers catalog in [`layers.yml`](layers.yml).

* The map style layers file is combined with the catalog using [cartodb-yaml](https://github.com/stamen/cartodb-yaml)

* There's two places where database stuff (materialized views, PL/PGSQL functions) are defined.
	* [`global_functions.sql`](data/global_functions.sql) is where all the functions go. This needs to be loaded first.
	* [`generalizations.yml`](data/generalizations.yml) describes the materialized views, this is read by `generalizations_sql.js` to output either raw SQL or issue queries.


## Setup

Install the required software with `npm install`

### Authentication

Create a the file `config.json` in this directory with your CartoDB host and API key. An example is [`config.json.template`](config.json.template).

```json
{
  "api_key": "API_KEY",
  "cdb_url": "https://myuser.cartodb.com"
}
```

You can find the API key at https://myuser.cartodb.com/your_apps

## Loading data

Instructions for loading data into a CartoDB instance can be found in [the data readme](data/README.md).

## Development

This style is intended to be used with the [Atom text editor](*https://atom.io/) and [CartoDB extension](https://github.com/stamen/atom-cartodb).

1. [Download and install Atom](https://atom.io/).
2. Install the cartodb and language-carto packages.
3. [Set the CartoDB username (e.g. `myuser`) and API key](https://github.com/stamen/atom-cartodb#configuration)
4. Open a map YAML file, e.g. [positron-all.yml](positron-all.yml).
5. Under Packages -> CartoDB, open a preview

## Named map creation

To let users access the basemap without an API key, the script `create_named.js` can be used.

For the six maps listed on [the basemap page](https://cartodb.com/basemaps) this can be done with

```sh
node create_named.js positron-all.yml light_all
node create_named.js positron-no-labels.yml light_nolabels
node create_named.js positron-labels-only.yml light_only_labels
node create_named.js dark-matter-all.yml dark_all
node create_named.js dark-matter-no-labels.yml dark_nolabels
node create_named.js dark-matter-labels-only.yml dark_only_labels
```

## Versioning

This project follows a MAJOR.MINOR.PATCH versioning system. In the context of a cartographic project you can expect the following:

PATCH: When a patch version is released, there would be no reason not to upgrade. PATCH versions contain only bugfixes e.g. stylesheets won't compile, features are missing by mistake, etc.

MINOR: These are routine releases. They will contain changes to what's shown on the map, how they appear, new features added and old features removed. They may rarely contain changes to assets i.e. shapefiles and fonts but will not contain changes that require software or database reloads. They may contain function or view changes that can be done without downtime or a reload.

MAJOR: Any change the requires reloading a database, or upgrading software dependecies will trigger a major version change.

The `master` branch only contains versions tagged and released, while work is merged to the `develop` branch.

## Releases

Commits from the develop branch are automatically pushed to the develop basemap server by Travis. Releases require manually pushing to the production server with `create_named.js`.
