// Zooms 9-18

#osmroads {
  ::casing {
    line-width: 0;
  }
  ::outline {
    line-width: 0;
  }
  line-width: 0;

  [zoom=9][kind='highway'],
  [zoom=9][kind='major_road'] { 
    [kind='highway'] {
      ::outline {
        line-color: #fff;//@osm_roads_z9_highway_casing;
        line-width: 3;
      }
      line-width: 1;
      line-color: @osm_roads_z9_highway_stroke;
    }
    [kind='major_road'] {
      line-color: #c2adad;
      line-width: 0.5; 
    }
  }

  [zoom=10] { 
    [kind='highway'] {
      ::outline {
        line-color: #fff;//@osm_roads_z10_highway_casing;
        line-width: 3;
      }
      line-width: 1;
      line-color: #c2adad;//@osm_roads_z10_highway_stroke;
    }
    [kind='major_road'] {
      line-color: #c2adad;//@osm_roads_z10_major_stroke;
      line-width: 0.5; 
    }
    line-width: 0.5;
    line-color: #c2adad;//@osm_roads_z10_minor_stroke;
  }

  [zoom=11] { 
    [kind='highway'] {
      ::outline {
        line-color: #fff;//@osm_roads_z11_highway_casing;
        line-width: 4;
      }
      line-width: 2;
      line-color: #c2adad;//@osm_roads_z11_highway_stroke;
    }
    [kind='major_road'] {
      line-width: 1;
      line-color: #c2adad; //@osm_roads_z11_major_stroke;
    }

    [kind='minor_road'] {
      line-width: 0.5;
      line-color: #c2adad;//@osm_roads_z11_minor_stroke;
      line-cap: round;
    }
  }

  [zoom=12] { 
    [kind='highway'][is_link='no'] {
      ::outline {
        line-color: #fff;//@osm_roads_z12_highway_casing;
        line-width: 5;
      }
      line-width: 3;
      line-color: #c2adad;//@osm_roads_z12_highway_stroke;
    }
    [kind='major_road'][is_link='no'] {
      ::outline {
        line-color: #fff;//@osm_roads_z12_major_casing;
        line-width: 3;
      }
      line-width: 1;
      line-color: #c2adad; //@osm_roads_z12_major_stroke;
    }

    [kind='minor_road'] {
      ::outline {
        line-width: 1.5;
        line-color: @landmass_fill;
        line-cap: round;
      }

      line-width: 0.5;
      line-color: @osm_roads_z12_minor_stroke;
      line-cap: round;
    }
  }

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

    [kind='minor_road'] {
      ::outline {
        line-width: 3;
        line-color: @landmass_fill;
        line-cap: round;
      }

      line-width: 1;
      line-color: @osm_roads_z13_minor_stroke;
      line-cap: round;
    }
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

    [kind='minor_road'] {
      ::outline {
        line-width: 3;
        line-color: @landmass_fill;
        line-cap: round;
      }

      line-width: 1;
      line-color: @osm_roads_z14plus_minor_casing;
      line-cap: round;
    }
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
        line-width: 5;
      }
      line-width: 3;

      [is_link='yes'] {
        ::outline {
          line-width: 4;
        }
        line-width: 2;
      }
    }

    [kind='minor_road'] {
      ::outline {
        line-width: 4;
      }
      line-width: 2;
    }

    [kind='path'] {
      line-color: @osm_roads_path_stroke;
      line-width: 1.0;
    }
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
      line-width: 1.0;
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
      line-width: 2.0;
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
      line-width: 4.0;
    }
  }

  //Railways.

  [railway='rail'][zoom>=13] {
    line-width: 3;
    line-color: @rail_line;
    
    dash/line-width: 2;
    dash/line-color: @rail_dashline;
    dash/line-dasharray: 12,12;
  }
}
