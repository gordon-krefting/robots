use <components/zwl_fp180ino.scad>;
include <components/zwl_fp180ino_constants.scad>


//$fn=128;

collar();

main_wheel();

module wheel() {
  color("DodgerBlue", .2)
  main_wheel();
  color("DodgerBlue", .6)
  collar();
}

module collar() {
  difference() {
    rotate([90,0,0])
    union() {
      translate([0,0,.01])
      cylinder(h=2, r=8);
    }
    shaftSocket();
  }
}

module main_wheel() {
  translate([0,4,0])
  difference() {
    rotate([90,0,0]) {
      union() {
        // hub
        translate([0,0,8])
        cylinder(h=8, r=6);
        
        // tire
        translate([0,0,6])
        difference() {
          cylinder(h=18, r=45);
          translate([0,0,-.1])
          cylinder(h=18.2, r=44);
        }
        
        // spokes
        translate([0,0,6]) {
          difference() {
            cylinder(h=16, r=44);
            translate([0, 0, 95 + 5])
            sphere(95);
            for (a = [0:60:300]) {
              rotate([0,0,a])
              translate([28,0,-.1])
              cylinder(h=20,r=12);
            }
          }
        }
      }
    }
    translate([0,-5.99,0])
    shaftSocket();
  }
}




/*


















gear_diff = 22.03;
gearDepth = 7;

// The gears will fit in a 9mm wide gearbox maybe

translate([0,0,.5+.05])
gear1();

!translate([gear_diff,0,0])
gear2();

translate([gear_diff,0,0])
rear_axle_shaft_2();

translate([gear_diff,0,0])
rear_axle_socket();

module gear1() {
  color("green")
  difference() {
    translate([0,0,2])
    union() {
      linear_extrude(gearDepth - .05)
      rotate(17.5)
      scale(.075)
      import(file="gear1.dxf", layer="gear");
      
      translate([0,0, gearDepth -.5 - .05])
      cylinder(h=.5, r=10);
      
      translate([0,0,-2])
      cylinder(h=3, r=5);
    }
    zwl_fp180ino();
  }
}

module gear2() {
  color("olivedrab")
  translate([0,0,2])
  difference() {
    union() {
      linear_extrude(gearDepth - .05)
      rotate(1)
      scale(.075)
      import(file="gear2.dxf", layer="gear");
      cylinder(h=.5, r=16.5);
      gearshaft(); 
    }
    
    union() {
      translate([0,0,2]) 
      difference() {
        cylinder(h=8, r=12.5);
        cylinder(h=8, r=4.5);
      }
      for (a = [0:60:300]) {
        rotate([0,0,a])
        translate([8.5,0,0])
        cylinder(h=15,r=3.75);
      }
      #cylinder(h=8,r1=3.5+.1,r2=.11);
    }
  }  
}

module gearshaft() {
  shaftDiameter = 7;
  rotate([0,0,0]) {
    cylinder(h=gearDepth + 10, r=shaftDiameter/2, $fn=6);
    cylinder(h=gearDepth + 5, r=shaftDiameter/2);
  }
}

module rear_axle_shaft() {
  shaftDiameter = 7;
  cylinder(h=4-.1, r=shaftDiameter/2);
  cylinder(h=1, r=shaftDiameter/2+2);
  translate([0,0,-3])
  cylinder(h=3, r=shaftDiameter/2, $fn=6);
}

module rear_axle_shaft_2() {
  shaftDiameter = 7;
  difference() {
    union() {
      cylinder(h=2, r=shaftDiameter/2);
      translate([0,0,1.9])
      cylinder(h=8,r1=3.5,r2=.11);
      translate([0,0,-2])
      cylinder(h=2, r=shaftDiameter/2, $fn=6);
      translate([0,0,-3])
      cylinder(h=1, r1=shaftDiameter/2 - .5, r=shaftDiameter/2,  $fn=6);
    }
    translate([-5,-5,4])
    cube([10,10,10]);
  }
}

module rear_axle_socket() {
  shaftDiameter = 7;
  rotate([0,180,0])
  difference() {
    cylinder(h=5, r=6);
    union() {
      cylinder(h=4 + .05, r=shaftDiameter/2 + .05, $fn=6);
      cylinder(h=4, r1=shaftDiameter/2 + .1, r2=2.5, $fn=48);
    }
  }
}

*/
