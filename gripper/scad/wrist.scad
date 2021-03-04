use <pd-gears/pd-gears.scad>;
use <scad-parts/sg90/sg90.scad>

$fn=48;


base_1();

translate([0, 0, gear_height + base_t])
base_2();

translate([0, 0, gear_height + base_t + servo_v_offset])
base_3();

translate([0,0,base_t]) {
    small_gear();
    translate([gear_spacing,0,0])
    large_gear();
}

servo_preview();

*adaptor();


*preview();

/***************************************************************
   PRINTABLES
***************************************************************/

*preview();
module preview() {
  print_base_1();
  translate([65,0])
  print_base_2();
  translate([130,0])
  print_base_3();
  
  translate([0, -50])
  print_small_gear();
  translate([50, -50])
  print_large_gear();
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

module print_small_gear() {
  small_gear();
}

module print_large_gear() {
  large_gear();
}

module print_adaptor() {
  adaptor();
}



/***************************************************************
   CONSTANTS
***************************************************************/
slop = .3;

base_t = 2;

gear_height = 15;
gear_spacing = 25.7;

pin_diameter = 5;
peg_diameter = 2.5;

servo_v_offset = 9.7;

/***************************************************************
   BASE
***************************************************************/
base_1_pin_locations = [[50, 0],  [6, -12],  [6, 12]];
base_2_pin_locations = [[-8, 0],  [31, -17],  [31, 17]];

module base_1() {
    linear_extrude(base_t)
    difference() {
        union() {
            base_template();
            translate([21,-22])
            circle(4);
            translate([21,22])
            circle(4);
        }
        translate([21,-22])
        circle(1.5);
        translate([21,22])
        circle(1.5);
        translate([11, 0, 0])
        scale([.5, 1, 1])
        circle(12);
        translate([36, 0, 0])
        scale([.5, 1, 1])
        circle(12);
    }
    translate([0, 0, base_t])
    cylinder(2, d = pin_diameter - slop);

    translate([gear_spacing, 0, base_t])
    cylinder(2, d = pin_diameter - slop);
    
    for (p = base_1_pin_locations) {
    translate([p.x, p.y, base_t])
    pin(gear_height);
  }
}

module base_2() {
    linear_extrude(base_t)
    difference() {
        base_template();
        
        circle(d = pin_diameter*2 + slop*2);
        translate([gear_spacing + 6.5, 0, 0])
        scale([1, .6, 1])
        circle(14);
        
        for (p = base_1_pin_locations)
        translate([p.x, p.y, base_t])
        peg_circle();
    }

    for (p = base_2_pin_locations)
    translate([p.x, p.y, base_t])
    pin(servo_v_offset - base_t);

}

module base_3() {
    linear_extrude(base_t)
    difference() {
        base_template();
        
        circle(d = pin_diameter*2 + slop*2);
        
        for (p = base_2_pin_locations)
        translate([p.x, p.y, base_t])
        peg_circle();

        translate([5.4, 0, 0]) {
            translate([14,-13/2,0])
            square([23.5,13]);
            translate([11.8,0])
            circle(1.5);
            translate([40,0])
            circle(1.5);
        }
    }
    
}


module base_template() {
    hull() {
        circle(12);
        translate([gear_spacing, 0, 0])
        circle(21);
        translate(base_1_pin_locations[0])
        circle(5);
    }
}



/***************************************************************
   GEARS
***************************************************************/
tooth_count = 14;

module small_gear() {
    rotate([0,0,0])
    gear_template(tooth_count, 20.5);
    difference() {
        translate([0, 0, gear_height])
        cylinder(h = 35, d = pin_diameter*2);
        
        translate([2, -5, gear_height + 32.001])
        cube(10);

        translate([-12, -5, gear_height + 32.001])
        cube(10);
    }
}

module large_gear() {
    translate([0, 0, gear_height])
    rotate([180, 0, 0])
    difference() {
        union () {
            translate([0, 0, gear_height])
            rotate([180, 0, 0])
            gear_template(tooth_count * 2, 37);
            
            translate([14,0,0])
            scale([1, .6, 1])
            cylinder(gear_height, r = 7);
        }
        
        translate([0,0,2-.001])
        rotate([180,0,0])
        scale([1,1,1.5])
        scale(1.15)
        sg90_arm1_negative();
    }
}

module gear_template(t, roundover_factor) {
    intersection() {
        difference() {
            gear(3.8, t, gear_height, 0);
            translate([0, 0, -.001])
            cylinder(gear_height / 3, d = pin_diameter + slop);
            translate([0, 0, gear_height / 3 - .002])
            cylinder(gear_height / 3, d1 = pin_diameter + slop, d2 = 0);
        }
        translate([0, 0, gear_height / 2])
        scale([1, 1, 1.5])
        sphere(d = roundover_factor);
    }
}

// connects wrist to gripper (14.3-8.9)
module adaptor() {
    cube_dim = [14, 25, 8];
    difference() {
        translate([-cube_dim.x/2, -cube_dim.y/2, 0])
        cube(cube_dim);
        
        translate([0,0,-.001])
        difference() {
            cylinder(h = 4, d = pin_diameter*2 + slop);
            
            translate([2 + slop/2, -5, .001])
            cube(10);

            translate([-12 - slop/2, -5, .001])
            cube(10);
        }
        cube2_dim = [8.9+slop, cube_dim.y + .001, 5+.001];
        translate([-cube2_dim.x/2, -cube2_dim.y/2, 3])
        difference() {
            cube(cube2_dim);
        }
    }
    translate([-2.4, -25/2, 3])
    cube([4.8, 6, 5]);
    translate([-2.4, 25/2-6, 3])
    cube([4.8, 6, 5]);
}



/***************************************************************
   SERVO
***************************************************************/
module servo_preview() {
  translate([gear_spacing,0,base_t + gear_height - 1.5])
  sg90_arm1();
  translate([gear_spacing,0,base_t + gear_height + 3.5])
  rotate([180,0,180])
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

