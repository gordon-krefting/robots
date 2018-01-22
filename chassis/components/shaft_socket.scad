difference() {
  cylinder(h=12,r=6);
  zwl_fp180ino();
}

module zwl_fp180ino() {
  shaft(6.2, 12.05, 1.6);
}
module shaft(shaftDiameter, shaftLength, offset) {
  difference() {
    cylinder(h=shaftLength,r=shaftDiameter/2);
    translate([offset, -shaftLength/2, 0])
    cube(shaftLength);
  }
  cylinder(h=shaftDiameter - 2, r1=shaftDiameter/2 + .5);
}
