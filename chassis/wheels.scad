use <components/zwl_fp180ino.scad>;
include <components/zwl_fp180ino_constants.scad>


$fn=32;

main_wheel();

module wheel() {
  color("DodgerBlue")
  main_wheel();
}

module main_wheel() {
  difference() {
    rotate([90,0,0]) {
      union() {
        // hub
        translate([0,0,0])
        cylinder(h=10.5, r=8);
        
        // tire
        translate([0,0,4])
        difference() {
          cylinder(h=14, r=45);
          translate([0,0,-.1])
          cylinder(h=14.2, r=44);
        }
        
        // spokes
        translate([0,0,4]) {
          difference() {
            cylinder(h=16, r=44);
            translate([0, 0, 145 + 4])
            sphere(145);
            for (a = [0:60:300]) {
              rotate([0,0,a])
              translate([28,0,-.1])
              cylinder(h=20,r=12);
            }
          }
        }
      }
    }
    #translate([0,.001,0])
    shaftSocket();
  }
}
