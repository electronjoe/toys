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
MAST_HEIGHT_OFFSET = 22;
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

sail_attach_holes = [
    SAIL_ATTACH_HEIGHT/2, 
    20.2-SAIL_ATTACH_HEIGHT/2,
    35.0-SAIL_ATTACH_HEIGHT/2,
    49.3-SAIL_ATTACH_HEIGHT/2,
    65.0-SAIL_ATTACH_HEIGHT/2,
    79.8-SAIL_ATTACH_HEIGHT/2,
    94.6-SAIL_ATTACH_HEIGHT/2,
    109.7-SAIL_ATTACH_HEIGHT/2,
    124.6-SAIL_ATTACH_HEIGHT/2,
    139.3-SAIL_ATTACH_HEIGHT/2,
    109.7-SAIL_ATTACH_HEIGHT/2,
    35.0-SAIL_ATTACH_HEIGHT/2+125.2,
    35.0-SAIL_ATTACH_HEIGHT/2+140.0,
];

module sail_attachments_2() {
    difference() {
        cube([
            SAIL_ATTACH_DEPTH,
            SAIL_ATTACH_WIDTH,
            MAST_HEIGHT-72.92
        ]);
        union() {
            for (idx = [0 : len(sail_attach_holes) - 1]) {
                translate([SAIL_ATTACH_DEPTH - 1.8,-.4,sail_attach_holes[idx]])
                    rotate([-90,0,0])
                        cylinder(h = 3, r = SAIL_ATTACH_HOLE_DIAMETER/2, $fn = 20);
            }
        }
    }
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
    translate([HEIGHT-1.0-NOTCH_DEPTH,-THICKNESS/2,-TOP_WIDTH/2])
            cube([NOTCH_DEPTH, THICKNESS, TOP_WIDTH+NOTCH_DEPTH]);
    translate([HEIGHT-1.0,0,0])
        rotate([0,90,0]) cylinder(h=TOP_PLATE_WIDTH, r=TOP_PLATE_DIAMETER/2);
    translate([HEIGHT-1+TOP_PLATE_WIDTH,0,0]) rotate([0,90,0])
        cylinder(h=CONE_HEIGHT, r1=TOP_PLATE_DIAMETER/2, r2=MAST_DIAMETER/2);
}

module boom_attach() {
    hull() {
        translate([
            MAST_DIAMETER/2-BOOM_LATCH_DIAMETER,
            0,
            (BOOM_LATCH_HEIGHT-BOOM_LATCH_INNER_HEIGHT)/2-15
        ])
            cylinder(h=1, r=BOOM_LATCH_DIAMETER/2);
        translate([
            BOOM_LATCH_OFFSET_FROM_MAST-MAST_DIAMETER/2-BOOM_LATCH_DIAMETER/2,
            0,
            (BOOM_LATCH_HEIGHT-BOOM_LATCH_INNER_HEIGHT)/2-1
        ])
            cylinder(h=1, r=BOOM_LATCH_DIAMETER/2, $fn = 20);
    }
    
    hull() {
        translate([
            BOOM_LATCH_OFFSET_FROM_MAST-MAST_DIAMETER/2-BOOM_LATCH_DIAMETER/2,
            0,
            (BOOM_LATCH_HEIGHT+BOOM_LATCH_INNER_HEIGHT)/2
        ])
            cylinder(h=1, r=BOOM_LATCH_DIAMETER/2, $fn = 20);
        translate([
            MAST_DIAMETER/2-BOOM_LATCH_DIAMETER,
            0,
            (BOOM_LATCH_HEIGHT-BOOM_LATCH_INNER_HEIGHT)/2+20
        ])
            cylinder(h=1, r=BOOM_LATCH_DIAMETER/2);
    }
    
    translate([
        BOOM_LATCH_OFFSET_FROM_MAST-MAST_DIAMETER/2-BOOM_LATCH_DIAMETER/2,
        0,
        (BOOM_LATCH_HEIGHT-BOOM_LATCH_INNER_HEIGHT)/2
    ])
        cylinder(h=BOOM_LATCH_INNER_HEIGHT, r=BOOM_LATCH_DIAMETER/2, $fn = 20);
}

module mast_top () {
    translate([0, 0, MAST_HEIGHT_OFFSET])
        cylinder(h=MAST_HEIGHT-MAST_HEIGHT_OFFSET, r=MAST_DIAMETER/2, $fn = 20);
    translate([0,0,TOP_BOOM_LATCH_HEIGHT-BOOM_LATCH_HEIGHT]) boom_attach();
    delta = (BOOM_LATCH_HEIGHT - BOOM_LATCH_INNER_HEIGHT) / 2;
    translate([MAST_DIAMETER/2-1,
        -SAIL_ATTACH_WIDTH/2,
        TOP_BOOM_LATCH_HEIGHT-delta-SAIL_ATTACH_HEIGHT/2+TOP_BOOM_TO_FIRST_ATTACH])
            sail_attachments_2();
}

module mast_pole_cutout() {
    cylinder(h = 30, r = MAST_DIAMETER/2 + 0.2, $fn = 20);
}

module mast() {
    rotate([90,0,0]) union() {
        //rotate([0,90,0]) mast_top();
        difference() {
            base();
            translate([MAST_HEIGHT_OFFSET,0,0]) rotate([0,90,0]) mast_pole_cutout();
            #translate([45,-5,-5]) cube([10,10,10]);
        }
    }
}

mast();

//intersection() {
//    mast();
//    cut_for_print();
//}
//translate([0,0,0]) boom_attach();
//translate([10,10,0]) sail_attachments_2();