// clang-format off
include<BOSL2/std.scad>;
include <BOSL2/fnliterals.scad>;
include <BOSL2/rounding.scad>;
include<keys.scad>;
// clang-format on
$fn = 32;
$side = "left";

rounding_k = 0.5;
rounding_joint = 6.2;

kx = 18;
ky = 17;
plate_thickness = 1.2;
plate_gap = 1;
plate_padding = 2;
pcb_thickness = 1.6;
keycap_height = 8; // distance from bottom of pcb to bottom of keycaps TODO:
pcb_offset_y = 2.5;
gasket_width = 3.5;
gasket_length = 1.5 * kx;
gasket_thickness = 2; // gasket thickness when compressed

insert_hole_diameter = 3.2;
insert_hole_depth = 4.25;
insert_hole_mount_diameter = insert_hole_diameter + 3;
base_hole_diameter = 2.4;
base_hole_countersink_diameter = 4;
base_hole_countersink_depth = 2;

all();
// gasket();

// left_plate();
// gasket_tab();
// need a real value for this by measuring keycaps
// left_case();
// test();
// thumb_row_keycap_left();
// left_plate();
//    right_plate();
//    left_pcb();
// right_pcb();
// left_keycaps();
//  right_keycaps();
// daughterboard_left();
// daughterboard_right();
// new_plate();

module all() {
  left(100) left_case();
  right(100) right_case();
}

module left_case() {
  $side = "left";
  case();
  fwd(1.5*ky + 2 ) left(1.5*kx+6) daughterboard();
}

module right_case() {
  $side = "right";
  case();

}

module case(){
  // gaskets();
  // up(gasket_thickness) plate();
  // up(gasket_thickness + plate_thickness) gaskets();
  // color("red") layout_holes();
  plate();
  base2d();
}



module base2d(){
  d = 7/8 * kx ;
  points =  [
    back(d,inwards(d,inner_top())), 
    fwd(d+kx/4,inwards(d,inner_thumb())), 
    fwd(d,outwards(d,outer_bottom_corner())), 
    back(d,outwards(d,outermost_top())),
  ];
  rounded = round_corners(points, k = rounding_k, joint = rounding_joint,
                               method = "smooth");

  start = inwards(rounding_joint, points[3]);
  mid = back(d, middle_top());
  end = outwards(rounding_joint, points[0]);
  c1 = is_left() ? kx :
    -2 * kx;
    c2 = is_left() ? kx : -kx;
    curve1 = bezier_curve(
        [ start, [ start.x + c1, start.y ], [ start.x + c1, mid.y ], mid ],
        endpoint = false);
    curve2 = bezier_curve(
        [ mid, [ end.x - c2, mid.y ], [ end.x - c2, end.y ], end ]);
    curve = concat(curve1, curve2);

    center = center(key_points());
    joined = concat(curve, slice(rounded, 1));
    move(-center) { color("green") linear_extrude(height = 2) polygon(joined); }

