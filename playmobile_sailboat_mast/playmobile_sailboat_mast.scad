/*
 * A replacement mast and boom for the Playmobile Sailboat.
 */

// Base parameters
TOP_WIDTH = 14.0;
BASE_WIDTH = 13.65;
HEIGHT = 16.6;
THICKNESS = 2.0;
NOTCH_DEPTH = 1.5;
TOP_PLATE_WIDTH = 2.75;
TOP_PLATE_DIAMETER = 17.0;

// The cone segment and mast
CONE_HEIGHT = 30;
MAST_DIAMETER = 6.1;
MAST_HEIGHT = 10.25 * 25.4;  // WAG

// Boom on Mast
TOP_BOOM_LATCH_HEIGHT = 68.75;
BOOM_LATCH_HEIGHT = 9.25;
BOOM_LATCH_INNER_HEIGHT = 4.9;
BOOM_LATCH_DIAMETER = 3.25;
BOOM_LATCH_OFFSET_FROM_MAST = 11.0;

// Sail attachments on mast
SAIL_ATTACH_WIDTH = 2.2;
SAIL_ATTACH_HEIGHT = 5.3;
SAIL_ATTACH_DEPTH = 5.0;
SAIL_ATTACH_HOLE_DIAMETER = 1.5;
TOP_BOOM_TO_FIRST_ATTACH = 9.0;

module sail_attachment() {
    difference() {
        cube([SAIL_ATTACH_DEPTH, SAIL_ATTACH_WIDTH, SAIL_ATTACH_HEIGHT]);
        translate([SAIL_ATTACH_WIDTH+1,
            -0.1,
            SAIL_ATTACH_HEIGHT/2])
            rotate([-90,0,0])
                cylinder(h = SAIL_ATTACH_WIDTH + 0.2,
                    r = SAIL_ATTACH_HOLE_DIAMETER/2,
                    $fn = 20);
    }
}

module sail_attachments() {
    sail_attachment();
    translate([0,0, 20.2-SAIL_ATTACH_HEIGHT]) sail_attachment();
    translate([0,0, 35.0-SAIL_ATTACH_HEIGHT]) sail_attachment();
    translate([0,0, 49.3-SAIL_ATTACH_HEIGHT]) sail_attachment();
    translate([0,0, 65.0-SAIL_ATTACH_HEIGHT]) sail_attachment();
    translate([0,0, 79.8-SAIL_ATTACH_HEIGHT]) sail_attachment();
    translate([0,0, 94.6-SAIL_ATTACH_HEIGHT]) sail_attachment();
    translate([0,0,109.7-SAIL_ATTACH_HEIGHT]) sail_attachment();
    translate([0,0,124.6-SAIL_ATTACH_HEIGHT]) sail_attachment();
    translate([0,0,139.3-SAIL_ATTACH_HEIGHT]) sail_attachment();
    translate([0,0, 35.0-SAIL_ATTACH_HEIGHT+125.2]) sail_attachment();
    translate([0,0, 35.0-SAIL_ATTACH_HEIGHT+140.0]) sail_attachment();
}

module base_fin() {
    hull() {
        translate([0,0,-BASE_WIDTH/2])
            cylinder(h=BASE_WIDTH, r=1.0, $fn = 20);
        translate([HEIGHT-1.0,0,-TOP_WIDTH/2])
            cylinder(h=TOP_WIDTH, r=1.0, $fn = 20);
    }
}

module base() {
    base_fin();
    rotate([90,0,0]) base_fin();
    translate([HEIGHT-1.0,0,-TOP_WIDTH/2])
            cylinder(h=TOP_WIDTH+NOTCH_DEPTH, r=1.0, $fn = 20);
    translate([HEIGHT-1.0,0,0])
        rotate([0,90,0]) cylinder(h=TOP_PLATE_WIDTH, r=TOP_PLATE_DIAMETER/2);
    translate([HEIGHT-1+TOP_PLATE_WIDTH,0,0]) rotate([0,90,0])
        cylinder(h=CONE_HEIGHT, r1=TOP_PLATE_DIAMETER/2, r2=MAST_DIAMETER/2);
}

module boom_attach() {
    translate([0,-BOOM_LATCH_DIAMETER/2,0]) difference() {
        cube([
            BOOM_LATCH_OFFSET_FROM_MAST-MAST_DIAMETER/2,
            BOOM_LATCH_DIAMETER,
            BOOM_LATCH_HEIGHT
        ]);
        translate([0,-0.1,(BOOM_LATCH_HEIGHT-BOOM_LATCH_INNER_HEIGHT)/2])
            cube([
                BOOM_LATCH_OFFSET_FROM_MAST-MAST_DIAMETER/2 + 0.2,
                BOOM_LATCH_DIAMETER + 0.2,
                BOOM_LATCH_INNER_HEIGHT
            ]);
    }
    translate([
        BOOM_LATCH_OFFSET_FROM_MAST-MAST_DIAMETER/2-BOOM_LATCH_DIAMETER/2,
        0,
        (BOOM_LATCH_HEIGHT-BOOM_LATCH_INNER_HEIGHT)/2
    ])
        cylinder(h=BOOM_LATCH_INNER_HEIGHT, r=BOOM_LATCH_DIAMETER/2, $fn = 20);
}

module mast () {
    cylinder(h=MAST_HEIGHT, r=MAST_DIAMETER/2, $fn = 20);
    translate([0,0,TOP_BOOM_LATCH_HEIGHT-BOOM_LATCH_HEIGHT]) boom_attach();
    delta = (BOOM_LATCH_HEIGHT - BOOM_LATCH_INNER_HEIGHT) / 2;
    translate([MAST_DIAMETER/2-1,
        -SAIL_ATTACH_WIDTH/2,
        TOP_BOOM_LATCH_HEIGHT-delta-SAIL_ATTACH_HEIGHT/2+TOP_BOOM_TO_FIRST_ATTACH])
            sail_attachments();
}

rotate([90,0,0]) union() {
    rotate([0,90,0]) mast();
    base();
}
//translate([0,0,0]) boom_attach();
//translate([10,0,0]) sail_attachments();