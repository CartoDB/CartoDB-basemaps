/*#parks {
  polygon-fill: #FF6600;
  polygon-opacity: 0.7;
  line-color: #000000;
  line-width: 0.5;
  line-opacity: 1;
}*/

/* ================================================================== */
/* NPS COLORS
/* ================================================================== */

// Park Point, Line, Poly //

@park: 				rgb(190,200,175);
@park_fill: 		darken(@park,5%);
@park_line: 		#4C7300;

@park_inset_fill: 	darken(rgba(219,227,217,0.5),5%);
@park_line_inset: 	rgb(147,171,108);

@park_point: 		darken(@park,10%);
@park_point_line: 	darken(rgb(147,171,108,),5%);

// Park Labels //

@park_label: 		#194000;
@park_label_halo: 	fadeout(white,35%);


#parks {
  polygon-fill: @park_fill; 
  polygon-opacity: 0.5;

  [zoom>=8]{
  polygon-fill:@park;
  polygon-opacity: 0.4;
  }

}

  