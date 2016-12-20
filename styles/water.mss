// Zooms 3-18

#water {
  ::outline {
    line-color: @landmass_line;
    line-width: 0;
  }

  // Natural Earth
  [zoom >= 3][zoom < 8] {
    ::outline {
      line-width: 0;
      line-color: @ne_rivers_casing;
    }

    [is_lake=0] {
      [zoom=4][ne_scalerank<3],
      [zoom=5][ne_scalerank<4],
      [zoom>5][ne_scalerank<5] {
        ::outline {
          line-width: 3;
        }
      
        line-color: @ne_rivers_stroke;
        line-width: 0.5;
      }
    }

    [is_lake=1] {
      polygon-fill: @water;

      ::outline {
        line-color: @landmass_line;
        line-width: 1;
      }
    }
  }

  // OSM
  [zoom >= 8] {
    [is_lake=0] {
      line-color: @water;
      line-width: 0.5;

      // to avoid excessive detail near Perpignan, France (10/42.6380/2.6944)
      [zoom<13][type='riverbank'] {
        line-width: 0;
      }
    }

    [is_lake=1] {
      polygon-fill: @water;

      ::outline[zoom=8][area>500000000] { line-width: 1; }
      ::outline[zoom=9][area>100000000] { line-width: 1.5; }
      ::outline[zoom=10][area>100000000] { line-width: 2; }
      ::outline[zoom=11][area>10000000] { line-width: 2.5; }
      ::outline[zoom=12][area>1000000] { line-width: 2.25; }
      ::outline[zoom=13][area>1000000] { line-width: 2.5; }
      ::outline[zoom=14][area>1000000] { line-width: 2.75; }
      ::outline[zoom=15][area>1000000] { line-width: 3; }
      ::outline[zoom=16][area>1000000] { line-width: 3.25; }
      ::outline[zoom=17][area>1000000] { line-width: 3.5; }
      ::outline[zoom=18][area>1000000] { line-width: 4; }
    }
  }
}
