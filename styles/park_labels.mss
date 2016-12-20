// zooms 10+

#park_labels {
  [zoom=10][area>100000000],
  [zoom=11][area>25000000],
  [zoom=12][area>5000000],
  [zoom=13][area>2000000],
  [zoom=14][area>200000],
  [zoom=15][area>50000],
  [zoom=16][area>10000],
  [zoom>=17] {
    text-size: 12;
    text-name: "[name]";
    text-fill: @label_park_fill;
    text-halo-radius: @label_park_halo_radius;
    text-halo-fill: @label_park_halo_fill;
    text-face-name: "Open Sans Italic","DejaVu Sans Bold","unifont Medium";
    text-character-spacing: 1.0;
    text-wrap-width: 100;
    text-wrap-before: true;
    text-ratio: 0.5;
    [name=~".* Watershed"],
    [name=~".* Wilderness"],
    [name=~".* Wildlife Management Area"],
    [name=~".* Wildlife Refuge"] {
      text-name: "";
    }
  }
}
