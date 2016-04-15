-- Migrates from 2.0.0 to 2.1.0
\i ../data/core_functions.sql
-- highroad_z15plus
CREATE MATERIALIZED VIEW highroad_z15plus_new AS
  SELECT id, the_geom AS the_geom_webmercator, tags -> 'highway' as highway, tags -> 'railway' as railway, (CASE WHEN tags -> 'highway' IN ('motorway', 'motorway_link') THEN 'highway' WHEN tags -> 'highway' IN ('trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link') THEN 'major_road' WHEN tags -> 'highway' IN ('footpath', 'track', 'footway', 'steps', 'pedestrian', 'path', 'cycleway') THEN 'path' WHEN tags -> 'railway' IN ('rail', 'tram', 'light_rail', 'narrow_guage', 'monorail') THEN 'rail' ELSE 'minor_road' END) AS kind, (CASE WHEN tags -> 'highway' IN ('motorway_link', 'trunk_link', 'primary_link', 'secondary_link', 'tertiary_link') THEN 'yes' ELSE 'no' END) AS is_link, (CASE WHEN tags ? 'tunnel' AND tags -> 'tunnel' != 'no' THEN 'yes' ELSE 'no' END) AS is_tunnel, (CASE WHEN tags ? 'bridge' AND tags -> 'bridge' != 'no' THEN 'yes' ELSE 'no' END) AS is_bridge, wayzorder(tags) as z_order , tags -> 'name' as name, tags -> 'ref' as ref
    FROM planet
    WHERE tags -> 'highway' IN ('motorway', 'motorway_link') OR tags -> 'highway' IN ('trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link') OR tags -> 'highway' IN ('unclassified', 'residential', 'living_street', 'service', 'road') OR tags -> 'highway' IN ('footpath', 'track', 'footway', 'steps', 'pedestrian', 'path', 'cycleway') OR tags -> 'railway' IN ('rail', 'tram', 'light_rail', 'narrow_guage', 'monorail')
    ORDER BY ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(the_geom), 3857), 4326));
CREATE INDEX highroad_z15plus_new_the_geom_webmercator_gist ON highroad_z15plus_new USING gist(the_geom_webmercator);
CREATE UNIQUE INDEX ON highroad_z15plus_new (id);
ANALYZE highroad_z15plus_new;

ALTER INDEX highroad_z15plus_the_geom_webmercator_gist
  RENAME TO highroad_z15plus_old_the_geom_webmercator_gist;
ALTER INDEX highroad_z15plus_id_idx
  RENAME TO highroad_z15plus_old_id_idx;

BEGIN;
ALTER MATERIALIZED VIEW highroad_z15plus
  RENAME TO highroad_z15plus_old;
ALTER MATERIALIZED VIEW highroad_z15plus_new
  RENAME TO highroad_z15plus;
COMMIT;

ALTER INDEX highroad_z15plus_new_the_geom_webmercator_gist
  RENAME TO highroad_z15plus_the_geom_webmercator_gist;
ALTER INDEX highroad_z15plus_new_id_idx
  RENAME TO highroad_z15plus_id_idx;

-- highroad_z14
CREATE MATERIALIZED VIEW highroad_z14_new AS
  SELECT id, generalize(the_geom_webmercator, 14) AS the_geom_webmercator, highway, railway, (CASE WHEN highway IN ('motorway', 'motorway_link') THEN 'highway' WHEN highway IN ('trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link') THEN 'major_road' WHEN highway IN ('unclassified', 'residential', 'living_street', 'road') THEN 'minor_road' WHEN railway IN ('rail') THEN 'rail' ELSE 'unknown' END) AS kind, is_link, is_tunnel, is_bridge, z_order, name, ref
    FROM highroad_z15plus
    WHERE highway in ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link', 'unclassified', 'residential', 'living_street', 'road') OR railway = 'rail'
    ORDER BY ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(the_geom_webmercator), 3857), 4326));
