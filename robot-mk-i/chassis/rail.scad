// 141.06 mm separation
sep = 142.3;
length = 20;


//difference() {
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
    
    translate([-10,-(sep+6)/2,0])
    cube([5,sep+6,3]);
  }
//}