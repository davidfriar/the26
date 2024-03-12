include<keys.scad>;

kx = 18;
ky = 17;
plate_thickness = 1.2;
plate_gap = 1;
pcb_thickness = 1.6;
keycap_height = 8; // distance from bottom of pcb to bottom of keycaps TODO:
// need a real value for this by measuring keycaps

left_plate();
// right_plate();
// left_pcb();
// left_keycaps();
// right_keycaps();

module left_plate() {
  translate([ 0, -left_plate_height, 0 ]) {
    color("grey") linear_extrude(height = plate_thickness)
        import("left_plate.svg");
  }
  translate([ plate_padding, -plate_padding, -(plate_gap + pcb_thickness) ]) {
    left_pcb();
  }
}

module right_plate() {
  translate([ 0, -right_plate_height, 0 ]) {
    color("grey") linear_extrude(height = plate_thickness)
        import("right_plate.svg");
  }
  translate([ plate_padding, -plate_padding, -(plate_gap + pcb_thickness) ]) {
    right_pcb();
  }
}

module left_pcb() {
  translate([ -pcb_offset_x, -pcb_offset_y ]) { import("leftpcb.stl"); }
  translate([ 0, 0, keycap_height ]) left_keycaps();
}

module right_pcb() {
  translate([ -pcb_offset_x, -pcb_offset_y ]) { import("rightpcb.stl"); }
  translate([ 0, 0, keycap_height ]) right_keycaps();
}

module left_keycaps() {
  translate([ -pcb_offset_x, -pcb_offset_y ]) {
    for (i = [0:11]) {
      point = left_key_points[i];
      translate(point) {
        if (i < 10) {
          if (i % 2 == 0) {
            bottom_row_keycap();
          } else {
            top_row_keycap();
          }
        } else {
          if (i == 10) {
            thumb_row_keycap_left();
          } else {
            thumb_row_keycap_right();
          }
        }
      }
    }
  }
}

module right_keycaps() {
  translate([ -pcb_offset_x, -pcb_offset_y ]) {
    for (i = [0:13]) {
      point = right_key_points[i];
      translate(point) {
        if (i < 12) {
          if (i % 2 == 0) {
            bottom_row_keycap();
          } else {
            top_row_keycap();
          }
        } else {
          if (i == 12) {
            thumb_row_keycap_right();
          } else {
            thumb_row_keycap_left();
          }
        }
      }
    }
  }
}

module bottom_row_keycap() { import("chicagoSteno/r2r4-topbottom-rows.stl"); }

module top_row_keycap() { rotate(180, [ 0, 0, 1 ]) bottom_row_keycap(); }

module thumb_row_keycap_right() { import("chicagoSteno/cs_t_15_r.stl"); }
module thumb_row_keycap_left() { import("chicagoSteno/cs_t_15_l.stl"); }
