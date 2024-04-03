// clang-format off
include<BOSL2/std.scad>;
include <BOSL2/fnliterals.scad>;
include <BOSL2/rounding.scad>;
include<keys.scad>;
include<pcbs/left_pcb_dimensions.scad>;
include<pcbs/right_pcb_dimensions.scad>;

// clang-format on
$fn = 32;
$side = "left";
kx = 18;
ky = 17;

infinitesmal = 0.001;
case_height = 13.5;
case_thickness = 2;

rounding_k = 0.5;
rounding_joint = kx * 5 / 8;

base_thickness = 6;

plate_thickness = 1.2;
plate_gap = 1;
plate_padding = 2;
pcb_thickness = 1.6;
keycap_height = 8; // distance from bottom of pcb to bottom of keycaps TODO:
pcb_offset_y = 2.5;
gasket_width = 3.5;
gasket_length = 1.5 * kx;
gasket_thickness = 1.9; // gasket thickness when compressed
gasket_tab_width = 4;

insert_hole_diameter = 3.2;
insert_hole_depth = 4.25;
insert_hole_mount_diameter = insert_hole_diameter + 3;
insert_hole_mount_plate_clearance_diameter = insert_hole_mount_diameter + 1;
base_hole_diameter = 2.4;
base_hole_countersink_diameter = 4;
base_hole_countersink_depth = 2;

bottom_gasket_height = base_thickness;
plate_height = bottom_gasket_height + gasket_thickness;
top_gasket_height = plate_height + plate_thickness;

// all();

module all() {
  left(100) left_case();
  right(100) right_case();
}

module left_case() {
  $side = "left";
  case();
}

module right_case() {
  $side = "right";
  case();
}

module case(){
  *case_base();
  *up(bottom_gasket_height) gaskets(); 
  up(plate_height)plate();
  up(plate_height - (plate_gap + pcb_thickness)) pcb();
  up(top_gasket_height) gaskets(); 
  case_lid();
}


module case_lid() {
  difference() {
    union() {
      difference() {
        up(infinitesmal) case_lid_outside();
        half_of(v = DOWN, cp = -base_thickness, s = 300) case_lid_inside();
        keys_holes();
        intersection() {
          case_lid_inside(case_thickness = 1.5);
          linear_extrude(top_gasket_height + gasket_thickness) {
            intersection() {
              fillet(1) offset(r = gasket_width) pcb_hole_2d();
              offset(r = -3) polygon(basic_shape());
            }
          }
        }
      }
      up(base_thickness) insert_hole_mounts();
    }
    down(infinitesmal) up(base_thickness) insert_holes();
  }
}

module case_lid_inside(case_thickness=2){
 inside = offset(r=-case_thickness, basic_shape());
 down(infinitesmal) offset_sweep(slice(inside,1), height = case_height - case_thickness + infinitesmal,  top=os_smooth(joint = kx * 3/8), steps=16, offset="delta" );
}

module case_lid_outside(){
  offset_sweep(slice(basic_shape(),1), height = case_height, bottom = os_smooth(joint = kx/8), top=os_smooth(joint = kx * 3/8), steps=16, offset="delta" );
}

module keys_holes(){
  linear_extrude(height = case_height+5){
    fillet(1){
      layout(finger_rows(), center(key_points())){
        square([ kx + 2 , ky + 2 ], center = true);
      }
      layout(thumb_row(), center(key_points())){
         square([ ky + 2 , 1.5*kx + 2 ], center = true);
      }
    }
  }
}

module insert_hole_mounts(){
  layout_holes() insert_hole_mount();
}


module insert_holes(){
  layout_holes() insert_hole();
}

module insert_hole_mount(){
   cylinder(h=6, d = insert_hole_mount_diameter );
}

module insert_hole(){
   cylinder(h=insert_hole_depth, d=insert_hole_diameter);
}

module case_base(){
  color("darkslategrey"){
    difference(){
      linear_extrude(height = base_thickness){
        offset(r = -kx/8) polygon(basic_shape());
      }
      up(case_thickness) base_pcb_hole();
      base_holes();
      base_countersink_holes();
    } 
  }
  
  inwards(1) fwd(kx*3/16) layout([[outermost_bottom().x, outer_thumb().y]], center(key_points())) up(6) daughterboard();
  outwards(kx*3/8) fwd(kx*1/4) layout([[middle_bottom().x, outer_thumb().y]], center(key_points())) up(6) battery();
}

module pcb_hole_2d(){
  fillet(2) offset(r=2) fwd(pcb_offset_y) translate(-pcb_center())import(pcb_svg());
}

module base_pcb_hole() {
  linear_extrude(height=10) pcb_hole_2d();
}

module base_holes(){
  layout_holes(){
    down(1) cylinder(h = 10, d = base_hole_diameter);
  }
}

