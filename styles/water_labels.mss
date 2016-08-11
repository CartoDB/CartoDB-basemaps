// zooms 10+

#water_labels {
  [is_lake=1] {
    [zoom=9][area>100000000],
    [zoom=10][area>100000000],
    [zoom=11][area>25000000],
    [zoom=12][area>5000000],
    [zoom=13][area>0],
    [zoom=14][area>200000],
    [zoom=15][area>50000],
    [zoom=16][area>10000],
    [zoom>=17] {
      text-size: 11;
      text-name: "[name]";
      text-fill: @label_water_fill;
      text-halo-fill: @label_water_halo_fill;
      text-halo-radius: @label_water_halo_radius;
      text-face-name: "Open Sans Italic","DejaVu Sans Bold","unifont Medium";
      text-placement: interior;
      text-min-distance: 20;
      text-wrap-width: 100;
    }
  }
  [is_lake=0] {
    [zoom>=9] {
      text-size: 11;
      text-name: "[name]";
      text-fill: @label_water_fill;
      text-halo-fill: @label_water_halo_fill;
      text-halo-radius: @label_water_halo_radius;
      text-face-name: "Open Sans Italic","DejaVu Sans Bold","unifont Medium";
      text-placement: line;
      text-min-distance: 100;
      text-avoid-edges: true;

      [zoom>=13]{text-size: 13;}
    }
  }
}
