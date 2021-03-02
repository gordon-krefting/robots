use <pd-gears/pd-gears.scad>;
use <scad-parts/sg90/sg90.scad>

$fn=96;

base_1();

translate([0,0,strut_t+base_t])
base_2();

translate([0,0,strut_t+base_t*2 + servo_v_offset])
base_3();

strut_preview();

finger_preview();

servo_preview();

/***************************************************************
   CONSTANTS
***************************************************************/

slop = .3;
pin_diameter = 5;
peg_diameter = 2.5;

base_t = 2;

strut_pin_spacing = 15;
strut_length = 35;
strut_t = 5;
strut_wall_t = 2;
strut_spacing = 20;

    

/***************************************************************
   PRINTABLES
***************************************************************/


*preview();
module preview() {
  print_base_1();
  translate([70,0])
  print_base_2();
  translate([120,0])
  print_base_3();
  
  translate([0, -50])
  print_strut();
  translate([50, -50])
  print_strut_gear();
  translate([100, -50])
  print_strut_gear_and_arm();
  
  translate([0,-80])
  print_left_finger_1();
  translate([60,-80])
  print_left_finger_2();
  translate([180,-80])
  print_right_finger_1();
  translate([230,-80])
  print_right_finger_2();
}

module print_base_1() {
  base_1();
}
module print_base_2() {
  base_2();
}
module print_base_3() {
  base_3();
}

module print_strut() {
  strut(false, false);
}

module print_strut_gear() {
  strut(true, false);
}

module print_strut_gear_and_arm() {
  strut(true, true);
}

module print_left_finger_1() {
  finger_1();
}
module print_left_finger_2() {
  finger_2();
}
module print_right_finger_1() {
  mirror([1, 0, 0])
  finger_1();
}
module print_right_finger_2() {
  mirror([1, 0, 0])
  finger_2();
}




/***************************************************************
   BASE
***************************************************************/

base_points = [[8, 16, 0], [47, 0, 0], [8, -16, 0]];

base_1_pin_locations = [
  [6, 19],  [40, 8],  [40 + strut_pin_spacing, 8],
  [6, -19], [40, -8], [40 + strut_pin_spacing, -8],
  [26,-16]
];

base_2_pin_locations = [
  [30,15],  [30,-15],  [60,0]
];

base_1_strut_pins = [base_1_pin_locations[1],base_1_pin_locations[2]];

module base_1() {
  linear_extrude(base_t)
  base_template();
  
  for (p = base_1_pin_locations) {
    translate([p.x, p.y, base_t])
    if (p == base_1_pin_locations[4]) {
      cylinder(3, d=pin_diameter-slop);
    } else {
      pin(strut_t);
    }
  }
}

module base_2() {
  linear_extrude(base_t)
  difference() {
    base_template();
    for (p = base_1_pin_locations) {
      translate([p.x,p.y])
      if (p != base_1_pin_locations[4]) {
        peg_circle();
      } else {
        hull() {
          circle(d=14);
          translate([16,-25,0])
          circle(d=23);
        }
      }
    }
  }
  for (p = base_2_pin_locations) {
  translate([p.x, p.y, base_t])
    pin(servo_v_offset);
  }

}

module base_3() {
  linear_extrude(base_t)
  difference() {
    intersection() {
      base_template();
      translate([123,0])
      circle(100);
    }
    for (p = base_2_pin_locations) {
      translate([p.x,p.y])
      peg_circle();
    }
    translate([33.5,-14,0])
    square([13,23.5]);

    translate([40,-16.2])
    circle(1.5);
    
    translate([40,11.6])
    circle(1.5);

  }  
}

module base_template() {
  difference() {
    hull() {
      translate(base_points[0]) circle(9);
      translate(base_points[1]) circle(18);
      translate(base_points[2]) circle(9);
    }
    translate([18,0,0]) circle(14);
    translate([49,0,0]) circle(7);
  }
}

/***************************************************************
   STRUT
***************************************************************/

module strut(gear = false, arm = false) {
  if (!gear && !arm) {
    linear_extrude(strut_t)
    strut_template();
  } else if (arm && gear) {
    difference() {
      union () {
        linear_extrude(strut_t, convexity=10)
        strut_template(false, true);
        strut_gear();
      }
      strut_arm_cutout();
    }
  } else if (gear) {
    union () {
      linear_extrude(strut_t)
      strut_template(true, false);
      strut_gear();
    }
  } else {
    difference () {
      linear_extrude(strut_t, convexity=10)
      strut_template(false, true);
      strut_arm_cutout();
    }
  }
}

