// https://github.com/chrisspen/gears/blob/master/gears.scad
use <gears.scad>;

$fs = 0.2;

margin = 0.35;

gearmod_v=1.3;

// input axis

//translate([-4, 0, 0])
//rotate(90, [0, -1, 0])
//cylinder(h=10, d=3, $fn=3);

// input structural axis
rotate(90, [0, -1, 0])
cylinder(h=12, d=2, center=true);

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
  cube([10, 7.5, 5], center=true);
  
  // space for input axis
  rotate(90, [0, -1, 0])
  cylinder(h=12, d=2.3, center=true);
  
  // space for output axis
  translate([0, 4, 0])
  rotate(90, [-1, 0, 0])
  cylinder(h=10, d=2.3);
  
  // space for gears
  cube([8.3, 8.3, 6], center=true);
}


// output axis
translate([0, 4, 0])
rotate(90, [-1, 0, 0])
cylinder(h=10, d=2);

// output cage stopper
translate([0, 6, 0])
rotate(90, [-1, 0, 0])
cylinder(h=1, d=3);

// output gear
translate([0, 4, 0])
rotate(90, [1, 0, 0])
bevel_gear(gearmod_v, 4, 45, 2, 0, pressure_angle=5);



// axis transposer
gearmod = 0.8;
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
