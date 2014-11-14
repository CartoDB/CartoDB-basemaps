// Zooms 12 and up

#aeroways {
  line-cap: square;
  line-join: miter;
  line-color: @aeroways;

  [type='runway'] {
    [zoom=12] {
      line-width: 2;
    }

    [zoom=13] {
      line-width: 4;
    }

    [zoom=14] {
      line-width: 8;
    }

    [zoom=15] {
      line-width: 16;
    }

    [zoom=16] {
      line-width: 32;
    }

    [zoom=17] {
      line-width: 64;
    }

    [zoom>=18] {
      line-width: 128;
    }
  }

  [type='taxiway'] {
    [zoom=13] {
      line-width: 1;
    }

    [zoom=14] {
      line-width: 2;
    }

    [zoom=15] {
      line-width: 4;
    }

    [zoom=16] {
      line-width: 8;
    }

    [zoom=17] {
      line-width: 16;
    }

    [zoom>=18] {
      line-width: 32;
    }
  }
}
