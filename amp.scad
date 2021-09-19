// https://github.com/chrisspen/gears/blob/master/gears.scad
use <gears.scad>;
use <./module.scad>;

$fs = 0.2;

g = 12;

// module state
st_i = 1.5; // [0, 3]
st_o = 1.5; // [0, 3]
st_p = 0; // [0, 360]

st_ax_s = st_i - 1.5; // [-1.5, 1.5]
st_redir_angle = st_ax_s / 25 * (360 / (2 * PI));
st_cage_sh = st_o * 2 - 3; // [-3, 3]


////////////////////////////////////////////////////////////////////////////////
// Module surface
base_module();
conn_data_y(0, 0, 0, false);
conn_data_x(2, 1, 0, true);
conn_pwr_y(1, 0, 0, false);

// i-shaft
translate([g * 0.5, st_i, g * 0.5])
translate([-1.5, 0, -1.5])
union() {
  len_ext = 4;
  len_int = 6;
  
  // external
  translate([0, -len_ext, 0])
  cube([3, len_ext, 3]);
  
  // internal
  cube([3, len_int, 3]);
}


// o-shaft
translate([g * 2 + st_o, g * 1.5, g * 0.5])
translate([0, -1.5, -1.5])
union() {
  len_ext = 1;
  len_int = 22;
  
  // external
  cube([len_ext, 3, 3]);
  
  // internal
  translate([-len_int, 0, 0])
  cube([len_int, 3, 3]);
}


// p-shaft
translate([g * 1.5, 0, g / 2])
rotate(90, [1, 0, 0])
union() {
  len_ext = 6;
  len_int = 1.8;
  
  // external
  cylinder(d=3, h=len_ext);
  
  // internal
  translate([0, 0, -len_int])
  cylinder(d=3, h=len_int);
}


////////////////////////////////////////////////////////////////////////////////
// Module Internal

// floor
cube([g * 2, g * 2, 1.2]);



// p-shaft
translate([g * 1.5, 0, g * 0.5])
rotate(st_p, [0, 1, 0])
union() {  
  // p-shaft stopper
  translate([0, 1.7, 0])
  cube([6, 0.9, 0.9], center=true);

  // p-shaft (internal) d=2
  translate([0, 8, 0])
  rotate(90, [1, 0, 0])
  cylinder(h=15.3, d=2.1, center=true);

  translate([0, 8, 0])
  rotate(90, [0, 0, 1])  
  p_shaft_redir();
}

// p-shaft (internal) center holder
translate([g * 1.5, g + 3.1, 6])
difference() {
  cube([6, 1.2, g], center=true);
  hole_y(d=2.4, t=2, center=true);
}

// p-shaft (internal) stopper
translate([g + 6, 16, 6])
cube([4.5, 0.9, 0.9], center=true);


translate([g * 1.5, 8, g * 0.5])
rotate(90, [0, 0, 1])
union() {
  rotate(st_redir_angle, [1, 0, 0])
  p_shaft_redir_rotor();
}


module p_shaft_redir() {
  gearmod = 1.5;
  
  // input gear
  translate([-1.5, 0, 0])
  rotate(90, [0, 1, 0])
  rotate(360 / 4 / 2, [0, 0, 1])
  bevel_gear(gearmod, 4, 45, 2, 0, pressure_angle=5);
}

module p_shaft_redir_rotor() {
  gearmod = 1.5;

  // redir-frame
  difference() {
    union() {
      translate([-0.1, 5.8, 0])
      cube([11, 2, 5], center=true);
      
      translate([-3.7, 1, 0])
      cube([3.8, 8, 5], center=true);
    }
    
    // space for input shaft
    hole_x(d=2.4, t=g, center=true);
    
    // space for output shaft
    translate([3, 4, 0])
    hole_y(d=2.4, t=10, center=true);
  }

  // cage-shaft
  translate([3, 0, 0])
  rotate(st_p - st_redir_angle, [0, 1, 0])
  union() {
    // shaft
    translate([0, 4, 0])
    rotate(90, [-1, 0, 0])
    cylinder(h=13.5, d=2.1);

    // cage-shaft-gear
    translate([0, 4.5, 0])
    rotate(90, [1, 0, 0])
    bevel_gear(gearmod, 4, 45, 2, 0, pressure_angle=5);

    // chage-shaft-stopper
    translate([0, 7.5, 0])
    cube([4.5, 0.9, 0.9], center=true); 
    
    // cage-pinion
    translate([0, 15, -2])
    rotate(90, [1, 0, 0])
    pinion();
  }
}

// cage
translate([0, st_cage_sh, 0])
translate([3, 11, 4])
rotate(90, [0, 0, 1])
rotate(90, [1, 0, 0])
rack_cage();


// cage -> o-shaft
translate([8, 10+st_cage_sh, 1.25])
rotate(27, [0, 0, 1])
cube([3, g, 1]);

// i-shaft -> cage shifter
translate([8, 4.5 + st_i, 9])
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

