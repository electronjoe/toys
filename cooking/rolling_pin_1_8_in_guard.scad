include <BOSL2/std.scad>
include <BOSL2/shapes3d.scad>

INCH_TO_MM = 25.4;
ROLLING_PIN_OUTER_DIAMETER_IN = 2.3;
CLEARANCE_MM = 1.0;
DOUGH_THICKNESS_IN = 1.0/8.0;

TUBE_ID = ROLLING_PIN_OUTER_DIAMETER_IN*INCH_TO_MM + CLEARANCE_MM;
TUBE_OD = TUBE_ID + 2.0 * DOUGH_THICKNESS_IN * INCH_TO_MM;
tube(od=TUBE_OD, id = TUBE_ID, h=10, $fn=200);