    // start = back(d,outwards(d,outermost_top()));
    //
    // mid = back(d, middle_top());
    // end = points[0];
    // c1 = is_left() ? kx :
    //   -2 * kx;
    //   c2 = is_left() ? kx : -kx;
    //   curve1 = bezier_curve(
    //       [ start, [ start.x + c1, start.y ], [ start.x + c1, mid.y ], mid ],
    //       endpoint = false);
    //   curve2 =
    //       bezier_curve([ mid, [ end.x - c2, mid.y ], [ end.x - c2, end.y ],
    //       end ],
    //                    endpoint = false);
    //
    //   center = center(key_points());
    //   path = move(-center, concat(points, [start]));
    //   rounded_path = round_corners(path, k = rounding_k, joint =
    //   rounding_joint,
    //                                method = "smooth");
    //   color("green") polygon(rounded_path);
  }

  module base2dold() {
    d = 7 / 8 * kx;
    points = [
      back(d, inwards(d, inner_top())),
      fwd(d + kx / 4, inwards(d, inner_thumb())),
      fwd(d, outwards(d, outer_bottom_corner())),
    ];
    start = back(d, outwards(d, outermost_top()));

    mid = back(d, middle_top());
    end = points[0];
    c1 = is_left() ? kx : -2 * kx;
    c2 = is_left() ? kx : -kx;
    curve1 = bezier_curve(
        [ start, [ start.x + c1, start.y ], [ start.x + c1, mid.y ], mid ],
        endpoint = false);
    curve2 =
        bezier_curve([ mid, [ end.x - c2, mid.y ], [ end.x - c2, end.y ], end ],
                     endpoint = false);

    center = center(key_points());
    path = move(-center, concat(points, [start]));
    rounded_path = round_corners(path, k = rounding_k, joint = rounding_joint,
                                 method = "smooth");
    color("green") polygon(rounded_path);
  }

  // module left_case() {
  //    translate([ -pcb_offset_x, -pcb_offset_y, 0 ]) {
  //      for (key = top_row_left) {
  //        translate([ key.x, key.y, 0 ]) square(kx, ky);
  //      }
  //
  //
  //
  //       top_corners = function(point) [[point.x - (kx / 2), point.y + ky /
  //       2],
  //                                 [point.x + (kx / 2), point.y + ky / 2]];

  //   corners = flatten(map(top_corners, top_row_left));
  //   for (corner = corners) {
  //     translate([ corner.x, corner.y, 0 ]) color("red") sphere(1);
  //   }

  // pad = 6;
  //  left_corner = function(point)[point.x - kx / 2, point.y + ky / 2 + pad];
  //  right_corner = function(point)[point.x + kx / 2, point.y + ky / 2 +
  //  pad];
  //
  //  top = function(point)[point.x, point.y + ky / 2 + pad];
  //
  //  points = [
  //    top(fingers_pinky_top), top(fingers_ring_top),
  //    top(fingers_middle_top), top(fingers_index_top),
  //    top(fingers_inner_top)
  //  ];
  //  echo(points);
  //  echo(is_vector(points));
  //  echo(is_list(points));
  //  for (point = points) {
  //    translate([ point.x, point.y ]) color("green") sphere(1);
  //  }
  //
  //  color("red") stroke(smooth_path(points, size = 0.4), width = 0.1);

  //   left_corner = function(point)[point.x - kx / 2, point.y + ky / 2];
  //   right_corner = function(point)[point.x + kx / 2, point.y + ky / 2];
  //   top = function(point)[point.x, point.y + ky / 2];
  //
  //   start = left_corner(fingers_pinky_top);
  //   mid = top(fingers_middle_top);
  //   end = right_corner(fingers_inner_top);
  //   curve1 = bezier_curve(
  //       [ start, [ start.x + kx / 2, start.y ], [ start.x + kx, mid.y ], mid
  //       ], endpoint = false);
  //   curve2 =
  //       bezier_curve([ mid, [ end.x - kx, mid.y ], [ end.x - kx, end.y ], end
  //       ], endpoint = false);
  //
  //   color("red") stroke(concat(curve1, curve2));
  // }

  module layout(points, center) {
    translate(-(center ? center : center(points))) move_copies(points)
        children();
  }

  module fillet(size) {
    $fn = 32;
    offset(r = size) offset(delta = -size) offset(r = -size)
        offset(delta = size) children();
  }

  module plate() {
    color("grey") linear_extrude(height = plate_thickness) {
      p = plate_padding;
      difference() {
        fillet(1) {
          layout(key_points())
              square([ kx + 2 * p, ky + 2 * p ], center = true);
          layout([midpoint(thumb_row())], center(key_points()))
              square([ 2 * kx + 2 * p, 1.5 * kx + 2 * p ], center = true);
          layout([index_bottom()], center(key_points()))
              square([ kx + 2 * p, 1.5 * kx + 2 * p ], center = true);
          gasket_tabs();
        }
        plate_holes();
      }
    }
    down(plate_gap + pcb_thickness) fwd(pcb_offset_y) pcb();
  }

  module plate_holes() { layout(key_points()) square(14, 14); }

  module gasket_tab(width = kx + 4, height = 4) {
    square([ width, height ], center = true);
  }

  module gasket_tabs() { layout_gaskets() gasket_tab(); }

  module gasket() {
    $fn = 32;
    r = gasket_width / 2;
    color("blue") linear_extrude(gasket_thickness) {
      hull() {
        left(gasket_length / 2 - r) circle(r);
        right(gasket_length / 2 - r) circle(r);
      }
    }
  }

  module gaskets() { layout_gaskets(4) gasket(); }

  module layout_gaskets(d = 2) {
    layout([midpoint(thumb_row())], center(key_points())) {
      fwd(.75 * kx + d) children();
      inwards(kx + d) zrot(90) children();
      outwards(kx + d) zrot(90) children();
    }
    layout([midpoint([ inner_top(), inner_bottom() ])], center(key_points())) {
      inwards(kx / 2 + d) zrot(90) children();
    }
    layout([midpoint([ outermost_top(), outermost_bottom() ])],
           center(key_points())) {
      outwards(kx / 2 + d) zrot(90) children();
    }
    layout([middle_top()], center(key_points())) {
      back(kx / 2 + d) children();
    }
  }

  module layout_holes() {
    echo(outer_bottom_corner());
    layout([outer_bottom_corner()], center(key_points())) outwards(kx / 2 + 4)
        fwd(kx / 2 + 4) circle(3.1);
    layout([inner_thumb()], center(key_points())) inwards(0.5 * kx + 4)
        fwd(0.75 * kx + 4) circle(3.1);
    layout([outer_thumb()], center(key_points())) outwards(0.5 * kx + 4)
        fwd(0.75 * kx + 4) circle(3.1);
    layout([outermost_top()], center(key_points())) outwards(0.5 * kx + 4)
        back(0.5 * kx + 4) circle(3.1);
    layout([inner_top()], center(key_points())) inwards(0.5 * kx + 4)
        back(0.5 * kx + 4) circle(3.1);
    layout([ ring_top(), index_top() ], center(key_points())) back(0.5 * kx + 6)
        circle(3.1);
  }

  module pcb() {
    import(str($side, "_pcb.stl"));
    translate([ 0, pcb_offset_y, keycap_height ]) keycaps();
  }

  module daughterboard() { import(str("daughterboard_", $side, "_pcb.stl")); }

  module keycaps() {
    center = center(key_points());
    layout(top_row(), center) top_row_keycap();
    layout(bottom_row(), center) bottom_row_keycap();
    if ($side == "left") {
      layout([thumb_row()[0]], center) thumb_row_keycap_left();
      layout([thumb_row()[1]], center) thumb_row_keycap_right();

    } else {
      layout([thumb_row()[0]], center) thumb_row_keycap_right();
      layout([thumb_row()[1]], center) thumb_row_keycap_left();
    }
  }

  module bottom_row_keycap() {
    render() import("chicagoSteno/r2r4-topbottom-rows.stl");
  }

  module top_row_keycap() {
    render() rotate(180, [ 0, 0, 1 ]) bottom_row_keycap();
  }

  module thumb_row_keycap_right() {
    render() import("chicagoSteno/cs_t_15_r.stl");
  }
  module thumb_row_keycap_left() {
    render() import("chicagoSteno/cs_t_15_l.stl");
  }

  module inwards(x) {
    if ($side == "left") {
      right(x) children();
    } else {
      left(x) children();
    }
  }

  module outwards(x) {
    if ($side == "left") {
      left(x) children();
    } else {
      right(x) children();
    }
  }

  // clang-format off
