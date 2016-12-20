// Zooms 6-8

#ne10mroads {
  ::underneath {
    line-color: @ne10roads_line_color;
    line-width: 0;
  }

  ::outline{
    line-color: @ne10roads_line_outline;
    line-width: 0;
  }

	[zoom>=6][scalerank<7]{
    line-color: @ne10roads_7_minor_color;
    line-width: 1;
  }
    
  [zoom>=7] {
    [scalerank<7] {
      ::outline{
        line-color: @ne10roads_line_outline;
        line-width: 2.5;
      }
      line-color: @ne10roads_line_color;
      line-width: 1.8;
    }
    [scalerank>=7] {
      ::underneath {
        line-color: @ne10roads_7_minor_color;
        line-width: 1;
      }
    }
  }
}