module strut_gear() {
  intersection() {
    gear(3.8, 13, strut_t, pin_diameter+slop);
    translate([0,0,5])
    scale([1, 1, 1])
    sphere(9.7);
  }
}
module strut_arm_cutout() {
  translate([0, 0, strut_t+.001-1.6])
  rotate([0, 0, 0])
  scale(1.15)
  sg90_arm1_negative();
}

module strut_template(gear = false, arm = false) {
  difference() {
    hull() {
      circle(pin_diameter/2 + strut_wall_t);
      translate([strut_length, 0, 0])
      circle(pin_diameter/2 + strut_wall_t);
    }
    hull() {
      circle(pin_diameter/2);
      translate([strut_length, 0, 0])
      circle(pin_diameter/2);
    }
  }
  for (i = [0:1])
  translate([strut_length*i, 0, 0])
  difference() {
    union () {
      circle(pin_diameter/2 + strut_wall_t);
    }
    circle(pin_diameter/2);
  }
  if (arm) {
    translate([pin_diameter/2, -(pin_diameter/2 + strut_wall_t)])
    square([strut_length/2,pin_diameter + strut_wall_t*2]);
    translate([strut_length/2, 0, 0])
    circle(pin_diameter/2 + strut_wall_t);
  }

 
}

strut_angle_open   = 80;
strut_angle_closed = 40;

module strut_preview() {
  for (pin = base_1_strut_pins) {
    for (i = [-1,1])
    translate([pin.x, pin.y*i, base_t])
    rotate([0, 0, strut_angle($t)*i])
    strut(
      gear = pin == base_1_strut_pins[0], // only include a gear on the first set
      arm  = (pin == base_1_strut_pins[0]) && i == -1 // include a spot for the servo arm
    );
  }
}


function strut_angle(t) = 
  let (range = strut_angle_open - strut_angle_closed)
  (t > .5) ?
    strut_angle_closed + range*(1-t)*2 :
    strut_angle_closed + range*t*2;

function end_pin_pos(v, t) =
  let (angle = strut_angle(t))
  [v.x + cos(angle) * strut_length, v.y + sin(angle) * strut_length];


/***************************************************************
   FINGER
***************************************************************/

// 2 of the points that define the finger come from the strut positions
// these are the other 2
finger_points = [
  [0, 0, 0], [strut_pin_spacing, 0, 0], [50, -25.5, 0], [20, -25.6, 0]
];
finger_circle_r =  pin_diameter/2 + strut_wall_t;


module finger_1() {
  linear_extrude(base_t)
  finger_template();
  linear_extrude(base_t + strut_t)
  hull() {
    translate(finger_points[2])
    circle(finger_circle_r);
    translate(finger_points[3])
    circle(finger_circle_r);
  }
  for (p = finger_points)
  translate(p)
  pin(base_t + strut_t);
}

module finger_2() {
  linear_extrude(base_t) 
  difference() {
    finger_template();
    for (p = finger_points)
    translate(p)
    peg_circle();
  }
}

module finger_template() {
  cutout_points = [
    [5, -5], [16, -18], [36, -18], [18,-5]
  ];
  difference() {
    hull() 
    for (p = finger_points)
    translate(p)
    circle(finger_circle_r);
    hull() 
    for (p = cutout_points)
    translate(p)
    circle(2);
  }
}

module finger_preview() {
  v = end_pin_pos(base_1_strut_pins[0], $t);
  for (i = [-1,1])
  translate([v.x,v.y*i,0])
  mirror([0,(i==-1)?1:0,0])
  union () {
    finger_1();
    translate([0,0,base_t + strut_t + slop])
    finger_2();
  }
}

/***************************************************************
   SERVO
***************************************************************/
module servo_preview() {
  translate([
    base_1_strut_pins[0].x,
    base_1_strut_pins[0].y*-1,
    base_t + strut_t - 1.6
  ])
  rotate(-strut_angle($t))
  sg90_arm1();
  translate([base_1_strut_pins[0].x,-base_1_strut_pins[0].y,base_t+strut_t + 3.5])
  rotate([180,0,-90])
  sg90(true);
}



/***************************************************************
   MISC
***************************************************************/

module pin(h) {
  cylinder(h = h, d = pin_diameter-slop);
  cylinder(h = h + base_t + slop, d = peg_diameter-slop);
}

module peg_circle() circle(d=peg_diameter+slop);

