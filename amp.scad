// https://github.com/chrisspen/gears/blob/master/gears.scad
use <gears.scad>;
use <./module.scad>;

$fs = 0.2;

g = 12;

// module state
st_i = 1.5; // [0, 3]
st_o = 1.5; // [0, 3]

st_ax_s = st_i - 1.5; // [-1.5, 1.5]
st_cage_sh = st_o * 2 - 3; // [-3, 3]


base_module();
conn_data_y(0, 0, 0, false);
conn_data_x(2, 1, 0, true);
conn_pwr_y(1, 0, 0, false);


// i-axis
translate([g * 0.5, 0, g * 0.5])
cube([3, 8, 3], center=true);

// o-axis
translate([24, g * 1.5, g * 0.5])
cube([8, 3, 3], center=true);

// pwr-axis
translate([g * 1.5, -1, 6])
rotate(90, [1, 0, 0])
cylinder(h=6, d=3, center=true);

// pwr-axis stopper
translate([g * 1.5, 1.7, 6])
cube([6, 0.9, 0.9], center=true);

// pwr-axis (internal) center holder
translate([g * 1.5, g + 3.1, 6])
difference() {
  cube([6, 1.2, g], center=true);
  hole_y(d=2.4, t=2, center=true);
}

// pwr-axis (internal) d=2
translate([g + 6, 8, 6])
rotate(90, [1, 0, 0])
cylinder(h=15.3, d=2.1, center=true);

// pwr-axis (internal) stopper
translate([g + 6, 13.7, 6])
cube([4.5, 0.9, 0.9], center=true);



translate([g * 1.5, 8, g * 0.5])
rotate(90, [0, 0, 1])
power_axis_redir();
  
module power_axis_redir() {
  gearmod = 1.5;
  
  // input gear
  translate([-1.5, 0, 0])
  rotate(90, [0, 1, 0])
  rotate(360 / 4 / 2, [0, 0, 1])
  bevel_gear(gearmod, 4, 45, 2, 0, pressure_angle=5);

  // cage
  translate([-0.3 + 3, 0, 0])
  difference() {
    translate([0, 2, 0])
    cube([10.5, 9, 5], center=true);
    
    // space for input axis
    hole_x(d=2.4, t=g, center=true);
    
    // space for output axis
    translate([0.3, 4, 0])
    hole_y(d=2.4, t=10, center=true);
    
    // space for gears
    cube([8.9, 9.8, 6], center=true);
  }

  // output axis
  translate([3, 4, 0])
  rotate(90, [-1, 0, 0])
  cylinder(h=g, d=2.1);

  // output cage stopper
  translate([3, 7.5, 0])
  cube([4.5, 0.9, 0.9], center=true);

  // output gear
  translate([3, 4.5, 0])
  rotate(90, [1, 0, 0])
  bevel_gear(gearmod, 4, 45, 2, 0, pressure_angle=5);

}

// cage
translate([0, st_cage_sh, 0])
translate([3, 11, 4])
rotate(90, [0, 0, 1])
rotate(90, [1, 0, 0])
rack_cage();

// pinion
translate([0, 0, st_ax_s])
translate([3, 11 , 4])
rotate(90, [0, 0, 1])
rotate(90, [1, 0, 0])
pinion();

// rack-oaxis
translate([6, 10, 2])
rotate(-27, [0, 0, 1])
cube([3, g, 1]);

// iaxis -> cage shifter
translate([8, 6, 9])
rotate(90, [0, 0, 1])
rotate(45, [0, 1, 0])
difference() {  
  translate([0, 0.5, 0])
  cube([10, 3, 3]);
  
  translate([0.5, -5, 0.5])
  cube([9, 20, 2]);
}




module rack_cage() {
  gm = 0.7;
  tr = 6;
  
  // 0 rack (bottom)
  translate([-2, -1, 0])
  rack(gm, 6, 1.5, 2, pressure_angle=5, helix_angle=0);

  // 1 rack (top)
  translate([2, 1, 0])
  translate([0, 4, 0])
  scale([1, -1, 1])
  rack(gm, 6, 1.5, 2, pressure_angle=5, helix_angle=0);
  
  // 0 rack rail
  translate([-5.5, 5.75, 0])
  cube([11, 1, 2]);
  
  // 1 rack rail
  translate([-5.5, -2.75, 0])
  cube([11, 1, 2]);
  
  // vertical rod (Y-)
  translate([-5.5, -2.75, -0.8])
  cube([3, 9.5, 0.8]);
  
  // vertical rod (Y+)
  translate([2.5, -2.75, -0.8])
  cube([3, 9.5, 0.8]);
}

module pinion() {
  n = 4;
  pin_w = 1.4;
  pin_t = 2;
  pin_l = 2.1;
  translate([0, 0, 0])
  translate([0, 2, 0])
  for (i = [0:n-1]) {
    rotate(360 * (i + 0.5) / n, [0, 0, 1])
    intersection() {
      rotate(10, [0, 0, 1])
      translate([0, -pin_w / 2, 0])
      cube([pin_l, pin_w, pin_t]);
      
      rotate(-10, [0, 0, 1])
      translate([0, -pin_w / 2, 0])
      cube([pin_l, pin_w, pin_t]);
    }
  }
}

