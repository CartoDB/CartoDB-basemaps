#osmroads_labels[kind='major_road'] {
  text-name: "[name]";
  text-placement: line;
  text-face-name: "Open Sans Regular","DejaVu Sans Bold","unifont Medium";
  text-fill: @osm_roads_labels_fill;
  //text-transform: uppercase;
  text-halo-radius: @osm_roads_labels_radius;
  text-halo-fill: @osm_roads_labels_halo;
  text-size: 10px;
  text-character-spacing: 1.0;
  text-max-char-angle-delta: 30;
  text-min-distance: 14;
  text-avoid-edges: true;
  text-dy: 5;

  [zoom>=13] {
    text-size: 10px;
  }
}

#osmroads_labels[zoom>=16][kind='minor_road'] {
  text-name: "[name]";
  text-placement: line;
  text-face-name: "Open Sans Regular","DejaVu Sans Bold","unifont Medium";
  text-fill: @osm_roads_labels_fill;
  //text-transform: uppercase;
  text-halo-radius: @osm_roads_labels_radius;
  text-halo-fill: @osm_roads_labels_halo;
  text-size: 10px;
  text-character-spacing: 1.0;
  text-max-char-angle-delta: 30;
  text-min-distance: 14;
  text-avoid-edges: true;
  text-dy: 5;
}
