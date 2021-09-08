// https://github.com/chrisspen/gears/blob/master/gears.scad
use <gears.scad>;
use <./module.scad>;

$fs = 0.2;

margin = 0.35;
gearmod = 0.8;
gearmod_v = 1.3;

base_module();
conn_data_x(0, 1, 0, false);
conn_data_x(2, 1, 0, true);
conn_pwr_y(1, 0, 0, false);


// iaxis
translate([0, 12 * 1.5, 12 * 0.5])
cube([8, 3, 3], center=true);

// oaxis
translate([24, 12 * 1.5, 12 * 0.5])
cube([8, 3, 3], center=true);

// paxis
translate([12 + 6, -1, 6])
rotate(90, [1, 0, 0])
cylinder(h=6, d=3, center=true);

// paxis center holder
translate([12 + 3, 12 + 2, 0])
cube([6, 2, 8]);


translate([12 * 1.5, 8, 12 * 0.5])
rotate(90, [0, 0, 1])
power_axis_redir();
  
module power_axis_redir() {
  // input structural axis
  rotate(90, [0, -1, 0])
  cylinder(h=12, d=2.1, center=true);

  // input cage stopper
  translate([3.5, 0, 0])
  rotate(90, [0, -1, 0])
  cylinder(h=1, d=3, center=true);

  // input gear
  translate([-4, 0, 0])
  rotate(90, [0, 1, 0])
  rotate(360 / 4 / 2, [0, 0, 1])
  bevel_gear(gearmod_v, 4, 45, 2, 0, pressure_angle=5);

  // cage
  difference() {
    translate([0, 2, 0])
    cube([10.8, 7.2, 5], center=true);
    
    // space for input axis
    rotate(90, [0, -1, 0])
    cylinder(h=12, d=2.6, center=true);
    
    // space for output axis
    translate([0, 4, 0])
    rotate(90, [-1, 0, 0])
    cylinder(h=10, d=2.6);
    
    // space for gears
    cube([8.5, 8.4, 6], center=true);
  }


  // output axis
  translate([0, 4, 0])
  rotate(90, [-1, 0, 0])
  cylinder(h=12, d=2.1);

  // output cage stopper
  translate([0, 6, 0])
  rotate(90, [-1, 0, 0])
  cylinder(h=1, d=3);

  // output gear
  translate([0, 4, 0])
  rotate(90, [1, 0, 0])
  bevel_gear(gearmod_v, 4, 45, 2, 0, pressure_angle=5);

}

translate([3, 8, 4])
rotate(90, [0, 0, 1])
rotate(90, [1, 0, 0])
rack_cage();

// rack-oaxis
translate([6, 10, 2])
rotate(-27, [0, 0, 1])
cube([3, 12, 1]);

// iaxis-cage
translate([1.5, 16, 2])
rotate(-45, [0, 1, 0])
cube([10, 1, 3]);

module rack_cage() {
  gm = 0.7;
  
  translate([0, -gm * 1.6, 0])
  rack(gm, 9, 1.5, 2, pressure_angle=20, helix_angle=0);

  translate([0, gm * 1.6, 0])
  translate([0, 4, 0])
  scale([1, -1, 1])
  rack(gm, 9, 1.5, 2, pressure_angle=20, helix_angle=0);

  translate([0, 2, 0])
  spur_gear(gm, 5, 2, 0, pressure_angle=20, helix_angle=0, optimized=false);
}
