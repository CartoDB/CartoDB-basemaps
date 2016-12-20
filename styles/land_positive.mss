// Zooms 0-8

#land_positive {
	::outline{
	  line-color: @landmass_line;
	  line-width: 1;
  }
  polygon-fill: @landmass_fill;
    
	::outline[zoom=5] { line-width: 1.5; }
	::outline[zoom=6] { line-width: 2; }
  ::outline[zoom=7] { line-width: 2; }
  ::outline[zoom=8] { line-width: 2; line-miterlimit: 1; }
}
	
