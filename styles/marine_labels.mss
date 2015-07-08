// zooms 2-8

#marine_labels {
  [zoom=2][scalerank=0],
  [zoom>=3][zoom<=4][scalerank<2],
  [zoom>=5][zoom<=6][scalerank<4],
  [zoom=7][scalerank<8],
  [zoom=8]
  {

    [featurecla='ocean'] {
      text-transform: capitalize;
    }

    text-name: [name];
    [namealt!=''] {
      text-name: [name] + '\n(' + [namealt] + ')';
    }
    text-face-name: 'Azo Sans Italic';
    text-wrap-width: 100;
    text-wrap-before: true;
    text-size: 12;

    text-line-spacing: -2;
    text-character-spacing: 1.1;

    text-placement: interior;
    text-fill: @labels_marine_fill;
    text-halo-radius: @labels_marine_halo_radius;
    text-halo-fill: @labels_marine_halo_fill;
    [zoom>=3][zoom<=8][featurecla='ocean'] {
      text-size: 14;

      [zoom>=4] {
        text-size: 18;
      }
    }
  }
}
