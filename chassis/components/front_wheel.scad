wheelMountSizeX=43;
wheelMountSizeY=37.5;
wheelMountThickness=2.5;
holeDiameter = 5;
holeOffsetX  = 12.3 + 2;
holeOffsetY  = 9.35 + 2;

boltProtrusion = 4;

wheelDiameter  = 24.5;
wheelThickness = 12.5;

overallHeight  = 33.5;

translate([0,100,0])
front_wheel();
front_wheel_well();

// The size calc here sucks! Should do this with a rotate extrude
module front_wheel_well() {
  front_wheel_mount();
  color("silver")
  translate([0,0,-overallHeight-wheelMountThickness])
  cylinder(h=overallHeight, r=(wheelMountSizeX + wheelDiameter/2)/2 + 1);
  //echo((wheelMountSizeX + wheelDiameter/2)/2 + 1);
}

module front_wheel() {
  front_wheel_mount();

  color("DodgerBlue")
  translate([-wheelMountSizeX/2,wheelThickness/2,-overallHeight+wheelDiameter/2])
  rotate([90,0,0])
  cylinder(h=wheelThickness, r=wheelDiameter/2);
 
  color("silver")
  translate([0,-wheelThickness/2 - 5/2,0])
  rotate([-90,0,0])
  linear_extrude(wheelThickness + 5)
  polygon(points=[
    [-wheelMountSizeX/2,0],
    [-wheelMountSizeX/2,overallHeight-wheelDiameter/2],
    [wheelMountSizeX/2,0]
  ]);

}

module front_wheel_mount() {
  translate([0,0,-wheelMountThickness]) {
    color("silver")
    linear_extrude(height = wheelMountThickness)
    square([wheelMountSizeX, wheelMountSizeY], center=true);

    color("silver",.4)
    for (m = [0:1]) {
      mirror([m,0,0])
      for (a = [0:180:180]) {
        rotate([0,0,a])
        translate([holeOffsetX,holeOffsetY,wheelMountThickness])
        cylinder(h=boltProtrusion,r=holeDiameter/2);
      }
    }
  }  
}