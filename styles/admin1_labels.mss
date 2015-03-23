// zooms 3-7

#admin1_labels {
  [zoom=5][scalerank<3],
  [zoom=6][scalerank<4],
  [zoom=7][scalerank<99]
  {

    text-size: 12;
    text-name: "[name]"; 
    text-halo-radius: 1.4px;
    text-fill: @admin1_labels;
    text-halo-fill: @admin1_labels_halo;
    text-face-name: "Azo Sans Regular","DejaVu Sans Bold","unifont Medium";
    text-transform: uppercase;
  }
}
