// https://github.com/chrisspen/gears/blob/master/gears.scad
use <gears.scad>;

$fs = 0.2;

margin = 0.35;
gearmod = 0.8;
gearmod_v = 1.3;

base_module();

module base_module(nx=2, ny=2, pillar_w=2) {
  translate([0, 0, 0])
  cube([12 * nx, 12 * ny, 0.8]); // 0.2+ 0.3n

  cube([pillar_w, pillar_w, 12]);

  translate([12 * nx - pillar_w, 0, 0])
  cube([pillar_w, pillar_w, 12]);

  translate([0, 12 * ny - pillar_w, 0])
  cube([pillar_w, pillar_w, 12]);

  translate([12 * nx - pillar_w, 12 * ny - pillar_w, 0])
  cube([pillar_w, pillar_w, 12]);
}

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

// paxis wall
translate([12, 0, 0])
difference() {  
  cube([12, 0.8, 12]);
  
  translate([6, -1, 6])
  rotate(90, [1, 0, 0])
  cylinder(h=5, d=3.6, center=true);
}

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

// rack cage
//rack_cage();

translate([3, 8, 4])
rotate(90, [0, 0, 1])
rotate(90, [1, 0, 0])
rack_cage();

// rack-oaxis
translate([6, 10, 2])
rotate(-27, [0, 0, 1])
cube([3, 12, 1]);

// iaxis-cage
translate([1.5, 6, 2])
rotate(45, [1, 0, 0])
cube([1, 10, 3]);

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



// axis transposer

gear_offset = 2.5 + gearmod * 9 / 2 + 0.1;

/*
translate([-5, 0, 0])
rack_axis();

translate([0, 5, 4])
rotate(90, [0, 0, 1])
rack_axis();

translate([-gear_offset, gear_offset, -1.5])
spur_gear(gearmod, 9, 7, 2.5, pressure_angle=20, helix_angle=0);
*/

//base();


module rack_axis() {
  translate([0, 2.5, -1.5])
  rack(gearmod , 9, 3, 3, pressure_angle=20, helix_angle=0);
  cube([40, 3, 3], center=true);
}

module base() {
  translate([-24+6, -6, -(1+1.5+2.4)]) {
    difference() {
      union() {
        cube([24, 24, 2.4]);
    
        // low axis conn
        cube([2, 24, 6.5]);
        translate([22, 0, 0]) 
        cube([2, 24, 6.5]);
        
        // high axis conn
        cube([24, 2, 10.5]);
        translate([0, 22, 0]) 
        cube([24, 2, 10.5]);
      }
      
      // holes (low axis)
      translate([1, 6, 5])
      cube([3.6, 3.6, 3.6], center=true);
      
      translate([1+22, 6, 5])
      cube([3.6, 3.6, 3.6], center=true);
      
      
      // holes (high axis)
      translate([18, 1, 9])
      cube([3.6, 3.6, 3.6], center=true);
      
      translate([18, 1+22, 9])
      cube([3.6, 3.6, 3.6], center=true);
    }
  }

  translate([-gear_offset, gear_offset, -4])
  cylinder(h=9.5, d=2.4);

  translate([-gear_offset, gear_offset, -4])
  cylinder(h=2.4, d=3.5);
}


module z_dimple(height = 1) {
    translate([1, 0, height * 0.35355])
    rotate(-90, [0, 1, 0])
    scale([height * 0.35355, 1, 2]) {
        cylinder(1, 2, 2, $fn=3);
    }
}



/*
for (i = [0:1]) {
    translate([i * 12, 0, 0]) {
        conn_y();
    }
    translate([0, 36, 0]) {
        conn_y();
    }
}
*/

module conn_y() {
    cube([3, 20, 3], center = true);

    difference() {
        cube([12, 3, 12], center = true);
        cube([3 + margin * 2, 10, 3 + margin * 2], center = true);
    }
}
