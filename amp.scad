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
st_redir_angle = - st_ax_s / 25 * (360 / (2 * PI));
st_cage_sh = 3 - st_o * 2; // [-3, 3]


////////////////////////////////////////////////////////////////////////////////
// Module surface

base_module(pad=false);
conn_data_y(0, 0, 0, false);
conn_data_x(2, 1, 0, true);
conn_pwr_y(1, 0, 0, false);

print_support();
module print_support() {
  xm = g * 0.25;
  xp = g * 0.5;
  ym = g * 0.75;
  yp = g * 0.25;
 
  difference() { 
    translate([-xm, -ym, 0])
    cube([g*2 + xm + xp, g*2 + ym + yp, 1.2]);
    
    cube([g*2, g*2, 1.3]);
  }
}


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
  len_int = 4;
  
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

// floor partial
translate([7, 0, 0])
cube([g * 2 - 7, g * 2, 1.2]);



// p-shaft
translate([g * 1.5, 0, g * 0.5])
rotate(st_p, [0, 1, 0])
union() {  
  // p-shaft stopper
  translate([0, 1.7, 0])
  cube([6, 0.9, 0.9], center=true);
  
  // p-shaft stopper 2
  translate([0, 21.7, 0])
  cube([5, 0.9, 0.9], center=true);

  // p-shaft (internal) d=2
  translate([0, 11, 0])
  rotate(90, [1, 0, 0])
  cylinder(h=25, d=2.1, center=true);

  translate([0, 8, 0])
  rotate(90, [0, 0, 1])  
  p_shaft_redir();
}

// p-shaft (internal) end holder
translate([g * 1.5, g * 2 - 1, g * 0.5])
difference() {
  cube([6, 1.2, g], center=true);
  hole_y(d=2.4, t=2, center=true);
}




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
      translate([-0.2, 5.8, 0])
      cube([10.8, 2, 5], center=true);
      
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

    // cage-shaft-stopper
    translate([0, 7.5, 0])
    cube([4, 0.9, 0.9], center=true); 
    
    // cage-pinion
    translate([0, 15.2, -2])
    rotate(90, [1, 0, 0])
    pinion();
  }
}

// c-shaft limiter
translate([1.5, 11, 6])
difference() {
  cube([2, 4, g], center=true);
  cube([2.1, 2.4, 4.5], center=true);
}

// cage
translate([3.5, 11+st_cage_sh, g/2])
rotate(90, [0, 0, 1])
rotate(90, [1, 0, 0])
rack_cage();

// cage stopper
translate([0, 21, 0])
cube([4.5, 3, g]);

// cage rails
difference() {
  union() {
    // cage rail (top)
    translate([0, 0, g - 1.2])
    cube([7, g * 2, 1.2]);

    // cage rail (bottom)
    translate([0, 0, 0])
    cube([7, g * 2, 1.2]);
  }
  
  translate([3.5, 11, g/2])
  union() {
    // sliding margin
    translate([0, 0, 0])
    cube([1.8, 21, g - 1], center=true);
    
    // support removal & debug window
    translate([0, 0, 0])
    cube([0.8, 21, g + 0.2], center=true);
  }
}


// i-shaft internal
translate([g * 0.5, st_i, g * 0.5])
union() {
  // stopper (0)
  translate([0, 1.5, 0])
  cube([3, 0.9, 4.8], center=true);
  
  // i-shaft -> cage shifter
  translate([0, 9.5, 0])
  rotate(90+25, [1, 0, 0])
  rotate(90, [0, 1, 0])
  difference() {  
    cube([8, 4.2, 1.5], center=true);
    long_hole(d=2.2, l=3.5, t=1.5);
    
  }
  
  // i-shaft other end
  translate([0, 16.5, 0])
  cube([1, 8, 3], center=true);
  
  // stopper (1)
  translate([0, 15, 0])
  cube([2.8, 0.9, 3], center=true);
}


// i-shaft holder
translate([g / 2, g * 2 - 4.5, g / 2])
difference() {
  cube([3, 2, g], center=true);
  cube([1.3, 2.1, 3.6], center=true);
}

// o-shaft holder
translate([11, g, 0])
difference() {
  translate([4.5, 3.7, 0])
  cube([1.5, 5, 4.2]);
  
  translate([4.4, 4.3, 2.3])
  cube([1.7, 3.4, 1.4]);
}



// cage -> o-shaft
translate([10.5, 14.5+st_cage_sh, 1.9])
union() {
  translate([-5, -3, 0])
  cube([3, 5, 1], center=true);
  
  difference() {
    rotate(90-27, [0, 0, 1])
    difference() {
      cube([11, 4.3, 1], center=true);
      long_hole(d=2.3, l=7, t=1);
    }
    
    // cut corners
    translate([1, 7.1, 0])
    cube([4, 4, 1.1], center=true);
  }
}


// o-shaft internal
translate([st_o, g * 1.5, 0])
union() {
  // stopper (1) & connector
  translate([19.1, -1.5, 3.4])
  cube([0.9, 3, 5]);
  
  // shaft
  translate([8, -1.5, 2.5])
  cube([12, 3, 1]);
  
  // shaft-sub
  translate([9, -2, 3])
  cube([2, 5, 1], center=true);
  
  // pin
  translate([9, -3.5, 1.4])
  cylinder(d=2, h=2);
}



// X: sliding direction, Y: pinion input shift direction, Z: fixed
// cage is centered at origin
module rack_cage() {
  gm = 0.7;
  tr = 6;
  
  thickness = 1.2; // = z size
  h = 10.5; // = Y size
  
  // 0 rack (bottom)
  translate([-2, -3, -thickness/2])
  rack(gm, 6, 1.5, thickness, pressure_angle=5, helix_angle=0);

  // 1 rack (top)
  translate([2, 3, -thickness/2])
  scale([1, -1, 1])
  rack(gm, 6, 1.5, thickness, pressure_angle=5, helix_angle=0);
  
  // rack rail (Y-)
  translate([0, -4.5, 0])
  cube([11, 1.5, thickness], center=true);
  
  // rack rail (Y+)
  translate([0, 4.5, 0])
  cube([11, 1.5, thickness], center=true);
  
  // vertical rod (X-)
  translate([-6.25, 0, 0])
  cube([1.5, h, thickness], center=true);
  
  // vertical rod (X+)
  translate([6.25, 0, 0])
  cube([1.5, h, thickness], center=true);
}

module pinion() {
  n = 4;
  pin_w = 1.4;
  pin_t = 1.5;
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

