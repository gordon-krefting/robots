// let's only do slop on the tenon!!!


translate([10,0,0])
tenon(3,8);

mortise_socket(5, 10, 3, 8);

union() {
  translate([100,0,13])
  tenon_print_test();

  translate([50,0,20])
  mortise_socket_print_test();
  
}

module mortise_socket_print_test() {
  sphere(11);
  for (a=[0:90:180]) {
    rotate([a,0,])
    rotate([0,0,45])
    translate([0,0,-20])
    mortise_socket(8, 10, 4, 8);
  }
}

module tenon_print_test() {
  sphere(6);
  for (a=[0:90:180]) {
    rotate([a,0,0])
    translate([0,0,5])
    tenon(4, 8);
  }
}


module mortise_socket(socket_width, socket_height, width, depth, slop=.35, chamfer=1) {
  difference() {
    translate([-socket_width/2,-socket_width/2,0])
    cube([socket_width, socket_width, socket_height]);
    mortise(width, depth, slop, chamfer);
  }
}


// the mortise is the hole... diff this
module mortise(width, depth, slop=.1, chamfer=1) {
  eWidth = width+slop; // effective width
  eDepth = depth+slop*2;
  scale = eWidth / (eWidth + chamfer);
  translate([0,0,-.001])
  linear_extrude(chamfer+.002, scale=scale)
  translate([-eWidth/2-chamfer/2,-eWidth/2-chamfer/2])
  square(eWidth+chamfer);

  translate([0,0,chamfer])
  linear_extrude(eDepth-chamfer)
  translate([-eWidth/2,-eWidth/2])
  square(eWidth);
}

// the tenon is the male part... union this
module tenon(width, depth, slop=0, chamfer=1) {
  eWidth = width-slop; // effective width
  eDepth = depth-slop;
  linear_extrude(eDepth-chamfer + .001)
  translate([-eWidth/2,-eWidth/2])
  square(eWidth);
  
  scale = (eWidth - chamfer) / eWidth;
  translate([0,0,eDepth-chamfer])
  linear_extrude(chamfer, scale=scale)
  translate([-eWidth/2,-eWidth/2])
  square(eWidth);
}