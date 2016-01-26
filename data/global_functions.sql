-- The functions used to take a schema name, but no longer do. This is
-- why many drop two functions
SET client_min_messages TO WARNING;

CREATE OR REPLACE FUNCTION generalize(geom geometry, zoom int) RETURNS geometry
AS $$
BEGIN
  -- generalize to 1/4 pixel (assuming 256x256 tiles)
  RETURN ST_Simplify(geom, 20037508.34 * 2 / 2^(9 + zoom));
END
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION numeric_or_zero(s text) RETURNS numeric
AS $$
BEGIN
  IF s ~ '^[0-9]+$' THEN
    RETURN s::numeric;
  ELSE
    RETURN 0;
  END IF;
END
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION numeric_or_zero(s numeric) RETURNS numeric
AS $$
BEGIN
  RETURN s::numeric;
END
$$ LANGUAGE plpgsql IMMUTABLE;

-- see https://github.com/omniscale/imposm3/blob/master/mapping/fields.go#L199
CREATE OR REPLACE FUNCTION wayzorder(tags hstore) RETURNS integer
AS $$
DECLARE
  z INTEGER;
BEGIN
  z = 0;
  IF tags ? 'layer' THEN
    z = z + numeric_or_zero(tags -> 'layer') * 10;
  END IF;

  CASE
    WHEN tags -> 'highway' IN ('minor','road','unclassified','residential','tertiary_link',
     'secondary_link','primary_link','trunk_link','motorway_link') THEN
      z = z + 3;
    WHEN tags -> 'highway' = 'tertiary' THEN
      z = z + 4;
    WHEN tags -> 'highway' = 'secondary' THEN
      z = z + 5;
    WHEN tags -> 'highway' = 'primary' THEN
      z = z + 6;
    WHEN tags -> 'highway' = 'trunk' THEN
      z = z + 8;
    WHEN tags -> 'highway' = 'motorway' THEN
      z = z + 9;
    ELSE
      IF tags ? 'railway' AND tags -> 'railway' != 'no' THEN
        z = z + 7;
      END IF;
  END CASE;

  IF tags -> 'tunnel' IN ('true','yes','1') THEN
    z = z - 10;
  END IF;

  IF tags -> 'bridge' IN ('true','yes','1') THEN
    z = z + 10;
  END IF;

  RETURN z;
END
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zoom(scaleDenominator numeric) RETURNS int AS $$
BEGIN
  CASE
    WHEN scaleDenominator > 1000000000 THEN RETURN 0;
    WHEN scaleDenominator <= 1000000000 AND scaleDenominator > 500000000 THEN RETURN 1;
    WHEN scaleDenominator <= 500000000 AND scaleDenominator > 200000000 THEN RETURN 2;
    WHEN scaleDenominator <= 200000000 AND scaleDenominator > 100000000 THEN RETURN 3;
    WHEN scaleDenominator <= 100000000 AND scaleDenominator > 50000000 THEN RETURN 3;
    WHEN scaleDenominator <= 50000000 AND scaleDenominator > 25000000 THEN RETURN 4;
    WHEN scaleDenominator <= 25000000 AND scaleDenominator > 12500000 THEN RETURN 5;
    WHEN scaleDenominator <= 12500000 AND scaleDenominator > 6500000 THEN RETURN 6;
    WHEN scaleDenominator <= 6500000 AND scaleDenominator > 3000000 THEN RETURN 7;
    WHEN scaleDenominator <= 3000000 AND scaleDenominator > 1500000 THEN RETURN 8;
    WHEN scaleDenominator <= 1500000 AND scaleDenominator > 750000 THEN RETURN 9;
    WHEN scaleDenominator <= 750000 AND scaleDenominator > 400000 THEN RETURN 10;
    WHEN scaleDenominator <= 400000 AND scaleDenominator > 200000 THEN RETURN 11;
    WHEN scaleDenominator <= 200000 AND scaleDenominator > 100000 THEN RETURN 12;
    WHEN scaleDenominator <= 100000 AND scaleDenominator > 50000 THEN RETURN 13;
    WHEN scaleDenominator <= 50000 AND scaleDenominator > 25000 THEN RETURN 14;
    WHEN scaleDenominator <= 25000 AND scaleDenominator > 12500 THEN RETURN 15;
    WHEN scaleDenominator <= 12500 AND scaleDenominator > 5000 THEN RETURN 16;
    WHEN scaleDenominator <= 5000 AND scaleDenominator > 2500 THEN RETURN 17;
    WHEN scaleDenominator <= 2500 AND scaleDenominator > 1500 THEN RETURN 18;
    WHEN scaleDenominator <= 1500 AND scaleDenominator > 750 THEN RETURN 19;
    WHEN scaleDenominator <= 750 AND scaleDenominator > 500 THEN RETURN 20;
    WHEN scaleDenominator <= 500 AND scaleDenominator > 250 THEN RETURN 21;
    WHEN scaleDenominator <= 250 AND scaleDenominator > 100 THEN RETURN 22;
    WHEN scaleDenominator <= 100 THEN RETURN 23;
  END CASE;