module base_countersink_holes(){
  layout_holes(){
    down(1) cylinder(h = base_hole_countersink_depth + 1, d = base_hole_countersink_diameter);
  }
}

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
          difference() {
            union() {
              layout(key_points())
                  square([ kx + 2 * p, ky + 2 * p ], center = true);
              layout([midpoint(thumb_row())], center(key_points()))
                  square([ 2 * kx + 2 * p, 1.5 * kx + 2 * p ], center = true);
              layout([index_bottom()], center(key_points()))
                  square([ kx + 2 * p, 1.5 * kx + 2 * p ], center = true);
              gasket_tabs();
            }
            insert_mount_clearance();
          }
        }
        plate_holes();
      }
    }
  }

  module insert_mount_clearance() {
    // layout_holes() circle(d = insert_hole_mount_plate_clearance_diameter);
    // layout_holes() fillet(1) square(
    //     [
    //       insert_hole_mount_plate_clearance_diameter,
    //       insert_hole_mount_plate_clearance_diameter
    //     ],
    //     center = true);
    layout([inner_thumb()], center(key_points())) inwards(kx / 2 + 3.25)
        fwd(kx * 3 / 4 + 3.25) rot(45)
            square(insert_hole_mount_plate_clearance_diameter, center = true);
    ;
    layout([inner_top()], center(key_points())) inwards(kx / 2 + 3)
        back(kx / 2 + 3) rot(45)
            square(insert_hole_mount_plate_clearance_diameter, center = true);
    layout([outer_thumb()], center(key_points())) outwards(0.5 * kx + 3.25)
        fwd(0.75 * kx + 3.5) rot(45)
            square(insert_hole_mount_plate_clearance_diameter, center = true);
  }

  module plate_holes() { layout(key_points()) square(14, 14); }

  // module gasket_tab(width = kx + 4, height = 4) {
  //   square([ width, height ], center = true);
  // }
  //
  // module gasket_tabs() { layout_gaskets() gasket_tab(); }
  //
  // module gasket() {
  //   $fn = 32;
  //   r = gasket_width / 2;
  //   color("blue") linear_extrude(gasket_thickness) {
  //     hull() {
  //       left(gasket_length / 2 - r) circle(r);
  //       right(gasket_length / 2 - r) circle(r);
  //     }
  //   }
  // }
  //
  // module gaskets() { layout_gaskets(3.75) gasket(); }
  //
  // module layout_gaskets(d = 2) {
  //   layout([midpoint(thumb_row())], center(key_points())) {
  //     fwd(.75 * kx + d) children();
  //     back(kx / 8) inwards(kx + d) zrot(90) children();
  //     back(kx / 8) outwards(kx + d) zrot(90) children();
  //   }
  //   layout([midpoint([ inner_top(), inner_bottom() ])], center(key_points()))
  //   {
  //     inwards(kx / 2 + d) back(2) zrot(90) children();
  //   }
  //   layout([midpoint([ outermost_top(), outermost_bottom() ])],
  //          center(key_points())) {
  //     outwards(kx / 2 + d) zrot(90) children();
  //   }
  //   layout([middle_top()], center(key_points())) {
  //     back(kx / 2 + d - 0.25) children();
  //   }
  // }

  module gaskets() {
    for (g = gaskets(3.75)) {
      move(g[0]) rot(g[1]) gasket(g[2]);
    }
  }

  module gasket(length) {
    r = gasket_width / 2;
    color("purple") linear_extrude(gasket_thickness) {
      hull() {
        left(length / 2 - r) circle(r);
        right(length / 2 - r) circle(r);
      }
    }
  }

  module gasket_tabs() {
    for (g = gaskets(2)) {
      move(g[0]) rot(g[1]) gasket_tab(g[2] - 4);
    }
  }

  module gasket_tab(length, width = gasket_tab_width) {
    square([ length, width ], center = true);
  }

  module layout_holes() {
    layout([outer_bottom_corner()], center(key_points())) outwards(kx / 2 + 3)
        fwd(kx / 2 + 3) children();
    // layout([inner_thumb()], center(key_points())) inwards(0.5 * kx + 3)
    //     fwd(0.75 * kx + 3) children();
    layout([outer_thumb()], center(key_points())) outwards(0.5 * kx + 3.25)
        fwd(0.75 * kx + 3.5) children();
    layout([outermost_top()], center(key_points())) outwards(0)
        back(0.5 * kx + 6) children();
    // layout([inner_top()], center(key_points())) inwards(0.5 * kx + 3)
    //     back(0.5 * kx + 3) children();
    layout([index_top()], center(key_points())) outwards(1) back(0.5 * kx + 6)
        children();
    layout([outermost_bottom()], center(key_points())) outwards(kx / 2 + 3.5)
        fwd(kx / 2 + 5) children();
    layout([inner_thumb()], center(key_points())) inwards(kx / 2 + 3.25)
        fwd(kx * 3 / 4 + 3.25) children();
    layout([inner_top()], center(key_points())) inwards(kx / 2 + 3)
        back(kx / 2 + 3) children();
  }

  module pcb() {
    fwd(pcb_offset_y) import(pcb_stl());
    up(keycap_height) keycaps();
  }

  module daughterboard() {
    rotation = is_left() ? 0 : 180;
    rot(rotation) import("pcbs/daughterboard_pcb.stl");
  }

  module battery() {
    color("red") cuboid([ 17.5, 30.5, 7 ], rounding = 1, anchor = BOTTOM);
  }

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

