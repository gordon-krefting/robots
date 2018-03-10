$fn=48;

slop = .2;
board = [45.1 + slop, 1.65 + slop, 20];
electronics = [43.2 + slop, 5, 14];
electronics_offset = [1.7, -electronics.y, 1];
sensor_diameter = 15.9 + slop;
sensor_distance = 9.94 - slop;
bump_diameter   = 3.5;
bump_distance   = 10-bump_diameter*2;
bump_offset     = 7.5;
tooth_width = 1;
tooth_length = 1;

difference() {
  translate([-10,-5,0])
  cube([35,10,4.5]);
  servo_socket(6);
}

sensor_bracket();

module servo_socket(d) {
  echo(d);
  difference() {
    cylinder(r=d/2,h=4.9);
    
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

module sensor_bracket() {
  translate([30/2+5,board.x/2+2,4])
  rotate([0,0,-90])
  difference() {
    translate([0,-2,-4])
    cube([board.x + 4, board.y + 6, board.z / 2 + 7]);
    translate([2,0,1])
    sensor();
  }
}


module sensor() {
  cube(board);
  
  // electronic bits
  translate([0,.01,0])
  translate(electronics_offset)
  cube(electronics);
  
  translate([sensor_diameter/2+(board.x-sensor_diameter*2-sensor_distance)/2,board.y-.001,board.z/2])
  rotate([-90,0,0])
  linear_extrude(12)
  hull() {
    for (t = [0,1])
    translate([(sensor_distance+sensor_diameter)*t,0,0])
    circle(sensor_diameter/2);

    translate([(sensor_diameter+sensor_distance-bump_diameter-bump_distance)/2,0,0])
    for (t = [0,1])
    translate([(bump_distance+bump_diameter)*t,bump_offset,0])
    circle(bump_diameter/2);
  }
}