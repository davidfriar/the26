// clang-format off
include<BOSL2/std.scad>;
include <BOSL2/fnliterals.scad>;
include <BOSL2/rounding.scad>;
include <BOSL2/geometry.scad>;
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

shelf_width = kx / 8;

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
ceiling_height = top_gasket_height + gasket_thickness;

daughterboard_height = 3;
daughterboard_thickness = 4.8;
daughterboard_length = 33.5;
daughterboard_width = 18;
// daughterboard_mount_length =
//     daughterboard_length - insert_hole_mount_diameter / 2;

daughterboard_mount_length = daughterboard_length;
daughterboard_mount_hole_y_offset =
    daughterboard_width / 2 + insert_hole_mount_diameter / 2 - 0.25;

usb_hole_radius = 1.6;
usb_hole_width = 9;
usb_hole_clearance = 0.25;

battery_size = [ 17.5, 30.5, 7 ];

all();
// daughterboard_holder();

// color("red") intersection() {
//   case_lid();
//   daughterboard();
// }

logo();
//  daughterboard();

// color("red") intersection() {
//   case_lid();
//   move(daughterboard_position()) up(daughterboard_height)
//   daughterboard_hole();
// }

module logo() { linear_extrude(height = 1) import("../art/the26small.svg"); }

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
  *up(plate_height)plate();
  *up(plate_height - (plate_gap + pcb_thickness)) pcb();
  *up(top_gasket_height) gaskets(); 
  case_lid();
  daughterboard();
  battery();
  color("slategrey") daughterboard_holder();
}


module case_lid() {
  difference(){
    union(){
      difference(){
        case_lid_outside();
        bottom_of_inside();
        main_hole();
        gasket_cutouts();
        plate_cutout();
        keys_hole();
        //TODO: check that gasket cutouts don't come too close to the outside
      } 
      up(base_thickness) insert_hole_mounts();
      intersection(){
        daughterboard_mount();
        case_lid_outside();
      }
    }
    up(base_thickness-infinitesmal) insert_holes();
    daughterboard_cutout();
    usb_hole();
    battery_hole();

    //TODO: check that insert holes are deep enough 
  }
}

module bottom_of_inside(){
        half_of(v = DOWN, cp = -base_thickness, s = 300) case_lid_inside();
}

module main_hole(){
  main_hole= offset(r=-(case_thickness + shelf_width), basic_shape());
  linear_extrude(height=ceiling_height) polygon(main_hole);
}


module case_lid_inside(case_thickness=2){
 inside = offset(r=-case_thickness, basic_shape());
 down(infinitesmal) offset_sweep(slice(inside,1), height = case_height - case_thickness + infinitesmal,  top=os_smooth(joint = kx * 3/8), steps=16, offset="delta" );
}

module case_lid_outside(){
  offset_sweep(slice(basic_shape(),1), height = case_height, bottom = os_smooth(joint = kx/8), top=os_smooth(joint = kx * 3/8), steps=16, offset="delta" );
}

