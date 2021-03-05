$fn=192;

base_h = 6;
base_t = 3;
pin_h = 4;
large_pin_d = 3.5;
small_pin_d = 2;

perfboard_h = 37;
pca_h = perfboard_h - 2;

leg_t = 5;


boardpoints = [
    [0,0], [0,83], [62.5,83], [60.5, 0]
];
pcapoints = [
    [71, 29], [71, 48], [126.5, 48], [126.6, 29]
];


print_support();

module print_support() {

    for (p = boardpoints) {
        translate(p)
        leg(leg_t, perfboard_h, large_pin_d);
    }
    for (p = pcapoints) {
        translate(p)
        leg(leg_t, pca_h, small_pin_d);
    }

    base_wall(boardpoints[0], boardpoints[1]);
    base_wall(boardpoints[1], boardpoints[2]);
    base_wall(boardpoints[2], pcapoints[1]);
    base_wall(pcapoints[0], pcapoints[1]);
    base_wall(pcapoints[1], pcapoints[2]);
    base_wall(pcapoints[2], pcapoints[3]);
    base_wall(pcapoints[3], pcapoints[0]);
    base_wall(pcapoints[0], boardpoints[3]);
    base_wall(boardpoints[3], boardpoints[0]);
    
    translate([84, 14, 3])
    9v_box();
    
    translate([-1.5, 11, 3])
    7v_box();
    
    translate([-5.5, 10, 0])
    screw_hole();
    translate([-5.5, 70, 0])
    screw_hole();
    translate([132, 38, 0])
    screw_hole();
    
}

module print_9v_box() {
    9v_box();
}

module 9v_box() {
    battery_box([27, 47, 2]);
}

module print_7v_box() {
    7v_box();
}

module 7v_box() {
    battery_box([64, 59, 2]);
}

module battery_box(dim) {
    t = 3;
    linear_extrude(t + dim.z)
    difference() {
        square([dim.x + t, dim.y + t]);
        translate([t/2, t/2])
        square([dim.x, dim.y]);
    }
    linear_extrude(t*2 + dim.z)
    difference() {
        square([dim.x + t, dim.y + t]);
        translate([t/2, t/2])
        square([dim.x, dim.y+10]);
    }
    linear_extrude(t)
    difference() {
        square([dim.x + t, dim.y + t]);
        translate([t*1.5, t*1.5])
        square([dim.x - t*2, dim.y - t*2]);
    }
}

module base_wall(p1, p2) {
    linear_extrude(base_h)
    hull() {
        translate(p1)
        circle(base_t/2);
        translate(p2)
        circle(base_t/2);
    }
}

module leg(t, h, pin_d) {
    rotate_extrude(angle = 360)
    difference() {
        square([t,h]);
        translate([h*4 + t/2, h/2])
        circle(r=h*4);
    }
    translate([0, 0, h])
    cylinder(pin_h, d1 = pin_d, d2 = pin_d - 1.5);
}

module screw_hole() {
    linear_extrude(2)
    difference() {
        circle(5.5);
        circle(2.8);
    }
}