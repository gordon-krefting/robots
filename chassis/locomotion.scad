$fn = 198;

driveDiameter = 12;
camDiameter = 20;
shaftDiameter = 3;
shaftFlatOffset = .5;
shaftOffset = 2;
slop = .5;


assembled();
*print();

module assembled() {
  drive();
  cam();
  base();
}

module print() {
  translate([25,0,0])
  drive();
  cam();
  translate([-30,0,2])
  base();
}


module base() {
  translate([shaftOffset,0,-2]) {
    difference() {
      cylinder(r=(camDiameter+4)/2, h=2);
      cylinder(r=(shaftDiameter+slop)/2, h=5);
    }
    translate([-4,-25,0])
    cube([8,20,2]);
    translate([-4,-20,2])
    difference() {
      cube([8,2,6]);
      translate([1.5,-.01,0])
      cube([5,2.011,4]);
    }
  }
}

module drive() {
  difference() {
    cylinder(r1=driveDiameter/2, r2=driveDiameter/2+2, h=5);
    translate([shaftOffset, 0])
    shaft();
  }
}

module cam() {
  rotate([0,0,5]) {
    difference() {
      union() {
        linear_extrude(3)
        translate([-1.25, -35])
        square([2.5,30]);
        cylinder(r=camDiameter/2, h=5);
      }
      translate([0,0,-.0005])
      cylinder(
        r1=(driveDiameter+slop)/2,
        r2=(driveDiameter+slop)/2+2,
        h=5.001
      );
    }
  }
}

module shaft() {
  translate([0,0,-0.0005])
  linear_extrude(5.001)
  difference() {
    circle((shaftDiameter+slop)/2);
    translate([shaftDiameter/2-shaftFlatOffset,-2.5])
    square([5,5]);
  }
}