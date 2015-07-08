// Zooms 0-2

#continent_labels {
  text-size: 12;
  text-name: "[name]";
  text-halo-radius: 1.6px;
  text-halo-fill: @label_foreground_halo_fill;
  text-fill: @continent_labels;
  text-face-name: "Azo Sans Regular";
  text-transform: uppercase;

  [zoom=2] {
    text-size: 14;
  }
}