function move_center_to_origin(points) =
  let( center = center(points))
  move(-center, points);


function center(points) = 
  let(
    bounds = pointlist_bounds(points),
    min = bounds[0],
    max = bounds[1]
  )
  [ min.x + (max.x - min.x) / 2, min.y + (max.y - min.y) / 2 ];

function midpoint(ps) = mean(ps); 

function is_left() =  let (side = $side) side=="left";

function key_points() = is_left() ? left_key_points : right_key_points ;
function thumb_row() = is_left() ? thumb_row_left : thumb_row_right ;
function top_row() = is_left() ? top_row_left : top_row_right ;
function bottom_row() = is_left() ? bottom_row_left : bottom_row_right ;
function index_bottom() = is_left() ? fingers_index_bottom : mirror_fingers_index_bottom;
function inner_top() = is_left() ? fingers_inner_top : mirror_fingers_inner_top;
function inner_bottom() = is_left() ? fingers_inner_bottom : mirror_fingers_inner_bottom;
function index_top() = is_left() ? fingers_index_top : mirror_fingers_index_top;
function ring_top() = is_left() ? fingers_ring_top : mirror_fingers_ring_top;
function outermost_top() = is_left() ? fingers_pinky_top : mirror_fingers_ext_top;
function outermost_bottom() = is_left() ? fingers_pinky_bottom : mirror_fingers_ext_bottom;
function middle_top() = is_left() ? fingers_middle_top : mirror_fingers_middle_top;
function middle_bottom() = is_left() ? fingers_middle_bottom : mirror_fingers_middle_bottom;
function outer_bottom_corner() = [outermost_bottom().x, inner_thumb().y - kx/4]; 
function inner_thumb() = is_left() ? thumbs_inner_thumb : mirror_thumbs_inner_thumb; 
function outer_thumb() = is_left() ? thumbs_outer_thumb : mirror_thumbs_outer_thumb; 
function outwards(x,p) = is_left() ? left(x,p) : right(x,p);
function inwards(x,p) = is_left() ? right(x,p) : left(x,p);