CREATE INDEX highroad_z14_new_the_geom_webmercator_gist ON highroad_z14_new USING gist(the_geom_webmercator);
CREATE UNIQUE INDEX ON highroad_z14_new (id);
ANALYZE highroad_z14_new;

ALTER INDEX highroad_z14_the_geom_webmercator_gist
  RENAME TO highroad_z14_old_the_geom_webmercator_gist;
ALTER INDEX highroad_z14_id_idx
  RENAME TO highroad_z14_old_id_idx;

BEGIN;
ALTER MATERIALIZED VIEW highroad_z14
  RENAME TO highroad_z14_old;
ALTER MATERIALIZED VIEW highroad_z14_new
  RENAME TO highroad_z14;
COMMIT;

ALTER INDEX highroad_z14_new_the_geom_webmercator_gist
  RENAME TO highroad_z14_the_geom_webmercator_gist;
ALTER INDEX highroad_z14_new_id_idx
  RENAME TO highroad_z14_id_idx;

-- highroad_z13
CREATE MATERIALIZED VIEW highroad_z13_new AS
  SELECT id, generalize(the_geom_webmercator, 13) AS the_geom_webmercator, highway, railway, (CASE WHEN highway IN ('motorway', 'motorway_link') THEN 'highway' WHEN highway IN ('trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link') THEN 'major_road' ELSE 'minor_road' END) AS kind, is_link, is_tunnel, is_bridge, z_order, name, ref
    FROM highroad_z14
    WHERE highway in ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'unclassified', 'residential', 'living_street', 'road') OR railway = 'rail'
    ORDER BY ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(the_geom_webmercator), 3857), 4326));
CREATE INDEX highroad_z13_new_the_geom_webmercator_gist ON highroad_z13_new USING gist(the_geom_webmercator);
CREATE UNIQUE INDEX ON highroad_z13_new (id);
ANALYZE highroad_z13_new;

ALTER INDEX highroad_z13_the_geom_webmercator_gist
  RENAME TO highroad_z13_old_the_geom_webmercator_gist;
ALTER INDEX highroad_z13_id_idx
  RENAME TO highroad_z13_old_id_idx;

BEGIN;
ALTER MATERIALIZED VIEW highroad_z13
  RENAME TO highroad_z13_old;
ALTER MATERIALIZED VIEW highroad_z13_new
  RENAME TO highroad_z13;
COMMIT;

ALTER INDEX highroad_z13_new_the_geom_webmercator_gist
  RENAME TO highroad_z13_the_geom_webmercator_gist;
ALTER INDEX highroad_z13_new_id_idx
  RENAME TO highroad_z13_id_idx;

-- highroad_z12
CREATE MATERIALIZED VIEW highroad_z12_new AS
  SELECT id, generalize(the_geom_webmercator, 12) AS the_geom_webmercator, highway, railway, (CASE WHEN highway IN ('motorway') THEN 'highway' WHEN highway IN ('trunk', 'primary', 'secondary') THEN 'major_road' ELSE 'minor_road' END) AS kind, 'no'::text AS is_link, is_tunnel, is_bridge, z_order, name, ref
    FROM highroad_z13
    WHERE highway in ('motorway', 'trunk', 'primary', 'secondary', 'tertiary', 'unclassified', 'residential', 'living_street', 'road')
    ORDER BY ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(the_geom_webmercator), 3857), 4326));
CREATE INDEX highroad_z12_new_the_geom_webmercator_gist ON highroad_z12_new USING gist(the_geom_webmercator);
CREATE UNIQUE INDEX ON highroad_z12_new (id);
ANALYZE highroad_z12_new;

ALTER INDEX highroad_z12_the_geom_webmercator_gist
  RENAME TO highroad_z12_old_the_geom_webmercator_gist;
ALTER INDEX highroad_z12_id_idx
  RENAME TO highroad_z12_old_id_idx;

BEGIN;
ALTER MATERIALIZED VIEW highroad_z12
  RENAME TO highroad_z12_old;
ALTER MATERIALIZED VIEW highroad_z12_new
  RENAME TO highroad_z12;
COMMIT;