module daughterboard_mount(){
  mount_width = 
     daughterboard_width + (is_left() ? kx * 5/8 : kx / 2);
    height = 5;
    shift = is_left() ? 1 : 1.5;
    move([
      daughterboard_position().x, daughterboard_position().y, ceiling_height -
      height
    ]) linear_extrude(height = height) fwd(shift)
        outwards(insert_hole_mount_diameter / 4)
            rect([ daughterboard_mount_length, mount_width ], rounding = 1);
  }

  module daughterboard_cutout() {
    cutout_length = daughterboard_mount_length + infinitesmal;
    cutout_width = daughterboard_width + 0.5;
    move(daughterboard_position()) {
      cube([ cutout_length, cutout_width, daughterboard_thickness ],
           anchor = BOTTOM);
      up(daughterboard_thickness) ycopies(daughterboard_width - 2.5)
          xcyl(l = cutout_length, r = 1.25, rounding = 1.25);
    }
  }

  module daughterboard_holder(with_holes = true) {
    pcb_pitch = 2.54;
    width = daughterboard_width + kx * 5 / 8;
    cutout_width = daughterboard_width + 0.5;
    length = 4 * pcb_pitch;
    height = 4.5;
    cutout_height = 3;
    sidebar_width = 8.5;
    sidebar_length =
        daughterboard_length / 2 - daughterboard_mount_hole_x_offset_bottom();
    sidebar_y_offset =
        is_left() ? (width - sidebar_width) / 2 : -(width - sidebar_width) / 2;

    inwards(daughterboard_mount_hole_x_offset_bottom())
        move([ daughterboard_position().x, daughterboard_position().y, 1.5 ])
            xrot(180) down(height) difference() {
      union() {
        cuboid([ length, width, height ], rounding = 1, except = BOTTOM,
               anchor = BOTTOM);
        inwards(sidebar_length / 2 + 1) back(sidebar_y_offset)
            cuboid([ sidebar_length, sidebar_width, height ], rounding = 1,
                   except = BOTTOM, anchor = BOTTOM);
      }
      down(infinitesmal) outwards(daughterboard_mount_hole_x_offset_bottom())
          cuboid(
              [
                daughterboard_length, cutout_width, cutout_height + infinitesmal
              ],
              anchor = BOTTOM);
      if (with_holes) {
        up(3 - infinitesmal) ycopies(daughterboard_width - 2.8)
            xcopies(pcb_pitch, 8)
                cylinder(r1 = 1, r2 = 0.75, h = 1, anchor = BOTTOM);

        back(daughterboard_mount_hole_y_offset) daughterboard_holder_hole();

        fwd(daughterboard_mount_hole_y_offset)
            inwards(daughterboard_mount_hole_x_offset_top() -
                    daughterboard_mount_hole_x_offset_bottom())
                daughterboard_holder_hole();
      }
    }
  }

  module daughterboard_holder_hole() {
    hole_diameter = base_hole_diameter;
    countersink_diameter = base_hole_countersink_diameter;
    down(infinitesmal) hull() xcopies(2)
        cylinder(d = hole_diameter, anchor = BOTTOM, h = 10);
    up(1.5) hull() xcopies(2)
        cylinder(d = countersink_diameter, anchor = BOTTOM, h = 10);
  }

  module usb_hole() {
    outwards(daughterboard_length / 2) up(3.2) move(daughterboard_position()) {
      radius = usb_hole_radius;
      width = usb_hole_width;
      clearance = usb_hole_clearance;
      c1 = left(width / 2 - radius, circle(r = radius + clearance));
      c2 = right(width / 2 - radius, circle(r = radius + clearance));
      points = concat(c1, c2);
      hull = hull(points);
      path = [for (i = hull) points[i]];
      zrot(is_left() ? 0 : 180) right(infinitesmal) zrot(-90) xrot(90)
          offset_sweep(path = path, height = 2 + infinitesmal * 2,
                       top = os_circle(r = -0.5), steps = 8);
    }
  }

  module keys_hole() {
    linear_extrude(height = case_height + 5) {
      fillet(1) {
        layout(finger_rows(), center(key_points())) {
          square([ kx + 2, ky + 2 ], center = true);
        }
        layout(thumb_row(), center(key_points())) {
          square([ ky + 2, 1.5 * kx + 2 ], center = true);
        }
      }
    }
  }

  module gasket_cutouts() {
    for (g = gaskets(3.75)) {
      move(g[0]) rot(g[1]) gasket_cutout(g[2]);
    }
  }

  module gasket_cutout(length) {
    r = gasket_width / 2;
    linear_extrude(top_gasket_height + gasket_thickness) {
      hull() {
        left(length / 2 - r) circle(r);
        right(length / 2 - r) circle(r);
      }
    }
  }

  module plate_cutout() {
    linear_extrude(height = top_gasket_height + gasket_thickness) offset(r = 1)
        projection() plate();
  }

  module insert_hole_mounts() { layout_holes() insert_hole_mount(); }

  module insert_holes() { layout_holes() insert_hole(); }

  module insert_hole_mount() {
    cylinder(h = 6, d = insert_hole_mount_diameter);
  }

  module insert_hole() {
    cylinder(h = insert_hole_depth, d = insert_hole_diameter);
  }

  module case_base() {
    color("darkslategrey") {
      difference() {
        linear_extrude(height = base_thickness) {
          offset(r = -kx / 8) polygon(basic_shape());
        }
        up(case_thickness) base_pcb_hole();
        base_holes();
        base_countersink_holes();
        daughterboard_hole();
        battery_hole();
        up(infinitesmal) daughterboard_holder(with_holes = false);
      }
    }
  }

  module pcb_hole_2d() {
    fillet(2) offset(r = 2) fwd(pcb_offset_y) translate(-pcb_center())
        import(pcb_svg());
  }

  module base_pcb_hole() { linear_extrude(height = 10) pcb_hole_2d(); }

  module base_holes() {
    layout_holes(base = true) {
      down(1) cylinder(h = 10, d = base_hole_diameter);
    }
  }

  module base_countersink_holes() {
    layout_holes(base = true) {
      down(1) cylinder(h = base_hole_countersink_depth + 1,
                       d = base_hole_countersink_diameter);
    }
  }

  module daughterboard_hole() { // TODO: may need changing because daughterboard
                                // position includes z
    move(daughterboard_position()) cuboid(
        [
          daughterboard_length + 0.5 + infinitesmal, daughterboard_width + 1,
          daughterboard_thickness + 2
        ],
        anchor = BOTTOM, rounding = 0);
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

  module layout_holes(base = false) {

    layout([outer_bottom_corner()], center(key_points())) outwards(kx / 2 + 3)
        fwd(kx / 2 + 3) children();
    layout([outer_thumb()], center(key_points())) outwards(0.5 * kx + 3.25)
        fwd(0.75 * kx + 3.5) children();
    layout([outermost_top()], center(key_points())) outwards(0)
        back(0.5 * kx + (is_left() ? 6 : 8)) children();
    layout([index_top()], center(key_points())) outwards(1) back(0.5 * kx + 6)
        children();
    layout([inner_thumb()], center(key_points())) inwards(kx / 2 + 3.25)
        fwd(kx * 3 / 4 + 3.25) children();
    layout([inner_top()], center(key_points())) inwards(kx / 2 + 3)
        back(kx / 2 + 3) children();
    if (!base) {
      move([ daughterboard_position().x, daughterboard_position().y ]) {
        inwards(daughterboard_mount_hole_x_offset_bottom())
            fwd(daughterboard_mount_hole_y_offset) children();
        inwards(daughterboard_mount_hole_x_offset_top())
            back(daughterboard_mount_hole_y_offset) children();
      }
    }
  }

  module pcb() {
    fwd(pcb_offset_y) import(pcb_stl());
    *up(keycap_height) keycaps();
  }

  module daughterboard() {
    move(daughterboard_position()) {
      rotation = is_left() ? 0 : 180;
      rot(rotation) left(0.5) import("pcbs/daughterboard_pcb.stl");
    }
  }

  module battery() {
    color("red") outwards(kx * 3 / 8) fwd(kx * 2 / 8)
        layout([[middle_bottom().x, outer_thumb().y]], center(key_points()))
            up(6) cuboid(battery_size, rounding = 1, anchor = BOTTOM);
  }

  module battery_hole() {
    position = fwd(kx - kx / 8, outwards(kx * 7 / 8, [
                     outer_thumb().x, outer_bottom_corner().y - infinitesmal
                   ]));
    length = abs(position.x - outwards(kx, outer_bottom_corner()).x) -
             (daughterboard_length + kx / 8);
    width = battery_size.y + 1;
    height = ceiling_height - daughterboard_height + infinitesmal;

    up(daughterboard_height) layout([position], center(key_points()))
        cuboid([ length, width, height ], rounding = 0,
               anchor = FRONT + BOTTOM + (is_left() ? RIGHT : LEFT));
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

// inwards(1) fwd(kx*3/16) layout([[outermost_bottom().x, outer_thumb().y]], center(key_points()))
function daughterboard_position() = 
  move(-center(key_points()), inwards(0.75, fwd(kx*3/16, [outermost_bottom().x, outer_thumb().y, daughterboard_height])) );


function daughterboard_mount_hole_x_offset_top() = 
  is_left() ? 2.54 * 2.5: 2.54*5.5;

function daughterboard_mount_hole_x_offset_bottom() = 2.54*2.5;

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
