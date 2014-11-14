@polygoncolor: #ffd479;
@cachebuster: #000096;
@water: darken(#333336,9%);
//@water: lighten(#101014,2%); //too purple
//@water: #101014;


Map {
//  background-color: darken(#333, 9%);
  background-color: @water;
  buffer-size: 256;
}

//@landmass_fill: darken(#333333, 9%);
@landmass_fill: #0e0e0e;
@landmass_line: black;

@greenareas: darken(#263302, 9%);
@greenareas_fill_low: @greenareas;
@greenareas_fill_medium: @greenareas;
@greenareas_fill_high: @greenareas;

@buildings: darken(@landmass_fill, 2%);
@buildings_outline_16: #141414;
@buildings_outline: #242424;

@aeroways: #111;

@ne10roads_line_color: rgba(0,0,0,0.8);
@ne10roads_line_outline: rgba(200,200,200,0.3);
@ne10roads_7_minor_color: #1f1f1f;

@ne_rivers_stroke: #1f1f1f;
@ne_rivers_casing: rgba(0,0,0,0.1);

@urbanareas: lighten(@landmass_fill,1%);
@urbanareas_highzoom: lighten(@landmass_fill,1%);

@admin0_4: #333;
@admin0_5: #444;
@admin0_6: #151515;
@admin0_7: #444;

@admin1_lowzoom: #292929;
@admin1_highzoom: #444;

@admin1_labels: #333;
@admin1_labels_halo: #111;

//osm roads
@rail_line: #2f2f2f;
@rail_dashline: #111;

@highwaycasing: rgba(50,50,50,0.9);
@highwaystroke: black;

@osm_roads_z9_highway_casing: rgba(50,50,50,0.5);
@osm_roads_z9_highway_stroke: @highwaystroke;
@osm_roads_z9_major_stroke: #2a2a2a;

@osm_roads_z10_highway_casing: rgba(50,50,50,0.7);
@osm_roads_z10_highway_stroke: @highwaystroke;
@osm_roads_z10_major_stroke: #2a2a2a;
@osm_roads_z10_minor_stroke: #252525;

@osm_roads_z11_highway_casing: @highwaycasing;
@osm_roads_z11_highway_stroke: @highwaystroke;
@osm_roads_z11_major_stroke: #2a2a2a;
@osm_roads_z11_minor_stroke: #252525;

@osm_roads_z12_highway_casing: lighten(@highwaycasing,5%);
@osm_roads_z12_highway_stroke: @highwaystroke;
@osm_roads_z12_major_casing: darken(@highwaycasing,2%);
@osm_roads_z12_major_stroke: lighten(@highwaystroke,2%);
@osm_roads_z12_minor_stroke: #222;

@osm_roads_z13_highway_casing: lighten(@highwaycasing,5%);
@osm_roads_z13_highway_stroke: @highwaystroke;
@osm_roads_z13_major_casing: darken(@highwaycasing,3%);
@osm_roads_z13_major_stroke: lighten(@highwaystroke,2%);
@osm_roads_z13_minor_stroke: #222;

@osm_roads_z14plus_highway_casing: lighten(@highwaycasing,2%);
@osm_roads_z14plus_highway_stroke: lighten(@highwaystroke,5%);
@osm_roads_z14plus_major_casing: darken(@highwaycasing,2%);
@osm_roads_z14plus_major_stroke: lighten(@highwaystroke,2%);

@osm_roads_z14plus_minor_casing: darken(@highwaycasing,10%);
@osm_roads_z14plus_minor_stroke: lighten(@highwaystroke,5%);

@osm_roads_path_stroke: #181818;
@osm_tunnel_stroke: #111;

// labels
@label_foreground_fill: #777;
@label_foreground_halo_fill: rgba(0,0,0,0.7);
@label_background_fill: #444;
@label_background_halo_fill: rgba(0,0,0,0.3);
@labels_lowzoom_shield_fill: darken(@label_foreground_fill, 15%); 
@labels_lowzoom_shield_halo_fill: black;
@labels_highzoom_text_fill: #444;
@labels_highzoom_halo_fill: darken(@label_foreground_halo_fill,10%);

@labels_highzoom_class1_text_fill: lighten(@labels_highzoom_text_fill,5%);
@labels_highzoom_class2_text_fill: lighten(@labels_highzoom_text_fill,15%);

@labels_marine_halo_fill: darken(@label_foreground_halo_fill,10%);
@labels_marine_fill: darken(@label_foreground_fill,20%);

@osm_roads_labels_fill: #444;
@osm_roads_labels_halo: black;

// assets
@city_shield_file: url("https://dl.dropboxusercontent.com/u/2624290/stamen_cartodb_icons/city_shield_dark_444.png");
@city_shield_file_lowzoom: url("https://dl.dropboxusercontent.com/u/2624290/stamen_cartodb_icons/city_shield_dark_666.png");
@capital_shield_file: url("https://dl.dropboxusercontent.com/u/2624290/stamen_cartodb_icons/capital_shield_dark_444.png");
@capital_shield_file_lowzoom: url("https://dl.dropboxusercontent.com/u/2624290/stamen_cartodb_icons/capital_shield_dark_666.png");

@label_park_halo_fill: darken(@label_foreground_halo_fill,10%);
@label_park_fill: darken(@label_foreground_fill,15%);

@label_water_halo_fill: darken(@label_foreground_halo_fill,5%);
@label_water_fill: darken(@label_foreground_fill,20%);

@park_texture_opacity: 0.1;
