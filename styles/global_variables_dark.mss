// Default colors for the dark style ("dark matter")


// this should be incremented when the data (queries, functions, features) changes:
@cachebuster: #000096;

@polygoncolor: #ffd479;
@water: darken(#333336,0%);

Map {
  background-color: @water;
  buffer-size: 512;
}

@landmass_fill: #0e0e0e;
@landmass_line: #222;

@greenareas: darken(#222, 8%);
@greenareas_fill_low: @greenareas;
@greenareas_fill_medium: @greenareas;
@greenareas_fill_high: @greenareas;

@buildings: darken(@landmass_fill, 2%);
@buildings_outline_16: #141414;
@buildings_outline: #242424;

@aeroways: #111;

@ne10roads_line_color: rgba(0,0,0,0.8);
@ne10roads_line_outline: rgba(150,150,150,0.5);
@ne10roads_7_minor_color: #262626;

@ne_rivers_stroke: #1f1f1f;
@ne_rivers_casing: rgba(0,0,0,0.1);

@urbanareas: lighten(@landmass_fill,1%);
@urbanareas_highzoom: lighten(@landmass_fill,1%);

@admin0_4: #555;
@admin0_5: #444;
@admin0_6: #151515;
@admin0_7: #444;

@admin1_lowzoom: #333;
@admin1_highzoom: #444;

//osm roads
@rail_line: #2f2f2f;
@rail_dashline: #111;

@highwaycasing: rgba(70,70,70,0.9);
@highwaystroke: black;

@osm_roads_z9_highway_casing: rgba(50,50,50,0.8);
@osm_roads_z9_highway_stroke: @highwaystroke;
@osm_roads_z9_major_stroke: #2a2a2a;

@osm_roads_z10_highway_casing: rgba(60,60,60,0.8);
@osm_roads_z10_highway_stroke: @highwaystroke;
@osm_roads_z10_major_stroke: #2a2a2a;
@osm_roads_z10_minor_stroke: #252525;

@osm_roads_z11_highway_casing: @highwaycasing;
@osm_roads_z11_highway_stroke: @highwaystroke;
@osm_roads_z11_major_stroke: #333;
@osm_roads_z11_minor_stroke: #2a2a2a;

@osm_roads_z12_highway_casing: lighten(@highwaycasing,5%);
@osm_roads_z12_highway_stroke: @highwaystroke;
@osm_roads_z12_major_casing: darken(@highwaycasing,2%);
@osm_roads_z12_major_stroke: lighten(@highwaystroke,2%);
@osm_roads_z12_minor_stroke: #2a2a2a;

@osm_roads_z13_highway_casing: lighten(@highwaycasing,5%);
@osm_roads_z13_highway_stroke: @highwaystroke;
@osm_roads_z13_major_casing: darken(@highwaycasing,7%);
@osm_roads_z13_major_stroke: lighten(@highwaystroke,2%);
@osm_roads_z13_minor_stroke: #2a2a2a;

@osm_roads_z14plus_highway_casing: lighten(@highwaycasing,2%);
@osm_roads_z14plus_highway_stroke: lighten(@highwaystroke,5%);
@osm_roads_z14plus_major_casing: darken(@highwaycasing,2%);
@osm_roads_z14plus_major_stroke: lighten(@highwaystroke,2%);

@osm_roads_z14plus_minor_casing: darken(@highwaycasing,15%);
@osm_roads_z14plus_minor_stroke: lighten(@highwaystroke,2%);

@osm_roads_path_stroke: #181818;
@osm_tunnel_stroke: #111;

// labels
@label_foreground_fill: #ddd;
@label_foreground_halo_fill: #333;
@label_foreground_halo_radius: 1px;

@label_background_fill: #666;
@label_background_halo_fill: #333;

@labels_lowzoom_shield_fill: #999;
@labels_lowzoom_shield_halo_fill: #444;
@labels_lowzoom_shield_halo_radius: 1;

@labels_highzoom_text_fill: #ccc;
@labels_highzoom_halo_fill: #444;
@labels_highzoom_halo_radius: 1px;


@labels_highzoom_class1_text_fill: lighten(@labels_highzoom_text_fill,5%);
@labels_highzoom_class2_text_fill: lighten(@labels_highzoom_text_fill,15%);
@labels_highzoom_class1_text_size: 12;
@labels_highzoom_class1_text_size_default: 9;

@labels_marine_fill: lighten(#333336,20%);//darken(@label_foreground_fill,35%);
@labels_marine_halo_fill: #333336;//darken(@label_foreground_halo_fill,0%);
@labels_marine_halo_radius: 1px;

@osm_roads_labels_fill: lighten(#666,10);
@osm_roads_labels_halo: #222;
@osm_roads_labels_radius: 1px;

@countries_class1_text_fill: #888;
@countries_highzoom_class1_text_fill: darken(@label_background_fill,5%);

@countries_class2_label_size: 10px;
@countries_class2_text_fill: @countries_class1_text_fill;
@countries_class2_text_halo_radius: 1;

//state labels and similar start at z5
@admin1_labels_size: 14;
@admin1_labels: #888;
@admin1_labels_halo: #333;
@admin1_labels_halo_radius: 1px;

@admin1_lowzoom_labels_size: @admin1_labels_size;
@admin1_lowzoom_labels: @admin1_labels;
@admin1_lowzoom_labels_halo_radius: @admin1_labels_halo_radius;


@label_park_fill: darken(@label_foreground_fill,15%);
@label_park_halo_fill: darken(@label_foreground_halo_fill,10%);
@label_park_halo_radius: 1px;

@label_water_fill: lighten(#333336,30%);
@label_water_halo_fill: #333336;
@label_water_halo_radius: 1px;

/*
@label_water_fill: darken(@label_foreground_fill,20%);
@label_water_halo_fill: darken(@label_foreground_halo_fill,10%);
@label_water_halo_radius: 1px;
*/

@continent_labels: @label_foreground_fill;

// assets
@city_shield_file: url("http://s3.amazonaws.com/libs.cartocdn.com/stamen-base/city_shield_dark_444.png");
@city_shield_file_lowzoom: url("http://s3.amazonaws.com/libs.cartocdn.com/stamen-base/city_shield_dark_666.png");
@capital_shield_file: url("http://s3.amazonaws.com/libs.cartocdn.com/stamen-base/capital_shield_dark_444.png");
@capital_shield_file_lowzoom: url("http://s3.amazonaws.com/libs.cartocdn.com/stamen-base/capital_shield_dark_666.png");

@park_texture_opacity: 0.12;
