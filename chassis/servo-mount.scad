$fn=48;

slop = 1.5;

*translate([-158,0,-62])
import("stl/chassis-iii-upper.stl");

render()
translate([-21,0,2])
intersection() {
  translate([0,-51,16])
  import("stl/servo-bracket.stl");
  
  linear_extrude(18)
  translate([15,0,0])
  scale([1,.7])
  circle(20);
}

converter_translation = [-21,35,15];
converter_rotation =    [0,0,90];

tabs();
platform();

*buck_converter();
converter_bracket();

module platform() {
  linear_extrude(2)
  difference() {
    intersection() {
      scale([1,.55])
      circle(65);

      translate([-39,0])
      circle(50);
    }
    hull() {
      translate([1.8,0,0])
      circle(5.5);
      translate([-23.8,0,0])
      circle(2.9);
    }
  }
}

module tabs() {
  slotWidth = 5.4;
  slotOffset = 15;
  slotLength = slotOffset + slotWidth;

  rotate([0,0,180])
  translate([0,-1.5*slotOffset-slotWidth/4,0]) {
    for (y = [0:3])
    translate([0,16*y,0])
    slot();

    for (y = [1:2])
    translate([27,16*y,0])
    slot();
  }
  module slot() {
    rotate([180,0,0])
    translate([slotOffset/2,0,0])
    linear_extrude(4,scale=.95)
    translate([-slotOffset/2,0,0])
    hull() {
      translate([slotOffset,0])
      circle(slotWidth/2);
      circle(slotWidth/2);
    }
  }
}

module converter_bracket() {
  rotate(converter_rotation)
  translate([converter_translation.x, converter_translation.y, 0]) {
    translate([6.5, 21.05 - 2.5, -.001])
    cylinder(r=1.3,h=converter_translation.z + 5);

    translate([6.5, 21.05 - 2.5, -.001])
    cylinder(r=3,h=converter_translation.z);

    translate([43.2 - 6.5, 2.5, -.001])
    cylinder(r=1.3,h=converter_translation.z + 5);

    translate([43.2 - 6.5, 2.5, -.001])
    cylinder(r=3,h=converter_translation.z);

    translate([43.2 - 6.5, 21.05 - 2.5, -.001])
    cylinder(r=3,h=converter_translation.z);

    translate([6.5, 2.5, -.001])
    cylinder(r=3,h=converter_translation.z);

  }
}

module buck_converter() {
  rotate(converter_rotation)
  translate(converter_translation)
  difference() {
    union () {
      cube([43.2, 21.05, 1.5]);
      
      translate([4,11,1.5])
      cylinder(r=4, h=9.5);

      translate([39,11,1.5])
      cylinder(r=4, h=9.5);
      
      
      translate([26,3,1.5])
      cube([9,10,5]);
      
      translate([10,7,1.5])
      cube([12.5,12.5,7.5]);

      translate([10,2,1.5])
      cube([9.5,4,10]);
    }
    
    translate([6.5, 21.05 - 2.5, -.001])
    cylinder(r=1.5,h=4);

    translate([43.2 - 6.5, 2.5, -.001])
    cylinder(r=1.5,h=4);
  }
  
}






