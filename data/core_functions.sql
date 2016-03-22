-- These functions are basic ones which do not depend on OSM data or any mat views,
-- but other functions or views may depend on them.

SET client_min_messages TO WARNING;

BEGIN;

CREATE OR REPLACE FUNCTION generalize(geom geometry, zoom int) RETURNS geometry
AS $$
  -- generalize to 1/4 pixel (assuming 256x256 tiles)
  SELECT ST_Simplify(geom, 20037508.34 * 2 / 2^(9 + zoom));
$$ LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION numeric_or_zero(s text) RETURNS numeric
AS
$$
SELECT CASE WHEN s ~ '^[0-9]+$' THEN s::numeric ELSE 0 END;
$$
LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION numeric_or_zero(s numeric) RETURNS numeric
AS
$$
SELECT s::numeric;
$$
LANGUAGE SQL IMMUTABLE;

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

COMMIT;
-- Not needed unless another file is being used in the same session
RESET client_min_messages;
