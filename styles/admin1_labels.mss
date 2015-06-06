// zooms 3-7

#admin1_labels {
  [zoom=5][scalerank<3],
  [zoom=6][scalerank<4],
  [zoom=7][scalerank<99]
  {
    text-size: @admin1_labels_size;
    text-name: "[name]";
    text-halo-radius: @admin1_labels_halo_radius;
    text-fill: @admin1_labels;
    text-halo-fill: @admin1_labels_halo;
    text-face-name: "Azo Sans Regular","DejaVu Sans Bold","unifont Medium";
    text-transform: uppercase;
  }
}
