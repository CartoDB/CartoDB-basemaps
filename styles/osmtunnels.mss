// zoom 13+

#osmtunnels {
  ::outline {
    line-width: 0;
  }
  line-width: 0;
  line-color: @osm_tunnel_stroke;
   
  [zoom=13] {
    [kind='highway'] {
      ::outline {
        line-color: @osm_roads_z13_highway_casing; 
        line-width: 6;
      }
      line-width: 4;
    }
    [kind='major_road'] {
      ::outline {
        line-color: @osm_roads_z13_major_casing;
        line-width: 5;
      }
      line-width: 3;
    }
    line-width: 1;
  }

  [zoom>=14] { 
    [kind='highway'] {
      ::outline {
        line-color: @osm_roads_z14plus_highway_casing;
        line-width: 6;
      }
      line-width: 4;
    }
    [kind='major_road'] {
      ::outline {
        line-color: @osm_roads_z14plus_major_casing;
        line-width: 5;
      }
      line-width: 3;
    }

    ::outline {
      line-color: @osm_roads_z14plus_minor_casing;
      line-width: 3;
    }
    line-width: 1;
  }

  [zoom=15] { 
    [kind='highway'] {
      ::outline {
        line-width: 8;
      }
      line-width: 6;
    }
    [kind='major_road'] {
      ::outline {
        line-width: 7;
      }
      line-width: 5;
    }

    ::outline {
      line-width: 5;
    }
    line-width: 3;
  }

  [zoom=16] { 
    [kind='highway'] {
      ::outline {
        line-width: 10;
      }
      line-width: 8;
    }
    [kind='major_road'] {
      ::outline {
        line-width: 7;
      }
      line-width: 5;
    }

    [kind='minor_road'] {
      ::outline {
        line-width: 6;
      }
      line-width: 4;
    }

    [kind='path'] {
      line-color: @osm_roads_path_stroke;
      line-width: 0.5;
    }
  }

  [zoom=17] { 
    [kind='highway'] {
      ::outline {
        line-width: 12;
      }
      line-width: 10;
    }
    [kind='major_road'] {
      ::outline {
        line-width: 10;
      }
      line-width: 8;
    }

    [kind='minor_road'] {
      ::outline {
        line-width: 8;
      }
      line-width: 6;
    }

    [kind='path'] {
      line-color: @osm_roads_path_stroke;
      line-width: 0.5;
    }
  }

  [zoom=18] { 
    [kind='highway'] {
      ::outline {
        line-width: 16;
      }
      line-width: 14;
    }
    [kind='major_road'] {
      ::outline {
        line-width: 12;
      }
      line-width: 10;
    }

    [kind='minor_road'] {
      ::outline {
        line-width: 10;
      }
      line-width: 8;
    }

    [kind='path'] {
      line-color: @osm_roads_path_stroke;
      line-width: 0.5;
    }
  }

  [railway='rail'] {
    line-width: 3;
    line-color: @osm_tunnel_stroke;
  }
}

