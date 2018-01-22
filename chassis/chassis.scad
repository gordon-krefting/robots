use <wheels.scad>;

$fn=48;

usable_shaft_length = 11.1;
unusable_shaft_length = 1.8;

shaft_offset = 15;

motor_box_height = 33;
motor_box_width  = 46.5;
motor_box_depth  = 25.75;

gear_diff = 22.03;

motor_mount();

motor();

//rear_axle();

module rear_axle() {
  rotate([90,70,0])
  translate([gear_diff,0,0])
  rear_axle_shaft_2();
}

module motor_mount() {
  difference() {
    union() {
      translate([-shaft_offset-.75, 0, -(motor_box_height+1.5)/2]) {
        frame = 18;
        difference() {
          cube([motor_box_width+1.5,8.5,motor_box_height+1.5]);
          translate([frame/2, 0, frame/2 + .5])
          cube([motor_box_width-frame,5,motor_box_height-frame]);
        }
      }
    }
    motor();
  }
}


module motor() {
  color("silver") {
    motor_box();
    shaft();
    translate([8,4,10])
    scale([2,3,3])
    arrow();
    
    cylH = 31;
    cylD = 24;
    hull() {
      translate([
        motor_box_width-shaft_offset,
        unusable_shaft_length+cylD/2+3,
        motor_box_height/2 - cylD/2 - 2.5
      ])
      rotate([0,90,0])
      cylinder(h=cylH,r=cylD/2);
      translate([
        motor_box_width-shaft_offset,
        unusable_shaft_length+cylD/2+3,
        -motor_box_height/2 + cylD/2 + 2.5
      ])
      rotate([0,90,0])
      cylinder(h=cylH,r=cylD/2);
    }
  }
}

module motor_box() {
  m3radius = 3.5/2;
  translate([-shaft_offset, unusable_shaft_length, -motor_box_height/2])
  cube([motor_box_width, motor_box_depth, motor_box_height]);

  translate([-9.3,4,-9.1])
  rotate([90,0,0])
  cylinder(h=8, r=m3radius);
  
  translate([-9.3,4,9.1])
  rotate([90,0,0])
  cylinder(h=8, r=m3radius);
  
  translate([24,4,-9.1])
  rotate([90,0,0]) 
  cylinder(h=8, r=m3radius);

  translate([24,4,9.1])
  rotate([90,0,0])
  cylinder(h=8, r=m3radius);
}


/*
 * No longer using this
 */
module gears() {
  // The gears will fit in a 6mm wide gearbox
  // (which is too small, so adjust)
  rotate([90,70,0]) {
    translate([0,0,.5+.05])
    gear1();

    translate([gear_diff,0,0])
    gear2();
  }
}




module shaft() {
  difference() {
    translate([0,unusable_shaft_length,0])
    rotate([90,0,0])
    cylinder(h=usable_shaft_length + unusable_shaft_length,r=3);
    translate([2,-usable_shaft_length,-3])
    cube([3,usable_shaft_length,6]);
  }
}