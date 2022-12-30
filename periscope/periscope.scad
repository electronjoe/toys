include <BOSL2/std.scad>
include <BOSL2/hull.scad>

SQRT_2 = 1.414213;

MIRROR_EDGE = 1.5 * 25.4;
TOLERANCE = 1.0;
MIRROR_THICK = 2.0;
WALL = 2.0;
WIDTH = MIRROR_EDGE + TOLERANCE*2 + WALL*2;
DEPTH = MIRROR_EDGE / SQRT_2 + TOLERANCE*2 + WALL*2;
HEIGHT = 140;

MIRROR_X_Z = MIRROR_EDGE / SQRT_2;

module mirror_cutout() {
    hull() {
        rotate([45,0,0]) cube([MIRROR_EDGE,MIRROR_EDGE,MIRROR_THICK]);
        translate([0,-30,0])
            rotate([45,0,0]) cube([MIRROR_EDGE,MIRROR_EDGE,MIRROR_THICK]);
    }
}

module mirrors() {
    rotate([45,0,0]) cube([MIRROR_EDGE,MIRROR_EDGE,MIRROR_THICK]);
    translate([0,0,HEIGHT-MIRROR_EDGE / SQRT_2])
        rotate([45,0,0]) cube([MIRROR_EDGE,MIRROR_EDGE,MIRROR_THICK]);
}

module mirror_supports() {
    rotate([45,0,0]) cube([MIRROR_EDGE+2*TOLERANCE,MIRROR_EDGE+2*TOLERANCE,MIRROR_THICK]);
    translate([0,0,HEIGHT-MIRROR_EDGE / SQRT_2 - TOLERANCE*2-1])
        rotate([45,0,0]) cube([MIRROR_EDGE+2*TOLERANCE,MIRROR_EDGE+2*TOLERANCE,MIRROR_THICK]);
}


module tube() {
    difference() {
        rect_tube(size=[WIDTH, DEPTH], wall=2, chamfer=1,
                  h=HEIGHT, anchor=[-1,-1,-1], orient=TOP);
        translate([WALL+TOLERANCE,2,-0.1]) mirror_cutout();
        translate([WIDTH - WALL - TOLERANCE,MIRROR_X_Z+7,HEIGHT+0.1])
            rotate([0,180,0]) mirror_cutout();
    }
}
translate([WALL, WALL+TOLERANCE, 0]) mirror_supports();
//translate([WALL+TOLERANCE, WALL+TOLERANCE+1, 0]) mirrors();
tube();

translate([10,0,70]) 
    rotate([90,0,0]) linear_extrude(height = 0.5) {
        text("kai", font = "Liberation Sans:style=Bold Italic");
    }