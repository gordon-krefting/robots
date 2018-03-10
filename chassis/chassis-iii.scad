use <wheels.scad>;
use <components/zwl_fp180ino.scad>;
include <components/zwl_fp180ino_constants.scad>
use <components/front_wheel.scad>;
use <components/batteries.scad>;
use <parts/mortise_tenon.scad>;

$fn=128;

*printTest();

module printTest() {
  intersection() {
   translate([100,-32,6])
    cube([40,70,20]);
    union() {
      lowerPlatform();
      *upperPlatform();
    }
  }
}



lowerPlatform();
!upperPlatform();

motors();
aa6();
wheels();

*floor();

length = 170;
width  = 110;
wallThickness = 1.75;
wallHeight    = 5;
baseThickness = 2;

motorXOffset = 18;
motorYOffset = 0;
motorZOffset = MOTOR_BOX_HEIGHT/2;
motorPoint = [
  motorXOffset,
  -width/2+motorYOffset,
  motorZOffset+baseThickness
];

motorMountDepth = 10;
motorMountLength = 63;


// these should be derived from the wheel files
// remeasure?
wheelDiameter = 45;

frontWheelAssemblyHeight = 33.5;
frontWheelAssemblyDiameter = 28.625*2;//20; //29.635
wheelWellDiameter = frontWheelAssemblyDiameter + 4;

frontWheelMountPoint = [
  length-wheelWellDiameter/2-3,
  0,
  motorZOffset - wheelDiameter + frontWheelAssemblyHeight + baseThickness
];


frontSupportCylinderOffset = 10;

sideMortisePoint = [
  motorMountLength-motorMountDepth/2,
  width/2-motorMountDepth/2,
  0
];
frontMortisePointX = length-frontSupportCylinderOffset;

module lowerPlatform() {
  totalPlatformHeight = 38;
  // measure these!
  wheelWellHeight   = 9;
  whellWellOffset   = 3; //(from front)
  
  difference() {
    union() {
      linear_extrude(wallHeight + baseThickness)
      difference() {
        basePlatformShape();
        offset(r=-wallThickness)
        basePlatformShape();
      }
      linear_extrude(baseThickness)
      basePlatformShape();
      
      //difference() {
        translate([length-wheelWellDiameter/2-3,0,0])
        cylinder(h=wheelWellHeight,r=wheelWellDiameter/2);

        *translate([length-wheelWellDiameter/2-3,0,wheelWellHeight-2.0])
        cylinder(h=8+.01,r=wheelWellDiameter/2-2);
      //}

      translate([length-frontSupportCylinderOffset,0,0])
      cylinder(h=totalPlatformHeight,r=4);
      
      translate([frontMortisePointX,0,totalPlatformHeight])
      tenon(4, 4);
    }
    union () {
      translate(frontWheelMountPoint)
      front_wheel_well();
      
      // slots
      for (m=[0:1])
      mirror([0,m,0])
        for (i = [8:16:40]) {
          for (j = [5:27:135]) {
            if ((j > 110 && i > 30) || j < 110)
            translate([j+2,i,-.1])
            slot();
          }
        }

    }    
  }

  for (m = [0:1])
  mirror([0,m,0])
  difference() {
    union () {
      // motor mount
      translate([0,-width/2,0])
      cube([motorMountLength,motorMountDepth,totalPlatformHeight]);

      translate([0,0,totalPlatformHeight])
      translate(sideMortisePoint)
      tenon(4, 4);;
    }
    
    // the cutout for the shaft
    translate([0,motorMountDepth-motorYOffset-.001,0])
    translate(motorPoint)
    rotate([90,0,0])
    cylinder(h=motorMountDepth,r=7);
    
    // subtract the motor
    translate(motorPoint)
    motor();
  }

}

module slot() {
  hull() {
    translate([15,0,0])
    cylinder(h=baseThickness + .2,r=3);
    cylinder(h=baseThickness + .2,r=3);
  }
}


module upperPlatform() {
  translate([0,0,58]) {
    difference() {
      union() {
        linear_extrude(wallHeight + baseThickness)
        difference() {
          offset(r=+wallThickness)
          basePlatformShape();
          basePlatformShape();
        }
        linear_extrude(baseThickness)

        basePlatformShape();
        for (m=[0:1])
        mirror([0,m,0]) 
        translate(sideMortisePoint)
        cylinder(r=5, h=4);

        translate([frontMortisePointX,0,0])
        cylinder(r=5, h=4);
      }
      union() {
        for (m=[0:1])
        mirror([0,m,0]) 
        translate(sideMortisePoint)
        mortise(4, 8);

        translate([frontMortisePointX,0,0])
        mortise(4, 8);
        
        for (m=[0:1])
        mirror([0,m,0]) 
        for (i = [8:16:40]) {
          for (j = [5:27:155]) {
            if (j < 135 || i < 40)
          translate([j+3,i,-.1])
          slot();
          }
        }
        *translate([length-width/2,0,0]) {
          arch(0, 90, 6, 9);
          arch(0, 80, 6, 27);
          arch(0, 85, 6, 45);
          arch(90, 180, 6, 9);
          arch(100, 180, 6, 27);
          arch(105, 180, 6, 45);
        }
      }
    }
  }
}

module motors() {
  for (m = [0:1])
  mirror([0,m,0])
  translate(motorPoint)
  renderedMotor(); 
}

module basePlatformShape() {
  translate([0,-width/2])
  square([length-width/2,width]);
  translate([length-width/2,0])
  circle(width/2);
}


module renderedMotor() {
  color("silver")
  import("components/zwl_fp180ino.stl"); 
}


module aa6() {
  color("darkgrey")
  translate([6,-45/2,baseThickness])
  aa6holder();
}

module wheels() {
  translate(frontWheelMountPoint)
  front_wheel();
  
  for (m = [0:1])
  mirror([0,m,0])
  translate(motorPoint)
  wheel();
}

module floor() {
//  translate([0,-180/2,motorZOffset-wheelDiameter-baseThickness])
  translate([0,-180/2,motorZOffset-wheelDiameter])
  cube([180,180,2]);
}


module arch(angle1, angle2, thickness, diameter) {
  a1 = diameter * sin(angle1);
  b1 = diameter * cos(angle1);
  a2 = diameter * sin(angle2);
  b2 = diameter * cos(angle2);

  intersection() {
    translate([0,0,-thickness/2])
    linear_extrude(thickness)
    polygon([
      [0,0],[a1*4,b1*4],[a2*4,b2*4],[0,0]
    ]);

    rotate_extrude()
    translate([diameter-thickness/2,-thickness/2])
    square(thickness);
    
  }

  translate([a1,b1,-thickness/2])
  cylinder(h=thickness, r=thickness/2);

  translate([a2,b2,-thickness/2])
  cylinder(h=thickness, r=thickness/2);
}


