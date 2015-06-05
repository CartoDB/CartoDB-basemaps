// Zooms 9-18

#greenareas  {
  [zoom>=9][zoom<=10] {
    polygon-fill: @greenareas_fill_low;
    [zoom=9][area<500000000],
    [zoom=10][area<250000000] {
    polygon-fill: fadeout(@greenareas_fill_low,50%);
    }

    polygon-pattern-alignment: global;
    polygon-pattern-opacity: @park_texture_opacity;
    polygon-pattern-file: url(http://s3.amazonaws.com/libs.cartocdn.com/stamen-base/park-halftone-1.png);
  }

  [zoom>=11] {
    polygon-fill: @greenareas_fill_medium;
    [zoom=11][area<100000000],
    [zoom=12][area<25000000],
    [zoom=13][area<2500000],
    [zoom=14][area<250000] {
      polygon-fill: fadeout(@greenareas_fill_medium,50%);
    }

    polygon-pattern-alignment: global;
    polygon-pattern-opacity: @park_texture_opacity;
    polygon-pattern-file: url(http://s3.amazonaws.com/libs.cartocdn.com/stamen-base/park-halftone-1.png);
  }

  [zoom>=15]{
    line-color: @greenareas_fill_high;
    line-width: 1;

    polygon-pattern-alignment: global;
    polygon-pattern-opacity: @park_texture_opacity;
    polygon-pattern-file: url(http://s3.amazonaws.com/libs.cartocdn.com/stamen-base/park-halftone-1.png);
  }
  
  /*[boundary = 'national_park'] {
    line-width: 0;
    polygon-fill: red;
  }*/
}
