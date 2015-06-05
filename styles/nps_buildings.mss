 @building:   #d7d7d7;

#buildings {
  ::wall[zoom>=16] {
    polygon-geometry-transform: translate(1,1);  
    polygon-fill:@building * 0.80;
  }

  ::roof {
    polygon-fill: darken(@building,5 );
    line-color: @building;
    line-width: 0.5;  
  }
}
