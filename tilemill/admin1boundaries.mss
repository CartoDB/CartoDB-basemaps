// Zooms 2+

#admin1boundaries {
  [zoom=2],
  [zoom=3][scalerank<4],
  [zoom=4][scalerank<5],
  [zoom=5][scalerank<5],
  [zoom=6][scalerank<5],
  [zoom=7][scalerank<6],
  [zoom=8][scalerank<7],
  [zoom>8]
  {
    eraser/line-color: @landmass_fill;
    eraser/line-width: 0.5;
    line-width: 0.5;
    line-color: @admin1_lowzoom;
    [zoom>=6] {
      line-color: @admin1_highzoom;
    }
  
    [zoom>=7] {
      eraser/line-width: 1;
      line-width: 1;
      line-dasharray: 2,2;
    }
    [zoom>=9] {
      eraser/line-width: 2;
      line-width: 2;
    }
  }
}