END
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS false_background_zoomed(text,box3d);
CREATE OR REPLACE FUNCTION false_background_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(the_geom_webmercator geometry) AS
$$
DECLARE
  zoom NUMERIC;
BEGIN
  zoom := zoom(scaleDenominator::numeric);
  IF zoom >= 9 THEN
    RETURN QUERY EXECUTE format(
      'SELECT ($1)::geometry'
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS continents_zoomed(text,box3d);
CREATE OR REPLACE FUNCTION continents_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(cartodb_id integer, name text, the_geom_webmercator geometry) AS
$$
DECLARE
  zoom NUMERIC;
BEGIN
  -- hack hack. scaledenominators seem to be inaccurate at zooms 0-2
  IF scaleDenominator::numeric > 139000000 THEN
    RETURN QUERY EXECUTE format(
      'SELECT cartodb_id, name::text, the_geom_webmercator
       FROM continents_900913
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS land_positive_zoomed(text,box3d);
CREATE OR REPLACE FUNCTION land_positive_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(cartodb_id integer, the_geom_webmercator geometry) AS
$$
DECLARE
  zoom NUMERIC;
BEGIN
  zoom := zoom(scaleDenominator::numeric);
  IF zoom <= 1 THEN
    RETURN QUERY EXECUTE format(
      'SELECT cartodb_id, the_geom_webmercator
       FROM ne_50m_land
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSIF zoom <= 3 THEN
    RETURN QUERY EXECUTE format(
      'SELECT cartodb_id, the_geom_webmercator
       FROM ne_50m_admin_0_countries_lakes
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSIF zoom <= 7 THEN
    RETURN QUERY EXECUTE format(
      'SELECT cartodb_id, the_geom_webmercator
       FROM ne_10m_admin_0_countries_lakes
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSIF zoom <= 8 THEN
    RETURN QUERY EXECUTE format(
      'SELECT cartodb_id, the_geom_webmercator
       FROM simplified_land_polygons
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS land_negative_zoomed(text,box3d);
CREATE OR REPLACE FUNCTION land_negative_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(cartodb_id bigint, the_geom_webmercator geometry) AS
$$
DECLARE
  zoom NUMERIC;
BEGIN
  zoom := zoom(scaleDenominator::numeric);
  IF zoom >= 9 THEN
    RETURN QUERY EXECUTE format(
      'SELECT cartodb_id, the_geom_webmercator
       FROM water_polygons
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS ne_marine_zoomed(text,box3d);
CREATE OR REPLACE FUNCTION ne_marine_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(cartodb_id bigint, the_geom_webmercator geometry, name text, namealt text, featurecla text, scalerank integer) AS
/* Some tables have cartodb_id bigint, some integer, so cast them all to bigint */
$$
BEGIN
  IF zoom(scaleDenominator::numeric) <= 3 AND zoom(scaleDenominator::numeric) >= 2 THEN
    RETURN QUERY EXECUTE format(
      'SELECT cartodb_id::bigint, the_geom_webmercator, name::text, namealt::text, featurecla::text, scalerank::integer
       FROM ne_110m_geography_marine_polys
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 4 AND zoom(scaleDenominator::numeric) <= 5 THEN
    RETURN QUERY EXECUTE format(
      'SELECT cartodb_id::bigint, the_geom_webmercator, name::text, namealt::text, featurecla::text, scalerank::integer
       FROM ne_50m_geography_marine_polys
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 6 AND zoom(scaleDenominator::numeric) <= 8 THEN
    RETURN QUERY EXECUTE format(
      'SELECT cartodb_id::bigint, the_geom_webmercator, name::text, namealt::text, featurecla::text, scalerank::integer
       FROM ne_10m_geography_marine_polys
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';

-- Rivers go below lakes, so rivers are drawn first (river = 0)
DROP FUNCTION IF EXISTS water_zoomed(text,text,box3d);
CREATE OR REPLACE FUNCTION water_zoomed(schema text, scaleDenominator text, bbox box3d)
  RETURNS TABLE(id bigint, the_geom_webmercator geometry, name text, type text, is_lake integer, ne_scalerank integer, area bigint) AS
$$
BEGIN
  IF zoom(scaleDenominator::numeric) >= 3 AND zoom(scaleDenominator::numeric) <= 4 THEN
    RETURN QUERY EXECUTE format(
       '(select cartodb_id::bigint AS id, the_geom_webmercator, name::text, ''river'' AS type, 0 AS is_lake, scalerank::integer, ST_Area(the_geom_webmercator)::bigint
       from ne_50m_rivers_lake_centerlines
       where the_geom_webmercator && $1)
       UNION 
       (SELECT cartodb_id::bigint AS id, the_geom_webmercator, name::text, ''lake'' AS type, 1 AS is_lake, scalerank::integer, ST_Area(the_geom_webmercator)::bigint
       FROM ne_50m_lakes
       WHERE the_geom_webmercator && $1)
       ORDER BY is_lake ASC'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 5 AND zoom(scaleDenominator::numeric) <= 7 THEN
    RETURN QUERY EXECUTE format(
       '(SELECT cartodb_id::bigint AS id, the_geom_webmercator, name::text, ''river'' AS type, 0 AS is_lake, scalerank::integer, ST_Area(the_geom_webmercator)::bigint
       FROM ne_10m_rivers_lake_centerlines
       WHERE the_geom_webmercator && $1)
       UNION 
       (SELECT cartodb_id::bigint AS id, the_geom_webmercator, name, ''lake'' AS type, 1 AS is_lake, scalerank::integer, ST_Area(the_geom_webmercator)::bigint
       FROM ne_10m_lakes
       WHERE the_geom_webmercator && $1)
       ORDER BY is_lake ASC'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 8 AND zoom(scaleDenominator::numeric) <= 10 THEN
    RETURN QUERY EXECUTE format(
      'SELECT osm_id::bigint AS id, the_geom_webmercator, name::text, type::text,
       (CASE WHEN type IN (''water'',''bay'',''riverbank'',''reservoir'') 
             AND ST_GeometryType(the_geom_webmercator) IN (''ST_Polygon'',''ST_MultiPolygon'') THEN 1 ELSE 0 END) as is_lake,
       0 as ne_scalerank, area::bigint
       FROM %s.water_areas_z10
       WHERE the_geom_webmercator && $1
       ORDER BY is_lake ASC', schema
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 11 AND zoom(scaleDenominator::numeric) <= 13 THEN
    RETURN QUERY EXECUTE format(
      'SELECT osm_id::bigint AS id, the_geom_webmercator, name::text, type::text,
       (CASE WHEN type IN (''water'',''bay'',''riverbank'',''reservoir'') 
             AND ST_GeometryType(the_geom_webmercator) IN (''ST_Polygon'',''ST_MultiPolygon'') THEN 1 ELSE 0 END) as is_lake,
       0 AS ne_scalerank, area::bigint
       FROM %s.water_areas_z13
       WHERE the_geom_webmercator && $1
       ORDER BY is_lake ASC', schema
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 14 THEN
    RETURN QUERY EXECUTE format(
      'SELECT osm_id::bigint AS id, the_geom_webmercator, name::text, type::text,
       (CASE WHEN type IN (''water'',''bay'',''riverbank'',''reservoir'') 
             AND ST_GeometryType(the_geom_webmercator) IN (''ST_Polygon'',''ST_MultiPolygon'') THEN 1 ELSE 0 END) as is_lake,
       0 as ne_scalerank, area::bigint
       FROM %s.water_areas_z14plus
       WHERE the_geom_webmercator && $1
       ORDER BY is_lake ASC', schema
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';


DROP FUNCTION IF EXISTS urban_areas_zoomed(text,box3d);
CREATE OR REPLACE FUNCTION urban_areas_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(cartodb_id bigint, scalerank integer, the_geom_webmercator geometry) AS
$$
BEGIN
  IF zoom(scaleDenominator::numeric) <= 4 THEN
    RETURN QUERY EXECUTE format(
      'SELECT cartodb_id::bigint, scalerank::integer, the_geom_webmercator
       FROM ne_50m_urban_areas
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 5 AND zoom(scaleDenominator::numeric) <= 9 THEN
    RETURN QUERY EXECUTE format(
      'SELECT cartodb_id::bigint, scalerank::integer, the_geom_webmercator
       FROM ne_10m_urban_areas
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS country_city_labels_zoomed(text,box3d);
DROP FUNCTION IF EXISTS country_city_labels_zoomed(text,text,box3d);
CREATE OR REPLACE FUNCTION country_city_labels_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(cartodb_id bigint, name text, country_city text, the_geom_webmercator geometry, scalerank integer, place text, pop_est numeric, is_capital bool) AS
$$
BEGIN
  IF zoom(scaleDenominator::numeric) <= 3 AND zoom(scaleDenominator::numeric) >= 1 THEN
    RETURN QUERY EXECUTE format(
      'SELECT cartodb_id::bigint, admin::text AS name, ''country''::text, the_geom_webmercator, scalerank::integer, ''''::text, pop_est::numeric, false
       FROM ne_50m_admin_0_countries_lakes
       WHERE the_geom_webmercator && $1
       ORDER BY pop_est DESC'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) <= 5 AND zoom(scaleDenominator::numeric) >= 4 THEN
    RETURN QUERY EXECUTE format(
      '(SELECT cartodb_id::bigint, admin::text AS name, ''country''::text as country_city, the_geom_webmercator, scalerank::integer, ''''::text, pop_est::numeric, false as is_capital
       FROM ne_50m_admin_0_countries_lakes
       WHERE the_geom_webmercator && $1)
       UNION
       (select cartodb_id::bigint, name::text, ''city''::text as country_city, the_geom_webmercator, zoom::integer as scalerank, ''''::text, population::numeric as pop_est, capital = ''yes'' as is_capital
       from z4to10
       where the_geom_webmercator && $1 and zoom <= 5
       order by scalerank asc, population desc nulls last)'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 6 AND zoom(scaleDenominator::numeric) <= 7 THEN
    RETURN QUERY EXECUTE format(
       'select cartodb_id::bigint, name::text, ''city''::text, the_geom_webmercator, zoom::integer as scalerank, ''''::text, population::numeric as pop_est, capital = ''yes'' as is_capital
        from z4to10
        where the_geom_webmercator && $1 and zoom <= 7
        order by scalerank asc, population desc nulls last'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 8 AND zoom(scaleDenominator::numeric) <= 12 THEN
    RETURN QUERY EXECUTE format(
       'SELECT cartodb_id::bigint, name::text, ''city''::text, the_geom_webmercator, zoom::integer as scalerank, ''''::text, population::numeric as pop_est, capital = ''yes'' as is_capital
        FROM z4to10
        WHERE the_geom_webmercator && $1
        ORDER BY scalerank ASC, population DESC NULLS LAST'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 13 THEN
    RETURN QUERY EXECUTE format(
       'SELECT osm_id, name::text, ''city''::text, the_geom_webmercator, 99 as scalerank, place::text, numeric_or_zero(population) as pop_est, false as is_capital
        FROM places
        WHERE the_geom_webmercator && $1
        ORDER BY population DESC NULLS LAST'
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS ne_10m_roads_zoomed(text,box3d);
CREATE OR REPLACE FUNCTION ne_10m_roads_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(cartodb_id integer, the_geom_webmercator geometry, type text, scalerank numeric) AS
$$
BEGIN
  IF zoom(scaleDenominator::numeric) <= 8 AND zoom(scaleDenominator::numeric) >= 6 THEN
    RETURN QUERY EXECUTE format(
      'SELECT cartodb_id, the_geom_webmercator, type::text, scalerank::numeric
       FROM ne_10m_roads
       WHERE type NOT IN (''Ferry, seasonal'', ''Ferry Route'')
       AND the_geom_webmercator && $1
       ORDER BY scalerank DESC') USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';

-- Below this, depends on a schema.

DROP FUNCTION IF EXISTS admin0boundaries_zoomed(text,box3d);
DROP FUNCTION IF EXISTS admin0boundaries_zoomed(text,text,box3d);
CREATE OR REPLACE FUNCTION admin0boundaries_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(cartodb_id bigint, the_geom_webmercator geometry, unit boolean) AS
$$
BEGIN
  IF zoom(scaleDenominator::numeric) <= 9 AND zoom(scaleDenominator::numeric) >= 3 THEN
    RETURN QUERY EXECUTE format(
      '(SELECT cartodb_id::bigint, the_geom_webmercator, false
       FROM ne_10m_admin_0_boundary_lines_land
       WHERE fid_ne_10m NOT IN (372,374)
       AND the_geom_webmercator && $1)
       union
       (SELECT cartodb_id::bigint, the_geom_webmercator, true
       FROM ne_10m_admin_0_boundary_lines_map_units
       WHERE the_geom_webmercator && $1)'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 10 THEN
    RETURN QUERY EXECUTE format(
      'SELECT osm_id::bigint, the_geom_webmercator, false
       FROM administrative
       WHERE admin_level = ''2''
       AND the_geom_webmercator && $1'
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS admin1boundaries_zoomed(text, box3d);
DROP FUNCTION IF EXISTS admin1boundaries_zoomed(text, text, box3d);
CREATE OR REPLACE FUNCTION admin1boundaries_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(cartodb_id bigint, name text, scalerank integer, the_geom_webmercator geometry, geomtype text) AS
$$
BEGIN
  IF scaleDenominator::numeric > 139000000 THEN
    RETURN QUERY EXECUTE format(
      'select cartodb_id::bigint, ''''::text as name, scalerank::integer, the_geom_webmercator, ST_GeometryType(the_geom_webmercator) AS geomtype
       from ne_50m_admin_1_states_provinces_lines_shp
       where the_geom_webmercator && $1'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 3 AND zoom(scaleDenominator::numeric) <= 9 THEN
    RETURN QUERY EXECUTE format(
      'select cartodb_id::bigint, ''''::text as name, scalerank::integer, the_geom_webmercator, ST_GeometryType(the_geom_webmercator) AS geomtype
       from ne_10m_admin_1_states_provinces_lines_shp
       where the_geom_webmercator && $1'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 10 THEN
    RETURN QUERY EXECUTE format(
      'SELECT osm_id::bigint, tags::hstore -> ''name'' as name, 0, the_geom_webmercator, ST_GeometryType(the_geom_webmercator) AS geomtype
       FROM administrative
       WHERE admin_level = ''4''
       AND the_geom_webmercator && $1'
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS admin1_polygons_zoomed(text,box3d);
CREATE OR REPLACE FUNCTION admin1_polygons_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(cartodb_id integer, name text, scalerank integer, the_geom_webmercator geometry) AS
$$
BEGIN
  IF zoom(scaleDenominator::numeric) <= 7 AND zoom(scaleDenominator::numeric) >= 3 THEN
    RETURN QUERY EXECUTE format(
      'SELECT cartodb_id, name::text, scalerank::integer, the_geom_webmercator
       FROM ne_10m_admin_1_states_provinces
       WHERE adm0_a3 IN (''USA'',''CAN'',''AUS'')
       AND the_geom_webmercator && $1'
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';


DROP FUNCTION IF EXISTS high_road(scaleDenominator text, bbox box3d);
DROP FUNCTION IF EXISTS high_road(schema text, scaleDenominator text, bbox box3d);
CREATE OR REPLACE FUNCTION high_road(scaleDenominator text, bbox box3d)
  RETURNS TABLE(name text, ref text, the_geom_webmercator geometry, highway text, railway text, kind text, is_link text, is_tunnel text, is_bridge text, z_order integer) AS
$$
DECLARE
  conditions TEXT;
BEGIN
  -- TODO use zoom()
  CASE
    WHEN zoom(scaleDenominator::numeric) = 13 THEN
      conditions := 'is_bridge=''no''';

    WHEN zoom(scaleDenominator::numeric) >= 14 THEN
      conditions := 'is_bridge=''no'' AND is_tunnel=''no''';

    ELSE
      conditions := 'true';
  END CASE;

  RETURN QUERY SELECT * FROM high_road(scaleDenominator, bbox, conditions);
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS high_road(scaleDenominator text, bbox box3d, conditions text);
DROP FUNCTION IF EXISTS high_road(schema text, scaleDenominator text, bbox box3d, conditions text);
CREATE OR REPLACE FUNCTION high_road(scaleDenominator text, bbox box3d, conditions text)
  RETURNS TABLE(name text, ref text, the_geom_webmercator geometry, highway text, railway text, kind text, is_link text, is_tunnel text, is_bridge text, z_order integer) AS
$$
DECLARE
  tablename TEXT;
BEGIN
  CASE
    WHEN zoom(scaleDenominator::numeric) >= 9 AND zoom(scaleDenominator::numeric) <= 10 THEN
      tablename := 'highroad_z10';
    WHEN zoom(scaleDenominator::numeric) = 11 THEN
      tablename := 'highroad_z11';
    WHEN zoom(scaleDenominator::numeric) = 12 THEN
      tablename := 'highroad_z12';
    WHEN zoom(scaleDenominator::numeric) = 13 THEN
      tablename := 'highroad_z13';
    WHEN zoom(scaleDenominator::numeric) = 14 THEN
      tablename := 'highroad_z14';
    WHEN zoom(scaleDenominator::numeric) >= 15 THEN
      tablename := 'highroad_z15plus';
    ELSE
      RETURN;
  END CASE;

  RETURN QUERY EXECUTE format(
    'SELECT name, ref, the_geom_webmercator, highway::text, railway::text, kind::text, is_link::text, is_tunnel::text, is_bridge::text, z_order 
     FROM %I
     WHERE the_geom_webmercator && $1
     AND %s ORDER BY z_order ASC', tablename, conditions
  ) USING bbox;
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS high_road_labels(scaleDenominator text, bbox box3d);
DROP FUNCTION IF EXISTS high_road_labels(schema text, scaleDenominator text, bbox box3d);
CREATE OR REPLACE FUNCTION high_road_labels(scaleDenominator text, bbox box3d)
  RETURNS TABLE(name text, ref text, the_geom_webmercator geometry, highway text, railway text, kind text, is_link text, is_tunnel text, is_bridge text, z_order integer) AS
$$
DECLARE
  tablename TEXT;
BEGIN
  CASE
    WHEN zoom(scaleDenominator::numeric) = 12 THEN
      tablename := 'highroad_z12';
    WHEN zoom(scaleDenominator::numeric) = 13 THEN
      tablename := 'highroad_z13';
    WHEN zoom(scaleDenominator::numeric) = 14 THEN
      tablename := 'highroad_z14';
    WHEN zoom(scaleDenominator::numeric) >= 15 THEN
      tablename := 'highroad_z15plus';
    ELSE
      RETURN;
  END CASE;

  RETURN QUERY EXECUTE format(
    'SELECT name, ref, the_geom_webmercator, highway::text, railway::text, kind::text, is_link::text, is_tunnel::text, is_bridge::text, z_order 
     FROM %I
     WHERE the_geom_webmercator && $1
     ORDER BY z_order ASC', tablename
  ) USING bbox;
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS tunnels(scaleDenominator text, bbox box3d);
DROP FUNCTION IF EXISTS tunnels(schema text, scaleDenominator text, bbox box3d);
CREATE OR REPLACE FUNCTION tunnels(scaleDenominator text, bbox box3d)
  RETURNS TABLE(the_geom_webmercator geometry, highway text, railway text, kind text, is_link text, is_tunnel text, is_bridge text) AS
$$
DECLARE
  tablename TEXT;
BEGIN
  CASE
    WHEN zoom(scaleDenominator::numeric) = 13 THEN
      tablename := 'highroad_z13';
    WHEN zoom(scaleDenominator::numeric) = 14 THEN
      tablename := 'highroad_z14';
    WHEN zoom(scaleDenominator::numeric) >= 15 THEN
      tablename := 'highroad_z15plus';
    ELSE
      RETURN;
  END CASE;

  RETURN QUERY EXECUTE format(
    'SELECT the_geom_webmercator, highway::text, railway::text, kind::text, is_link::text, is_tunnel::text, is_bridge::text
     FROM %I
     WHERE the_geom_webmercator && $1
      AND is_tunnel = ''yes'' ORDER BY z_order ASC', tablename
  ) USING bbox;
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS bridges(scaleDenominator text, bbox box3d);
DROP FUNCTION IF EXISTS bridges(schema text, scaleDenominator text, bbox box3d);
CREATE OR REPLACE FUNCTION bridges(scaleDenominator text, bbox box3d)
  RETURNS TABLE(the_geom_webmercator geometry, highway text, railway text, kind text, is_link text, is_tunnel text, is_bridge text) AS
$$
DECLARE
  tablename TEXT;
BEGIN
  CASE
    WHEN zoom(scaleDenominator::numeric) = 13 THEN
      tablename := 'highroad_z13';
    WHEN zoom(scaleDenominator::numeric) = 14 THEN
      tablename := 'highroad_z14';
    WHEN zoom(scaleDenominator::numeric) >= 15 THEN
      tablename := 'highroad_z15plus';
    ELSE
      RETURN;
  END CASE;

  RETURN QUERY EXECUTE format(
    'SELECT the_geom_webmercator, highway::text, railway::text, kind::text, is_link::text, is_tunnel::text, is_bridge::text
     FROM %I
     WHERE the_geom_webmercator && $1
      AND is_bridge = ''yes'' ORDER BY z_order ASC', tablename
  ) USING bbox;
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS buildings_zoomed(text,box3d);
DROP FUNCTION IF EXISTS buildings_zoomed(text,text,box3d);
CREATE OR REPLACE FUNCTION buildings_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(osm_id bigint, area bigint, the_geom_webmercator geometry) AS
$$
BEGIN
  IF zoom(scaleDenominator::numeric) >= 12 AND zoom(scaleDenominator::numeric) <= 13 THEN
    RETURN QUERY EXECUTE format(
      'SELECT osm_id::bigint, area::bigint, the_geom_webmercator
       FROM buildings_z13
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 14 THEN
    RETURN QUERY EXECUTE format(
      'SELECT osm_id::bigint, area::bigint, the_geom_webmercator
       FROM buildings_z14plus
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS green_areas_zoomed(text,box3d);
DROP FUNCTION IF EXISTS green_areas_zoomed(text,text,box3d);
CREATE OR REPLACE FUNCTION green_areas_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(osm_id bigint, name text, area bigint, the_geom_webmercator geometry) AS
$$
BEGIN
  IF zoom(scaleDenominator::numeric) >= 9 AND zoom(scaleDenominator::numeric) <= 10 THEN
    RETURN QUERY EXECUTE format(
      'SELECT osm_id::bigint, name, area::bigint, the_geom_webmercator
       FROM green_areas_z10
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 11 AND zoom(scaleDenominator::numeric) <= 13 THEN
    RETURN QUERY EXECUTE format(
      'SELECT osm_id::bigint, name, area::bigint, the_geom_webmercator
       FROM green_areas_z13
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSIF zoom(scaleDenominator::numeric) >= 14 THEN
    RETURN QUERY EXECUTE format(
      'SELECT osm_id::bigint, name, area::bigint, the_geom_webmercator
       FROM green_areas_z14plus
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';


DROP FUNCTION IF EXISTS aeroways_zoomed(text,box3d);
DROP FUNCTION IF EXISTS aeroways_zoomed(text,text,box3d);
CREATE OR REPLACE FUNCTION aeroways_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(osm_id bigint, type text, the_geom_webmercator geometry) AS
$$
BEGIN
  IF zoom(scaleDenominator::numeric) >= 12 THEN
    RETURN QUERY EXECUTE format(
      'SELECT osm_id::bigint, type::text, the_geom_webmercator
       FROM aeroways
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS osm_admin_zoomed(text,box3d);
DROP FUNCTION IF EXISTS osm_admin_zoomed(text,text,box3d);
CREATE OR REPLACE FUNCTION osm_admin_zoomed(scaleDenominator text, bbox box3d)
  RETURNS TABLE(osm_id bigint, admin_level text, the_geom_webmercator geometry) AS
$$
BEGIN
  IF zoom(scaleDenominator::numeric) >= 9 THEN
    RETURN QUERY EXECUTE format(
      'SELECT osm_id::bigint, admin_level::text, the_geom_webmercator
       FROM %s.administrative
       WHERE the_geom_webmercator && $1'
    ) USING bbox;
  ELSE
    RETURN;
  END IF;
END
$$
LANGUAGE 'plpgsql';

-- Not needed unless another file is being used in the same session
RESET client_min_messages;
