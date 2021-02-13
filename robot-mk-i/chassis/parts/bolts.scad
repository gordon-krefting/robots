/*
 * Random parts
 */


m6_150_bolt();

m6_bracket();

module m6_150_bolt() {
  color("silver") {
    rotate([-90,0,0]) {
      cylinder(h=150,r=3+.05);
      translate([0,0,-2])
      cylinder(h=2, r=4, $fn=6);
    }
  }
}

module m6_bracket() {
  rotate([-90,0,0])
  cylinder(h=4, r=6);
}