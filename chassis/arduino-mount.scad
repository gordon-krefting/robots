$fn=32;

slop = 1.5;
9vLength = 45.5  + slop;
9vHeight = 18    + slop;
9vWidth  = 25.75 + slop;

clipDepth = 10;
clipExtra = 1.5;

wallThickness = 2;

platformWidth  = 9vWidth + wallThickness* 2;
platformLength = 9vLength + wallThickness + clipDepth;
platformHeight = 9vHeight + wallThickness * 2;

slotWidth = 5.4;
slotOffset = 15;
slotLength = slotOffset + slotWidth;

slotYspacing = 16;
slotXspacing = 27;

arduinoWidth = 53.3;
arduinoLength = 68.6;

*intersection() {
  translate([5,0,0])
  cube([52.5,33,25]);
  union() {
    batteryPlatform();
    arduinoPlatform();
  }
}


batteryPlatform();
arduinoPlatform();




module batteryPlatform() {

  difference() {
    union () {
      cube([platformLength,platformWidth,platformHeight]);
      translate([0,-10,0])
      cube([platformLength,platformWidth+20,2]);
    }
    translate([-.001 + clipDepth,wallThickness,wallThickness])
    cube([9vLength,9vWidth,9vHeight]);
    
    o = 4;
    translate([platformLength-9vLength,-o,o])
    cube([9vLength-o,platformWidth + o*2,platformHeight-o*2]);

    translate([platformLength-9vLength,o,o])
    cube([9vLength-o,platformWidth - o*2,platformHeight+o]);


    union () {
    translate([
      -.001 + clipDepth-1,
      wallThickness-clipExtra/2,
      wallThickness+clipExtra+.5
    ])
    cube([1+.001,9vWidth+clipExtra,9vHeight+clipExtra-2.75]);
    
    translate([
      -.001,
      wallThickness-clipExtra/2,
      wallThickness-clipExtra/2
    ])
    cube([clipDepth-1+.001,9vWidth+clipExtra,9vHeight+clipExtra]);
    }
  }

  translate([
    platformLength/2 - (slotLength+slotXspacing)/2 + slotWidth/2,
    platformWidth/2 - (slotWidth+slotYspacing)/2 + slotWidth/2,
    0
  ])
  for (x = [0:1])
  for (y = [0:1])
  translate([27*x,16*y,0])
  slot();

}



module arduinoPlatform() {
  translate([
      -5,
      -(arduinoWidth-platformWidth)/2,
      platformHeight-wallThickness+clipExtra
    ]) {
    difference() {
      linear_extrude(11)
      offset(2.5)
      arduinoShape();

      translate([0,0,2.001])
      linear_extrude(10)
      offset(.5)
      arduinoShape();
      
      translate([12,13,-.001])
      linear_extrude(3)
      square([50,28]);

      translate([-3,1.5,2])
      cube([4,43,10]);
    }
    r = 3.2/2-.2;

    for (m = [0:1])
    linear_extrude(6-m*2) {
      translate([15.3,50.4])
      circle(r + m);
      translate([14,2.5])
      circle(r + m);
      translate([66.1,7.6])
      circle(r + m);
      translate([66.1,35.5])
      circle(r + m);
    }
  }
}


module arduinoShape() {
  polygon([
    [0,0],
    [0,arduinoWidth],
    [arduinoLength,arduinoWidth],
    [arduinoLength,0]
  ]);
}






*intersection() {
  translate([-2,-2,-1.5])
  cube([76,60,5]);
  mount();
}

*mount();




module mount() {

  translate([0,0,23]) {
    difference() {
      linear_extrude(8)
      offset(2.5)
      arduinoShape();

      translate([0,0,2.001])
      linear_extrude(7)
      offset(.5)
      arduinoShape();
      
      translate([3,3,-.001])
      linear_extrude(3)
      square([63,48]);

      translate([-3,1.5,2])
      cube([4,43,10]);
    }
    r = 3.2/2-.2;

    for (m = [0:1])
    linear_extrude(6-m*2) {
      translate([15.3,50.4])
      circle(r + m);
      translate([14,2.5])
      circle(r + m);
      translate([66.1,7.6])
      circle(r + m);
      translate([66.1,35.5])
      circle(r + m);
    }
  }

  for (i = [16.5:16:34]) {
    for (j = [5:27:45]) {
      if ((j > 110 && i > 30) || j < 110)
      translate([j+7,i+2,-.1])
      slot();
    }
  }

  difference() {
    linear_extrude(23)
    offset(2.5)
    arduinoShape();

    translate([0,0,1.501])
    linear_extrude(22)
    offset(.5)
    arduinoShape();
    
    translate([-3,3,5])
    linear_extrude(20)
    square([78,47.5]);

    translate([2,-3,5])
    linear_extrude(20)
    square([65,59.5]);
    
    l = 20;
    d = 15;
    for (x = [0:2])
    for (y = [0:2]) {
      translate([x*(l+3)+1, y*(d+3) + 1,-.001])
      linear_extrude(3)
      square([l,d]);
    }

  }



}

// x spacing: 27
// y spacing: 16
module slotX() {
  translate([0,0,-2])
  hull() {
    translate([15,0,0])
    cylinder(h=2,r=2.5);
    cylinder(h=2,r=2.5);
  }
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