ALTER INDEX highroad_z12_new_the_geom_webmercator_gist
  RENAME TO highroad_z12_the_geom_webmercator_gist;
ALTER INDEX highroad_z12_new_id_idx
  RENAME TO highroad_z12_id_idx;

-- highroad_z11
CREATE MATERIALIZED VIEW highroad_z11_new AS
  SELECT id, generalize(the_geom_webmercator, 11) AS the_geom_webmercator, highway, railway, (CASE WHEN highway IN ('motorway') THEN 'highway' WHEN highway IN ('trunk', 'primary') THEN 'major_road' ELSE 'minor_road' END) AS kind, 'no'::text AS is_link, is_tunnel, is_bridge, z_order, name, ref
    FROM highroad_z12
    WHERE highway in ('motorway', 'trunk', 'primary', 'secondary', 'tertiary')
    ORDER BY ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(the_geom_webmercator), 3857), 4326));
CREATE INDEX highroad_z11_new_the_geom_webmercator_gist ON highroad_z11_new USING gist(the_geom_webmercator);
CREATE UNIQUE INDEX ON highroad_z11_new (id);
ANALYZE highroad_z11_new;

ALTER INDEX highroad_z11_the_geom_webmercator_gist
  RENAME TO highroad_z11_old_the_geom_webmercator_gist;
ALTER INDEX highroad_z11_id_idx
  RENAME TO highroad_z11_old_id_idx;

BEGIN;
ALTER MATERIALIZED VIEW highroad_z11
  RENAME TO highroad_z11_old;
ALTER MATERIALIZED VIEW highroad_z11_new
  RENAME TO highroad_z11;
COMMIT;

ALTER INDEX highroad_z11_new_the_geom_webmercator_gist
  RENAME TO highroad_z11_the_geom_webmercator_gist;
ALTER INDEX highroad_z11_new_id_idx
  RENAME TO highroad_z11_id_idx;

-- highroad_z10
CREATE MATERIALIZED VIEW highroad_z10_new AS
  SELECT id, generalize(the_geom_webmercator, 10) AS the_geom_webmercator, highway, railway, (CASE WHEN highway IN ('motorway') THEN 'highway' WHEN highway IN ('trunk', 'primary') THEN 'major_road' ELSE 'minor_road' END) AS kind, 'no'::text AS is_link, is_tunnel, is_bridge, z_order, name, ref
    FROM highroad_z11
    WHERE highway in ('motorway', 'trunk', 'primary', 'secondary')
    ORDER BY ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(the_geom_webmercator), 3857), 4326));
CREATE INDEX highroad_z10_new_the_geom_webmercator_gist ON highroad_z10_new USING gist(the_geom_webmercator);
CREATE UNIQUE INDEX ON highroad_z10_new (id);
ANALYZE highroad_z10_new;

ALTER INDEX highroad_z10_the_geom_webmercator_gist
  RENAME TO highroad_z10_old_the_geom_webmercator_gist;
ALTER INDEX highroad_z10_id_idx
  RENAME TO highroad_z10_old_id_idx;

BEGIN;
ALTER MATERIALIZED VIEW highroad_z10
  RENAME TO highroad_z10_old;
ALTER MATERIALIZED VIEW highroad_z10_new
  RENAME TO highroad_z10;
COMMIT;

ALTER INDEX highroad_z10_new_the_geom_webmercator_gist
  RENAME TO highroad_z10_the_geom_webmercator_gist;
ALTER INDEX highroad_z10_new_id_idx
  RENAME TO highroad_z10_id_idx;

\i ../data/global_functions.sql

DROP MATERIALIZED VIEW IF EXISTS highroad_z10_old;
DROP MATERIALIZED VIEW IF EXISTS highroad_z11_old;
DROP MATERIALIZED VIEW IF EXISTS highroad_z12_old;
DROP MATERIALIZED VIEW IF EXISTS highroad_z13_old;
DROP MATERIALIZED VIEW IF EXISTS highroad_z14_old;
DROP MATERIALIZED VIEW IF EXISTS highroad_z15plus_old;
