set -e

# small continent file
ogr2ogr -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=the_geom_webmercator -lco FID=cartodb_id -overwrite -f "PostgreSQL" PG:"host=localhost dbname=cartodb_basemaps" small_shps/continents_900913.shp

# Cities list
ogr2ogr -lco GEOMETRY_NAME=the_geom -lco FID=cartodb_id -lco PRECISION=NO -overwrite -f "PostgreSQL" PG:"host=localhost dbname=cartodb_basemaps" z4to10.json -nln z4to10
psql cartodb_basemaps -c "ALTER TABLE z4to10 ADD COLUMN the_geom_webmercator geometry;"
psql cartodb_basemaps -c "UPDATE z4to10 SET the_geom_webmercator = ST_Transform(the_geom,900913);"
psql cartodb_basemaps -c "CREATE INDEX z4to10_tgw_gist ON z4to10 USING gist(the_geom_webmercator);"
psql cartodb_basemaps -c "CREATE INDEX z4to10_tgw_geohash ON z4to10 (ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(the_geom_webmercator), 3857), 4326)));"
psql cartodb_basemaps -c "CLUSTER z4to10_tgw_geohash ON z4to10;"

# Natural Earth
DIR=ne_temp/
for z in $DIR/*.shp; do 
  ogr2ogr -skipfailures -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=the_geom -lco FID=cartodb_id -lco PRECISION=NO -overwrite -f "PostgreSQL" PG:"host=localhost dbname=cartodb_basemaps" $z
done

for table in "ne_50m_land" "ne_10m_roads" "ne_50m_admin_0_countries_lakes" "ne_10m_admin_0_countries_lakes"\
 "ne_10m_admin_0_boundary_lines_land" "ne_10m_populated_places_simple" "ne_50m_populated_places_simple"\
 "ne_10m_lakes" "ne_50m_lakes" "ne_10m_rivers_lake_centerlines" "ne_50m_rivers_lake_centerlines" "ne_10m_urban_areas" "ne_50m_urban_areas"\
 "ne_10m_admin_1_states_provinces_lines_shp" "ne_50m_admin_1_states_provinces_lines_shp" "ne_10m_admin_0_boundary_lines_map_units"\
 "ne_10m_admin_1_states_provinces" "ne_50m_admin_1_states_provinces_shp" \
 "ne_110m_geography_marine_polys" "ne_50m_geography_marine_polys" "ne_10m_geography_marine_polys"; do
  psql cartodb_basemaps -c "ALTER TABLE $table ADD COLUMN the_geom_webmercator geometry;"
  psql cartodb_basemaps -c "UPDATE $table SET the_geom_webmercator = ST_Transform(ST_Intersection(the_geom,ST_SetSRID(Box2D(ST_GeomFromText('LINESTRING(-180 -85,180 85)'))::geometry,4326)),900913);"
  psql cartodb_basemaps -c "CREATE INDEX ${table}_tgw_gist ON $table USING gist(the_geom_webmercator);"
  psql cartodb_basemaps -c "CREATE INDEX ${table}_tgw_geohash ON $table (ST_GeoHash(ST_Transform(ST_SetSRID(Box2D(the_geom_webmercator), 3857), 4326)));"
  psql cartodb_basemaps -c "CLUSTER ${table}_tgw_geohash ON $table;"
done
