// Zooms 2-9 from Natural Earth, zoom 10+ from OSM

#admin0boundaries {
  ::outline {
    line-width: 0;
  }
	line-color: @admin0_4;
  line-width: 0.5;

  [zoom=4] {
    line-color: @admin0_4;
  }

  [zoom>=5] {
    line-width: 0.5;
    line-color: @admin0_5;
  }

  [zoom=6] {
    ::outline {
      line-width: 8;
      line-color: @admin0_6;
      line-opacity: 0.5;
    }

    line-width: 0.5;
    line-color: @admin0_5;
  }

  [zoom>=7] {
    ::outline {
      line-width: 8;
      line-color: @admin0_6;
      line-opacity: 0.5;
    }

    line-color: @admin0_7;
    line-width: 1.5;
  }

  [unit=true] {
    // Only applies to "map units" from Natural Earth, aka national boundaries within the UK and Belgium, mainly..
    line-dasharray: 2,2;
  }
}
