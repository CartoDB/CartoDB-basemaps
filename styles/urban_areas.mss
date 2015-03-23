// Zooms 4-7

#urban_areas {
  [zoom>=5][zoom<=6] {
    polygon-fill: @urbanareas;
    [scalerank>2] { polygon-fill: fadeout(@urbanareas,50%); }
    [scalerank>4] { polygon-fill: fadeout(@urbanareas,75%); }
  }
  [zoom=7] {
    polygon-fill: fadeout(@urbanareas,30%);
    [scalerank>2] { polygon-fill: fadeout(@urbanareas,60%); }
    [scalerank>4] { polygon-fill: fadeout(@urbanareas,80%); }
  }
  [zoom=8] {
    polygon-fill: fadeout(@urbanareas,50%);
    [scalerank>2] { polygon-fill: fadeout(@urbanareas,70%); }
    [scalerank>4] { polygon-fill: fadeout(@urbanareas,85%); }
  }
  [zoom=9] {
    polygon-fill: fadeout(@urbanareas,70%);
    [scalerank>4] { polygon-fill: fadeout(@urbanareas,85%); }
  }
}
