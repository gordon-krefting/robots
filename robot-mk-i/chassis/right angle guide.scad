// 141.06 mm separation
sep = 142.25;
length = 150;


difference() {

rotate([0,0,90])
  union() {
    for (s = [0:1])
    mirror([0,s*1,0])
    translate([0,sep/2-2,-1])
    rotate([0,-90,0])
    linear_extrude(length)
    polygon([
      [0,0],[0,2],[2,2],[2,5],[0,5],[0,7],[-4,5.5],[-4,1.5],[0,0]
    ]);
    
    translate([-50,-(sep+6)/2,0])
    cube([10,sep+6,6]);

    translate([-100,-(sep+6)/2,0])
    cube([6,sep+6,16]);

    for (s = [0:1])
    mirror([0,s*1,0])
    translate([-100,.01,0])
    for (i = [0:2])
    translate([0,i*((sep-2)/4),0])
    cube([60,4,16]);

  }

  union() {
    translate([0,-40,3])
    rotate([76,0,0])
    for (s = [0:1])
    mirror([s*1,0,0])
    cube([80,20,70]);

    translate([0,-200,0])
    for (s = [0:1])
    mirror([s*1,0,0])
    cube([80,100,70]);

    #
    translate([0,-101,0])
    for (s = [0:1])
    mirror([s*1,0,0])
    cube([1.5,10,30]);

  }



}