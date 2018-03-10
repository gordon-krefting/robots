$fn = 48;

shaft_d = 5.8;

difference() {
  cube([45,10,4]);
  for (i=[0:.1:.4])
  translate([75*i+5,5,-.001])
  servo_socket(shaft_d+i);
}


*servo_socket(6);

tooth_width = 1;
tooth_length = 1;


module servo_socket(d) {
  echo(d);
  difference() {
    cylinder(r=d/2,h=6);
    
    for (r = [0:360/21:360])
    rotate([0,0,r])
    translate([0, d/2-tooth_length, -.001])
    linear_extrude(5)
    polygon([
      [0,0],
      [-tooth_width/2,tooth_length],
      [tooth_width/2,tooth_length],
      [0,0]
    ]);
  }
  cylinder(r=d/2+.1,h=.3);
}