function key_points() = is_left() ? left_key_points : right_key_points;
function thumb_row() = is_left() ? thumb_row_left : thumb_row_right;
function top_row() = is_left() ? top_row_left : top_row_right;
function bottom_row() = is_left() ? bottom_row_left : bottom_row_right;
function finger_rows() = concat(top_row(), bottom_row());
function index_bottom() = is_left() ? fingers_index_bottom : mirror_fingers_index_bottom;
function inner_top() = is_left() ? fingers_inner_top : mirror_fingers_inner_top;
function inner_bottom() = is_left() ? fingers_inner_bottom : mirror_fingers_inner_bottom;
function index_top() = is_left() ? fingers_index_top : mirror_fingers_index_top;
function ring_top() = is_left() ? fingers_ring_top : mirror_fingers_ring_top;
function pinky_top() = is_left() ? fingers_pinky_top : mirror_fingers_pinky_top;
function outermost_top() = is_left() ? fingers_pinky_top : mirror_fingers_ext_top;
function outermost_bottom() = is_left() ? fingers_pinky_bottom : mirror_fingers_ext_bottom;
function middle_top() = is_left() ? fingers_middle_top : mirror_fingers_middle_top;
function middle_bottom() = is_left() ? fingers_middle_bottom : mirror_fingers_middle_bottom;
function outer_bottom_corner() = [outermost_bottom().x, inner_thumb().y - kx/4];
function inner_thumb() = is_left() ? thumbs_inner_thumb : mirror_thumbs_inner_thumb;
function outer_thumb() = is_left() ? thumbs_outer_thumb : mirror_thumbs_outer_thumb;
function outwards(x,p) = is_left() ? left(x,p) : right(x,p);
function inwards(x,p) = is_left() ? right(x,p) : left(x,p);

function pcb_size() = is_left() ? left_pcb_size : right_pcb_size;
function pcb_center() = 
   let(size = pcb_size())
   [size.x/2, size.y/2];
function pcb_svg() = is_left()? "pcbs/left_pcb.svg" : "pcbs/right_pcb.svg";
function pcb_stl() = is_left()? "pcbs/left_pcb.stl" : "pcbs/right_pcb.stl";

function corner_points() =  [
    back(kx,inwards(kx,inner_top())), 
    fwd(1.25 * kx,inwards(kx,inner_thumb())), 
    fwd(kx,outwards(kx,outer_bottom_corner())), 
    back(kx*9/8,outwards(kx,[outermost_top().x, pinky_top().y])),
  ];



trans = function(g)  [move(-center(key_points()), g[0]), g[1], g[2]];

function gaskets(gasket_offset) =
let (
  d = gasket_offset,
  gaskets = [
    [fwd(0.75*kx + d, midpoint(thumb_row())), 0, gasket_length ],
    [outwards(kx+d ,back(kx/8, midpoint(thumb_row()))), 90, gasket_length ],
    [inwards(kx+d ,back(kx/8, midpoint(thumb_row()))), 90, gasket_length ],
    [inwards(kx/2+d ,back(2, midpoint([inner_top(), inner_bottom()]))), 90, gasket_length ],
    [outwards(kx/2+d , midpoint([outermost_top(), outermost_bottom()])), 90, gasket_length ],
    [back(kx/2+d - 0.25, middle_top()), 0, gasket_length/2 ],
  ]
)
map(trans, gaskets);




function basic_shape() = 
  let (
    j = rounding_joint,
    start =  inwards(j, last(corner_points())),
    mid = back(kx, middle_top()),
    end = outwards(j, corner_points()[0]),
    
    rounded = round_corners(concat([end], corner_points(), [start]), k = rounding_k, joint = j-0.00001, method = "smooth", closed = false),
    
    controls = is_left() ? 
      [[start.x + kx,start.y], [start.x + kx, mid.y], [end.x - kx, mid.y], [end.x - kx, end.y]  ] :
      [[start.x - 2 * kx, start.y], [start.x - 2 * kx, mid.y],
       [end.x + kx, mid.y], [end.x + kx, end.y]],

      curve1 = bezier_curve([ start, controls[0], controls[1], mid ],
                            endpoint = false),
      curve2 = bezier_curve([ mid, controls[2], controls[3], end ]),
      path = concat(curve1, curve2, slice(rounded, 1)),

      center = center(key_points())
  )
  move(-center, is_left() ? path : reverse(path));
