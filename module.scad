g = 12;

module base_module(nx=2, ny=2, nz=1, pad=true) {
  // base layer
  //translate([0, 0, 0])
  //cube([g * nx, g * ny, 0.8]); // 0.2+ 0.3n
  
  // structural interface
  str_w = 1.8; // module structural pillar half size
  str_t = 1.2; // structural interface internal thickness
  
  if(pad) {
    intersection() {
      difference() {
        for (ix = [0:nx]) {
          for (iy = [0:ny]) {
            for (iz = [0:nz]) {
              if (ix == 0 || iy == 0 || iz == 0 || ix == nx || iy == ny || iz == nz) {
                translate([ix * g, iy *g, iz * g])
                cube([str_w * 2, str_w * 2, str_w * 2], center=true);
              }
            }
          }
        }
        // remove internal space (leaving str_t)
        translate([str_t, str_t, str_t])
        cube([nx * g - str_t * 2, ny * g - str_t * 2, nz * g - str_t * 2]);
      }
      
      // limit to module size
      cube([nx * g, ny * g, nz * g]);
    }
  }  
  
  // pillars
  cube([str_w, str_w, g]);

  translate([12 * nx - str_w, 0, 0])
  cube([str_w, str_w, g]);

  translate([0, g * ny - str_w, 0])
  cube([str_w, str_w, g]);

  translate([g * nx - str_w, g * ny - str_w, 0])
  cube([str_w, str_w, g]);
}

// side_pos: true:X+ / false:X-
module conn_data_x(ix, iy, iz, side_pos) {
  t = 1;
  conn_size = 3;
  hole_size = conn_size + 0.2 * 2;
  
  translate([ix * g, iy * g, iz * g])
  scale([side_pos ? -1 : 1, 1, 1])
  difference() {
    cube([t, g, g]);
    
    translate([0, g / 2, g / 2])
    cube([t * 3, hole_size, hole_size], center=true);
  }
}

// side_pos: true:Y+ / false:Y-
module conn_data_y(ix, iy, iz, side_pos) {
  t = 1;
  conn_size = 3;
  hole_size = conn_size + 0.2 * 2;
  
  translate([ix * g, iy * g, iz * g])
  scale([1, side_pos ? -1 : 1, 1])
  difference() {
    cube([g, t, g]);
    
    translate([g / 2, 0, g / 2])
    cube([hole_size, t * 3, hole_size], center=true);
  }
}

module conn_pwr_y(ix, iy, iz, side_pos) {
  t = 1;
  conn_size = 3;
  hole_size = conn_size + 0.3 * 2;
  
  translate([ix * g, iy * g, iz * g])
  scale([1, side_pos ? -1 : 1, 1])
  difference() {  
    cube([g, t, g]);
    
    translate([g/2, 0, g/2])
    hole_y(d=3.3, t=t*3, center=true);
  }
}


// 3d print friendly hole (YZ plane)
// center=ffalse: x in [0, t]
// center=true: x in [-t/2, t/2]
module hole_x(d, t, center=true, layer=0.3) {
  eps = 0.05; // to remove hole removal artifact
  
  translate([center ? 0 : t/2 - eps, 0, 0])
  union() {
    rotate(90, [0, 1, 0])
    cylinder(h=t + eps*2, d=d, center=true);
    
    cube([t + eps*2, layer*3, d+layer*2], center=true);
  }
}

module hole_y(d, t, center=true, layer=0.3) {
  rotate(90, [0, 0, 1])
  hole_x(d, t, center, layer);
}


// long hole (X: free direction, Z: axis)
// centered at origin
module long_hole(d, l, t) {
  eps = 0.05;  // reduce artifact
  
  cube([l, d, t+eps*2], center=true);
  
  translate([-l/2, 0, 0])
  cylinder(d=d, h=t+eps*2, center=true);
  
  translate([l/2, 0, 0])
  cylinder(d=d, h=t+eps*2, center=true);
}

