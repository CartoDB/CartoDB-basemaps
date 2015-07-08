@polygoncolor: #ffd479;
@cachebuster: #0000c7;
@water: #cdd2d4;


Map {
	background-color: @water;
  buffer-size: 256;
}

@landmass_fill: lighten(#e3e3dc, 8%);
@landmass_line: darken(#bfc7c8, 10%);

@greenareas_fill_low: lighten(#d4dad6,8%);
@greenareas_fill_medium: lighten(#d4dad6,5%);
@greenareas_fill_high: lighten(#d4dad6,6%);

@buildings: lighten(#e3e3dc, 5%);
@buildings_outline_16: #ddd;
@buildings_outline: #ddd;

@aeroways: #e8e8e8;

@ne10roads_line_color: white;
@ne10roads_line_outline: darken(#b4b2a3, 2%);
@ne10roads_7_minor_color: darken(@ne10roads_line_color,12%);

@ne_rivers_stroke: lighten(#346fa1,30%);
@ne_rivers_casing: darken(#f5f5f3,1%);

@urbanareas: darken(#f5f5f3, 4%);
@urbanareas_highzoom: darken(#f5f5f3, 3%);


@admin0_4: lighten(#c79297, 20%);
@admin0_5: lighten(#c99297,10%);
@admin0_6: mix(lighten(#c99297, 20%), lighten(#e3e3dc, 8%), 20);
@admin0_7: lighten(#c99297,20%);

@admin1_lowzoom: lighten(#6d6e71, 40%);
@admin1_highzoom: lighten(#c79297, 15%);

//osm roads
@rail_line: #dddddd;
@rail_dashline: #fafafa;

@osm_roads_z9_highway_casing: #ccc;
@osm_roads_z9_highway_stroke: white;
@osm_roads_z9_major_stroke: #d3d3d3;

@osm_roads_z10_highway_casing: #ccc;
@osm_roads_z10_highway_stroke: white;
@osm_roads_z10_major_stroke: #ccc;
@osm_roads_z10_minor_stroke: #ddd;

@osm_roads_z11_highway_casing: #ccc;
@osm_roads_z11_highway_stroke: white;
@osm_roads_z11_major_stroke: #d4d4d4;
@osm_roads_z11_minor_stroke: #ddd;

@osm_roads_z12_highway_casing: #c4c4c4;
@osm_roads_z12_highway_stroke: white;
@osm_roads_z12_major_casing: #d9d9d9;
@osm_roads_z12_major_stroke: #fefefe;
@osm_roads_z12_minor_stroke: #ddd;

@osm_roads_z13_highway_casing: #c0c0c0;
@osm_roads_z13_highway_stroke: white;
@osm_roads_z13_major_casing: #ccc;
@osm_roads_z13_major_stroke: #fcfcfc;
@osm_roads_z13_minor_stroke: #ddd;

@osm_roads_z14plus_highway_casing: #bbb;
@osm_roads_z14plus_highway_stroke: white;
@osm_roads_z14plus_major_casing: #c4c4c3;
@osm_roads_z14plus_major_stroke: white;
@osm_roads_z14plus_minor_casing: #ddd;
@osm_roads_z14plus_minor_stroke: #f9f9f9;

@osm_roads_path_stroke: #eee;
@osm_tunnel_stroke: #eee;

// labels
@label_foreground_fill: #8494a1;
@label_foreground_halo_fill: rgba(236,236,234,0.7);
@label_foreground_halo_radius: 1.4px;

@label_background_fill: #b6b6b6;
@label_background_halo_fill: rgba(255,255,255,0.7);

@labels_lowzoom_shield_fill: lighten(@label_foreground_fill, 7%);
@labels_lowzoom_shield_halo_fill: lighten(@label_foreground_halo_fill,10%);
@labels_lowzoom_shield_halo_radius: 1.3px

@labels_highzoom_text_fill: lighten(@label_foreground_fill,15%);
@labels_highzoom_halo_fill: lighten(@label_foreground_halo_fill,10%);
@labels_highzoom_halo_radius: 1.4px;

@labels_highzoom_class1_text_fill: lighten(@label_foreground_fill,5%);
@labels_highzoom_class2_text_fill: darken(@label_foreground_fill,5%);
@labels_highzoom_class1_text_size: 12;
@labels_highzoom_class1_text_size_default: 10;

@labels_marine_fill: white;
@labels_marine_halo_fill: lighten(@label_foreground_fill,10%);
@labels_marine_halo_radius: 1.4px;

@osm_roads_labels_fill: #bbb;
@osm_roads_labels_halo: white;
@osm_roads_labels_radius: 1.8px;

@countries_class1_text_fill: lighten(@label_foreground_fill,5%);
@countries_highzoom_class1_text_fill: darken(@label_background_fill,5%);

@countries_class2_label_size: 10px;
@countries_class2_text_fill: lighten(@label_foreground_fill,10%);
@countries_class2_text_halo_radius: 1.8;

@admin1_labels_size: 10;
@admin1_labels: rgba(255,255,255,1);
@admin1_labels_halo: rgba(47,48,53,0.8);
@admin1_labels_halo_radius: 1.4px;

@admin1_lowzoom_labels_size: @admin1_labels_size;
@admin1_lowzoom_labels: @admin1_labels;
@admin1_lowzoom_labels_halo_radius: @admin1_labels_halo_radius;

@label_park_fill: darken(#d4ded6, 30%);
@label_park_halo_fill: lighten(#e3e3dc, 8%);
@label_park_halo_radius: 1.4px;

@label_water_fill: lighten(#6b8a95, 5%);
@label_water_halo_fill: lighten(#e3e3dc, 8%);
@label_water_halo_radius: 1.4px;

@continent_labels: @label_foreground_fill;

// assets
@city_shield_file: url("http://s3.amazonaws.com/libs.cartocdn.com/stamen-base/city_shield_light.svg");
@city_shield_file_lowzoom: url("http://s3.amazonaws.com/libs.cartocdn.com/stamen-base/city_shield_light.svg");
@capital_shield_file: url("http://s3.amazonaws.com/libs.cartocdn.com/stamen-base/capital_shield_light.png");
@capital_shield_file_lowzoom: url("http://s3.amazonaws.com/libs.cartocdn.com/stamen-base/capital_shield_light.png");

@park_texture_opacity: 0.0;
