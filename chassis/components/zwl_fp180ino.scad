include <zwl_fp180ino_constants.scad>
/*
 *  Don't know exactly what this motor is, but it says ZWL-FP180ino on it
 *
 */
 
translate([50,0,0])
motor($fn=32);

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
    
    translate([8,4,10])
    scale([2,3,3])
    arrow();
    
    cylH = 31;
    cylD = 24;
    hull() {
      translate([
        MOTOR_BOX_WIDTH-SHAFT_OFFSET,
        UNUSABLE_SHAFT_LENGTH+cylD/2+3,
        MOTOR_BOX_HEIGHT/2 - cylD/2 - 2.5
      ])
      rotate([0,90,0])
      cylinder(h=cylH,r=cylD/2);
      translate([
        MOTOR_BOX_WIDTH-SHAFT_OFFSET,
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
module shaftSocket(diameter=SHAFT_DIAMETER) {
  color("grey") {
    intersection() {
      shaft(USABLE_SHAFT_LENGTH,
        UNUSABLE_SHAFT_LENGTH,
        diameter
      );
      translate([-8,-16,-8])
      cube([16,16,16]);
    }
    rotate([90,0,0])
    cylinder(h=4, r2=2, r1=(diameter+1)/2);
  }
}


module motor_box() {
  m3radius = 3.5/2;
  translate([-SHAFT_OFFSET, UNUSABLE_SHAFT_LENGTH, -MOTOR_BOX_HEIGHT/2])
  cube([MOTOR_BOX_WIDTH, MOTOR_BOX_DEPTH, MOTOR_BOX_HEIGHT]);

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

module shaft() {
  difference() {
    translate([0,UNUSABLE_SHAFT_LENGTH,0])
    rotate([90,0,0])
    cylinder(h=USABLE_SHAFT_LENGTH + UNUSABLE_SHAFT_LENGTH,r=SHAFT_DIAMETER/2);
    translate([2,-USABLE_SHAFT_LENGTH,-3])
    cube([3,USABLE_SHAFT_LENGTH,6]);
  }
}

module shaft(usableLength, unusableLength, diameter) {
  difference() {
    translate([0,unusableLength,0])
    rotate([90,0,0])
    cylinder(h=usableLength + unusableLength,r=diameter/2);
    translate([2,-usableLength,-3])
    cube([3,usableLength,6]);
  }
}

module arrow() {
  rotate([90,0,0])
  linear_extrude(2)
  polygon([[0,0],[-1,0],[0,1],[1,0],[0,0]]);
}
