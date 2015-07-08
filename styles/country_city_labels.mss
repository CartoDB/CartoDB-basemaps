// Zooms 1-13

#country_city_labels[country_city="city"] {
  [zoom=4][scalerank<=4],
  [zoom=5][scalerank<=5],
  [zoom=6][scalerank<=6],
  [zoom=7][scalerank<=7] {
    shield-name: "[name]";
    shield-fill: @label_foreground_fill;
    shield-halo-fill: @labels_lowzoom_shield_halo_fill;
    shield-face-name: "Azo Sans Regular","DejaVu Sans Bold","unifont Medium";
    shield-halo-radius: @labels_lowzoom_shield_halo_radius;
    shield-text-transform: uppercase;
    shield-min-distance: 5;
    [zoom=5] {
      shield-min-distance: 0;
    }
    shield-file: @city_shield_file_lowzoom;
    [is_capital=true] {
      shield-file: @capital_shield_file_lowzoom;
    }
    shield-character-spacing: 1.2;
    shield-line-spacing: -1;
    shield-placement-type: simple;

    shield-placements: "E,W,12";
    [cartodb_id =~ '.*(0|2|4|6|8)$'] {
      shield-placements: "E,12";
    }
    [cartodb_id =~ '.*(1|3|5|7|9)$'] {
      shield-placements: "W,12";
    }
    shield-text-dx: 6;
    shield-text-dy: 0;
    shield-unlock-image: true;
    shield-wrap-width: 100;
    shield-wrap-before: true;

    [zoom=6][scalerank>4] {
      shield-fill: @labels_lowzoom_shield_fill;
      shield-file: @city_shield_file;
      [is_capital=true]{
        shield-file: @capital_shield_file;
      }
    }
    [zoom=6][scalerank<=4],
    [zoom=6][is_capital=true] {
      shield-size: 14;
      shield-line-spacing: -2;
    }

    [zoom=7][scalerank>5] {
      shield-fill: @labels_lowzoom_shield_fill;
      shield-file: @city_shield_file;
      shield-min-distance: 20;
      [is_capital=true]{
        shield-file: @capital_shield_file;
      }
    }
    [zoom=7][scalerank<=5],
    [zoom=7][is_capital=true] {
      shield-size: 14;
      shield-line-spacing: -2;
    }
  }

  // Transition from townpoints to plain text at z8

  [zoom=8][scalerank<=7],
  [zoom=9][scalerank<=9],
  [zoom=10][scalerank<=9],
  [zoom=11][scalerank<=10],
  [zoom=12][scalerank<=10],
  [zoom>=13][place='town'],
  [zoom>=13][place='village'],
  [zoom>=13][place='suburb'],
  [zoom>=13][place='neighbourhood'] {

    text-name: "[name]";
    text-face-name: "Azo Sans Regular","DejaVu Sans Bold","unifont Medium";
    text-transform: uppercase;

    text-wrap-width: 100;
    text-wrap-before: true;
    text-character-spacing: 1.2;
    text-halo-radius: @labels_highzoom_halo_radius;
    text-halo-fill: @labels_highzoom_halo_fill;
    text-fill: @labels_highzoom_text_fill;

    text-min-distance: 10;

    // class 1 (bigger)
    [zoom=8][scalerank<=6],
    [zoom=9][scalerank<=7],
    [zoom=10][scalerank<=7] {
      text-size: @labels_highzoom_class1_text_size;
      text-fill: @labels_highzoom_class1_text_fill;
      text-line-spacing: -2;
    }
    [zoom=11][scalerank<=7],
    [zoom=12][scalerank<=7] {
      text-size: 14;
      text-fill: @labels_highzoom_class1_text_fill;
    }

    // class 2 (biggest)
    [zoom=8][scalerank<=5],
    [zoom=9][scalerank<=5],
    [zoom=10][scalerank<=5] {
      text-size: 16;
      text-fill: @labels_highzoom_class2_text_fill;
    }
    [zoom=11][scalerank<=5],
    [zoom=12][scalerank<=5]
    {
      text-size: 18;
      text-fill: @label_foreground_fill;
    }

    // class 0 (default)
    text-size: @labels_highzoom_class1_text_size_default;

    // At this zoom cities disappear, and it's only neighborhoods
    [zoom>=13] {
      text-size: 11;
      text-fill: @label_foreground_fill;
    }
  }
}

#country_city_labels[country_city="country"]{
  [zoom=3][scalerank<2][pop_est >= 2000000],
  [zoom=4][scalerank<3][pop_est >= 2000000],
  [zoom=5][scalerank<4] {
    text-size: 15;
    text-line-spacing: -3;
    text-wrap-width: 100;
    text-wrap-before: true;
    text-ratio: 0.5;
    text-name: "[name]";
    [name="Falkland Islands"] {
      text-name: [name] + "\n(Malvinas)";
    }

    text-halo-radius: @label_foreground_halo_radius;
    text-halo-fill: @label_foreground_halo_fill;
    text-face-name: "Azo Sans Regular","DejaVu Sans Bold","unifont Medium";
    text-min-distance: 10;
    text-transform: uppercase;

    [zoom=3] {
      text-size: @countries_class2_label_size;
      text-fill: @countries_class2_text_fill;
      text-halo-radius: @countries_class2_text_halo_radius;

      [pop_est>20000000] {
        text-size: 14;
        text-fill: @countries_class1_text_fill;
        text-halo-radius: @label_foreground_halo_radius;
        text-halo-fill: @label_foreground_halo_fill;
      }
    }
    [zoom=4],[zoom=5] {
      text-size: 12;
      text-line-spacing: -3;

      text-fill: @countries_highzoom_class1_text_fill;
      text-halo-fill: @label_background_halo_fill;
      text-halo-radius: @label_foreground_halo_radius;
      text-face-name: "Azo Sans Regular","DejaVu Sans Bold","unifont Medium";

      [pop_est>20000000] {
        text-size: 16;
        text-line-spacing: -4;
        text-wrap-width: 200;
      }
    }
  }
}
