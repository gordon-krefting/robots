use <wheels.scad>;
use <components/zwl_fp180ino.scad>;
include <components/zwl_fp180ino_constants.scad>
use <components/batteries.scad>;

$fn=128;

print();

module print() {
  union() {
    translate([0,-40,0])
    rotate([90,0,0]) motor_mount();
    translate([0,40,0])
    mirror([0,1,0])
    rotate([90,0,0]) motor_mount();
  }
  rotate([90,0,0]) frame();
  rotate([180,0,0]) floor();
  union() {
    translate([0,120,0])
    rotate([-90,0,0]) main_wheel();
    !rotate([-90,0,0]) main_wheel();
  }
  union() {
    translate([0,30,0])
    rotate([-90,0,0]) collar();
    rotate([-90,0,0]) collar();
  }
}

left();
right();
battery();
frame();
floor();

// how far apart left and right are, measured from wheel origin
separation = 110;
//separation = 30;

motorMountHeight = MOTOR_BOX_HEIGHT + 24;
motorMountWidth = MOTOR_BOX_WIDTH + 10;
motorMountDepth = 8;
motorMountOffset = .5;
motorMountProtrusion = 10;

frameLength = 110;
frameDepth  = separation-motorMountProtrusion;
frameHeight = motorMountHeight;
beamSize    = 8;
frameOffset = 25;

floorDepth = 2;

module right() {
  translate([0,separation,0])
  mirror([0,1,0])
  left();
}

module left() {
  color("grey")
  motor_mount();
  motor();
  wheel();
}

module frame() {
  //color("gold")
  difference() {
    translate([-frameOffset,(separation-frameDepth)/2,-motorMountHeight/2])
    difference() {
      cube([frameLength, frameDepth, frameHeight]);
      
      union() {
        translate([-.5, beamSize, beamSize])
        cube([frameLength+1, frameDepth-2*beamSize, frameHeight-2*beamSize]);
        translate([beamSize, -.5, beamSize])
        cube([frameLength-2*beamSize, frameDepth+1, frameHeight-2*beamSize]);
        translate([beamSize, beamSize, -.5])
        cube([frameLength-2*beamSize, frameDepth-2*beamSize, frameHeight+1]);
      }
    }
    rods();
  }
}

module rods() {
  screwDiameter = 4.6;
  color("grey")
  translate([-frameOffset,(separation-frameDepth)/2,-motorMountHeight/2])
  for (i = [0:18:frameLength-18*2]) {
    translate([beamSize/2+14+i,140,beamSize/2])
    rotate([90,0,0])
    cylinder(h=150,r=screwDiameter/2);

    translate([beamSize/2+14+i,140,beamSize/2 + frameHeight-beamSize])
    rotate([90,0,0])
    cylinder(h=150,r=screwDiameter/2);
  }
}



// tabs & screwholes
// notches for corners
// front skid
module floor() {
  floorWidth = frameDepth - 1;
  floorLength = frameLength - 1;
  difference() {
    color("DarkKhaki")
    translate([
      -frameOffset,
      (separation-floorWidth)/2,
      -motorMountHeight/2 + beamSize + .1
    ]) {
      difference() {
        union() {
          cube([floorLength, floorWidth, floorDepth]);
          translate([beamSize+2.5, beamSize-.25, -beamSize])
          cube([floorLength-beamSize*2-4, 1, beamSize]);
          translate([beamSize+2.5, floorWidth-beamSize+.25, -beamSize])
          cube([floorLength-beamSize*2-4, 1, beamSize]);
          strutHeight = 45 - motorMountHeight/2 + beamSize + floorDepth;
          translate([floorLength - beamSize-1,floorWidth/2,-strutHeight])
          cylinder(h=strutHeight,r=2.5);
        }
        notchSize = beamSize+.25;
        translate([-.1,-.1,-.1])
        cube([notchSize,notchSize,notchSize]);
        translate([floorLength-notchSize+.1,-.1,-.1])
        cube([notchSize,notchSize,notchSize]);
        translate([floorLength-notchSize+.1,floorWidth-notchSize+.1,-.1])
        cube([notchSize,notchSize,notchSize]);
        translate([-.1,floorWidth-notchSize+.1,-.1])
        cube([notchSize,notchSize,notchSize]);
      }
    }
    union () {
      rods();
    }
  }
}


module lid() {
}

module battery() {
  translate([-20,(separation-45)/2,-15])
  aa6holder();
}

// notches for frames
// screwholes
// holes
module motor_mount() {
  frame=18;
  difference() {
    union() {
      difference() {
        translate([-(motorMountWidth-MOTOR_BOX_WIDTH)/2 - SHAFT_OFFSET+3, motorMountOffset, -motorMountHeight/2])
        cube([motorMountWidth, motorMountDepth, motorMountHeight]);
        translate([-SHAFT_OFFSET+frame/2,-.05, -MOTOR_BOX_HEIGHT/2+frame/2])
        cube([MOTOR_BOX_WIDTH-frame, 5.02, MOTOR_BOX_HEIGHT-frame]);
      }
    }
    union() {
      motor();
      rods();
      
      translate([
        -(motorMountWidth-MOTOR_BOX_WIDTH)/2 - SHAFT_OFFSET+3 - .01,
        (separation-frameDepth)/2 - .25,
        -motorMountHeight/2 - .01
      ])
      cube([motorMountWidth+.02,beamSize + .01,beamSize+floorDepth+.5]);
      
      translate([
        -(motorMountWidth-MOTOR_BOX_WIDTH)/2 - SHAFT_OFFSET+3,
        (separation-frameDepth)/2 - .25,
        motorMountHeight/2-beamSize-.5
      ])
      cube([motorMountWidth,beamSize,beamSize+.51]);
    }
  }
}
