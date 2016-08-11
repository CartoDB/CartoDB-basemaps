// zoom 13+

#osmbridges {
  ::casing, ::outline {
    line-width: 0;
  }
  line-width: 0;
   
  [zoom=13] {
    [kind='highway'] {
      ::outline {
        line-color: @osm_roads_z13_highway_casing; 
        line-width: 6;
      }
      line-width: 4;
      line-color: @osm_roads_z13_highway_stroke;

      [is_link='yes'] {
        ::outline {
          line-width: 4;
        }
        line-width: 2;
      }
    }
    [kind='major_road'] {
      ::outline {
        line-color: @osm_roads_z13_major_casing;
        line-width: 5;
      }
      line-width: 3;
      line-color: @osm_roads_z13_major_stroke;

      [is_link='yes'] {
        ::outline {
          line-width: 3;
        }
        line-width: 1;
      }
    }
    line-width: 1;
    line-color: @osm_roads_z13_minor_stroke;
  }

  [zoom>=14] { 
    [kind='highway'] {
      ::outline {
        line-color: @osm_roads_z14plus_highway_casing;
        line-width: 6;
      }
      line-width: 4;
      line-color: @osm_roads_z14plus_highway_stroke;

      [is_link='yes'] {
        ::outline {
          line-width: 4;
        }
        line-width: 2;
      }
    }
    [kind='major_road'] {
      ::outline {
        line-color: @osm_roads_z14plus_major_casing;
        line-width: 5;
      }
      line-width: 3;
      line-color: @osm_roads_z14plus_major_stroke;

      [is_link='yes'] {
        ::outline {
          line-width: 4;
        }
        line-width: 2;
      }
    }

    ::outline {
      line-color: @osm_roads_z14plus_minor_casing;
      line-width: 3;
    }
    line-width: 1;
    line-color: @osm_roads_z14plus_minor_stroke;
  }

  [zoom=15] { 
    [kind='highway'] {
      ::outline {
        line-width: 8;
      }
      line-width: 6;

      [is_link='yes'] {
        ::outline {
          line-width: 5;
        }
        line-width: 3;
      }
    }
    [kind='major_road'] {
      ::outline {
        line-width: 7;
      }
      line-width: 5;

      [is_link='yes'] {
        ::outline {
          line-width: 4;
        }
        line-width: 2;
      }
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

      [is_link='yes'] {
        ::outline {
          line-width: 8;
        }
        line-width: 6;
      }
    }
    [kind='major_road'] {
      ::outline {
        line-width: 7;
      }
      line-width: 5;

      [is_link='yes'] {
        ::outline {
          line-width: 5;
        }
        line-width: 3;
      }
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

      [is_link='yes'] {
        ::outline {
          line-width: 10;
        }
        line-width: 8;
      }
    }
    [kind='major_road'] {
      ::outline {
        line-width: 10;
      }
      line-width: 8;

      [is_link='yes'] {
        ::outline {
          line-width: 8;
        }
        line-width: 6;
      }
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

      [is_link='yes'] {
        ::outline {
          line-width: 14;
        }
        line-width: 12;
      }
    }
    [kind='major_road'] {
      ::outline {
        line-width: 12;
      }
      line-width: 10;

      [is_link='yes'] {
        ::outline {
          line-width: 10;
        }
        line-width: 8;
      }
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
    line-color: @rail_line;
    
    dash/line-width: 2;
    dash/line-color: @rail_dashline;
    dash/line-dasharray: 12,12;
  }
}
