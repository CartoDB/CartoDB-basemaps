// zooms 3-7

#admin1_labels[zoom>=5][zoom<=7]{
  text-name: "[name]";
  text-halo-fill: @admin1_labels_halo;
  text-face-name: "Open Sans Regular","DejaVu Sans Bold","unifont Medium";
  text-transform: uppercase;
  text-wrap-width: 10;

  [zoom=5][scalerank<3],
  [zoom=6][scalerank<4]{
    text-size: 11;
    text-halo-radius: 1;
    text-fill: @admin1_labels;
    text-character-spacing: 0.5;

    [zoom=6]{text-size:12;}
  }

  [zoom=7][scalerank<99]{
    text-size: @admin1_lowzoom_labels_size;
    text-halo-radius: @admin1_lowzoom_labels_halo_radius;
    text-fill: @admin1_lowzoom_labels;
  }
}
