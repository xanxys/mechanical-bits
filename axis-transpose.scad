// https://github.com/chrisspen/gears/blob/master/gears.scad
use <gears.scad>;

$fs = 0.1;

margin = 0.35;


gearmod = 0.6;
gear_offset = 2.5 + gearmod * 9 / 2 + 0.1;

/*
translate([-5, 0, 0])
rack_axis();

translate([0, 5, 4])
rotate(90, [0, 0, 1])
rack_axis();

translate([-gear_offset, gear_offset, -1.5])
spur_gear(gearmod , 9, 7, 2.5, pressure_angle=20, helix_angle=0);
*/

base();

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
  cylinder(9.5, 1.2);

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
