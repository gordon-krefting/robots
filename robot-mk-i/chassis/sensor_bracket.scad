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

horn_d1 = 7.4;
horn_d2 = 4.5;
horn_d3 = 4.5;

horn_l1 = 33;
horn_l2 = 13.5;

box = [42,22,4];
difference() {
  union() {
    translate([-box.x/2,-box.y/2,0.001])
    cube(box);
    translate([-12,-4.5,4])
    cube([25,9,1]);
  }
  horns();
}

sensor_bracket();

module sensor_bracket() {
  translate([horn_l1/2+5,board.x/2+2,4])
  rotate([0,0,-90])
  difference() {
    translate([0,-2,-4])
    cube([board.x + 4, board.y + 6, board.z / 2 + 7]);
    translate([2,0,1])
    sensor();
  }
}

module horns() {
  linear_extrude(4.002)
  horn_outline();

  linear_extrude(1, scale=.8)
  offset(.25)
  horn_outline();
 
  module horn_outline() {
    hull() {
      circle(horn_d1/2);
      for (m = [0:1])
      mirror([m,0,0])
      translate([horn_l1/2,0,0])
      circle(horn_d2/2);
    }
    hull () {
      for (m = [0:1])
      mirror([0,m,0])
      translate([0,horn_l2/2, 0])
      circle(horn_d3/2);
    }
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