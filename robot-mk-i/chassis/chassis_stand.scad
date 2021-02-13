$fn = 48;

points = [
  [7,-24,0],
  [7,24,0],
  [27*3 + 7,-8,0],
  [27*3 + 7,8,0]
];

for (point = points) {
  echo(point);
  translate(point)
  cylinder(r=2.7,h=32);
}

connector(points[0], points[1], 1);
connector(points[1], points[3], 0);
connector(points[0], points[2], 0);
connector(points[3], points[2], 1);

module connector(p1,p2,l) {
  for (t = [0:l])
  translate([0,0,30*t])
  hull() {
    translate(p1)
    cylinder(r=2.7,h=2);
    translate(p2)
    cylinder(r=2.7,h=2);
  }
}

tabs();

module tabs() {
  slotWidth = 5.4;
  slotOffset = 15;
  slotLength = slotOffset + slotWidth;

  translate([0,0,32])
  rotate([180,0,0])
  translate([0,-1.5*slotOffset-slotWidth/4,0]) {
    
    translate([27*3,16,0])
    slot();
    translate([27*3,32,0])
    slot();
    translate([0,0,0])
    slot();
    translate([0,48,0])
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
