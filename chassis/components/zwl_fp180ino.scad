include <zwl_fp180ino_constants.scad>
/*
 *  Don't know exactly what this motor is, but it says ZWL-FP180ino on it
 *
 */


*printTest();

module printTest() {
  difference() {
    translate([-5,-5,-5])
    cube([70,5,10]);
    for (o = [0:.1:.5]) {
      translate([o*100,0,0])
      shaftSocket($fn=32, flatPartOffset=2-o);
      echo(2-o);
    }
  }
}


translate([50,0,0])
motor($fn=96);

shaftSocket($fn=32);

/*
 * Draws the basic outline of the motor, sized to be subtracted from other parts.
 * Centered on the beginning of 'usable' part of the shaft.
 * There's an enlarged cutout for the cylinder that sllows parts using this to mirrored.
 * The four other protusions make space for correctly placed bolts.
 */
module motor() {
  color("silver") {
    motor_box();
    
    shaft(
      USABLE_SHAFT_LENGTH,
      UNUSABLE_SHAFT_LENGTH,
      SHAFT_DIAMETER
    );
    
    cylH = 31;
    cylD = 24;
    hull() {
      translate([
        MOTOR_BOX_WIDTH-SHAFT_OFFSET-.001,
        UNUSABLE_SHAFT_LENGTH+cylD/2+3,
        MOTOR_BOX_HEIGHT/2 - cylD/2 - 2.5
      ])
      rotate([0,90,0])
      cylinder(h=cylH,r=cylD/2);
      translate([
        MOTOR_BOX_WIDTH-SHAFT_OFFSET-.001,
        UNUSABLE_SHAFT_LENGTH+cylD/2+3,
        -MOTOR_BOX_HEIGHT/2 + cylD/2 + 2.5
      ])
      rotate([0,90,0])
      cylinder(h=cylH,r=cylD/2);
    }
  }
}

/*
 * The "usable" part of the shaft, sized for subtraction to make a socket.
 * The opening of the socket is widened a bit for easier assembly.
 */
module shaftSocket(diameter=SHAFT_DIAMETER, flatPartOffset=1.7) {
  color("grey") {
    intersection() {
      shaft(USABLE_SHAFT_LENGTH,
        UNUSABLE_SHAFT_LENGTH,
        diameter,
        flatPartOffset
      );
      translate([-8,-16,-8])
      cube([16,16,16]);
    }
    rotate([90,0,0])
    cylinder(h=2, r2=2, r1=(diameter+1)/2);
  }
}

// TODO double-check those 5.5s! (After using a real screw...)
module motor_box() {
  m3radius = 3.5/2;
  translate([-SHAFT_OFFSET, UNUSABLE_SHAFT_LENGTH, -MOTOR_BOX_HEIGHT/2])
  cube([MOTOR_BOX_WIDTH, MOTOR_BOX_DEPTH, MOTOR_BOX_HEIGHT]);

  // 9.3 -> 8.9
  translate([-8.9,4,-9.1])
  rotate([90,0,0])
  cylinder(h=5.5, r=m3radius);
  
  // 9.3 -> 8.9
  translate([-8.9,4,9.1])
  rotate([90,0,0])
  cylinder(h=5.5, r=m3radius);
  
  translate([24,4,-9.1])
  rotate([90,0,0]) 
  cylinder(h=5.5, r=m3radius);

  translate([24,4,9.1])
  rotate([90,0,0])
  cylinder(h=5.5, r=m3radius);
}

module shaft(usableLength, unusableLength, diameter, flatPartOffset=1.7) {
  difference() {
    translate([0,unusableLength,0])
    rotate([90,0,0])
    cylinder(h=usableLength + unusableLength,r=diameter/2);
    //
    translate([flatPartOffset,-usableLength-.001,-3])
    cube([3,usableLength+.001,6]);
  }
}
