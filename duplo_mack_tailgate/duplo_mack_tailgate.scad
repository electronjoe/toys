DOOR_OUTER_WIDTH = 69.3;
FLOOR_TO_OUTER_HEIGHT = 58.17;
GATE_MATERIAL_HEIGHT = 2.0;
FLOOR_MATERIAL_HEIGHT = 3.85;

SIDE_CLIP_PETRUSION = 1.3;
SIDE_CLIP_PETRUSION_DEPTH = 2.0;
SIDE_CLIP_FROM_FLOOR = 40.0;
SIDE_CLIP_HEIGHT = 9.9;


// The ramp attachment
RAMP_ATTACH_DIAMETER = 2.15;
TAILGET_EDGE_TO_WALL = 9.1;
TAILGATE_EDGE_TO_INNER_ATTACHMENT= 5.45;
ATTACH_OFFSET_OUTER_WALL = 19.0;
ATTCH_LENGTH = 11.0;
RECESS_HEIGHT = FLOOR_MATERIAL_HEIGHT - GATE_MATERIAL_HEIGHT;
ATTACH_DISTANCE_FROM_RAMP = -TAILGET_EDGE_TO_WALL + TAILGATE_EDGE_TO_INNER_ATTACHMENT - RAMP_ATTACH_DIAMETER/2 + 1.5;


module latch() {
    difference() {
        translate([0.2,0,0])
            hull() {
                cylinder(h=SIDE_CLIP_HEIGHT, r=0.2, $fn = 20);
                translate([0,GATE_MATERIAL_HEIGHT,0])
                    cylinder(h=SIDE_CLIP_HEIGHT, r=0.2, $fn = 20);
                translate([1.0,GATE_MATERIAL_HEIGHT + SIDE_CLIP_PETRUSION_DEPTH * 2,0])
                    cylinder(h=SIDE_CLIP_HEIGHT, r=0.2, $fn = 20);
                translate([GATE_MATERIAL_HEIGHT*1.25,GATE_MATERIAL_HEIGHT+1.0,0])
                    cylinder(h=SIDE_CLIP_HEIGHT, r=0.2, $fn = 20);
            }
        translate([0,GATE_MATERIAL_HEIGHT+1.3,-0.1])
            cylinder(h=12.0,r=SIDE_CLIP_PETRUSION,$fn=20);
    }
}

module main_door() {
    hull() {
        cube([DOOR_OUTER_WIDTH,GATE_MATERIAL_HEIGHT,FLOOR_TO_OUTER_HEIGHT]);
        translate([ATTCH_LENGTH/2,ATTACH_DISTANCE_FROM_RAMP+0.46, 5])
            rotate([0,90,0])
                cylinder(h = DOOR_OUTER_WIDTH-ATTCH_LENGTH, r = RAMP_ATTACH_DIAMETER / 2.0, $fn = 20);
    }
    
    // Side attachments
    translate([DOOR_OUTER_WIDTH, 0, SIDE_CLIP_FROM_FLOOR])
        latch();
    translate([0, 0, SIDE_CLIP_FROM_FLOOR+SIDE_CLIP_HEIGHT])
        rotate([0,180,0]) latch();
    
    // Ramp attachment
    translate([ATTACH_OFFSET_OUTER_WALL-5.0,0,0]) ramp_attach();
    translate([DOOR_OUTER_WIDTH-ATTACH_OFFSET_OUTER_WALL-ATTCH_LENGTH,0,0])
        ramp_attach();
}

module ramp_attach() {        
    translate([0, ATTACH_DISTANCE_FROM_RAMP, -RECESS_HEIGHT])
        rotate([0,90,0])
            cylinder(h = ATTCH_LENGTH, r = RAMP_ATTACH_DIAMETER / 2.0, $fn = 20);
    
    hull() {
        translate([0,ATTACH_DISTANCE_FROM_RAMP, -RECESS_HEIGHT])
            rotate([0,90,0])
                cylinder(h = 4, r = RAMP_ATTACH_DIAMETER / 2.0, $fn = 20);
        translate([0,0, -ATTACH_DISTANCE_FROM_RAMP/2 - 0.9])
            rotate([0,90,0])
                cylinder(h = 4, r = RAMP_ATTACH_DIAMETER / 2.0, $fn = 20);
    }
    hull() {
        translate([ATTCH_LENGTH,ATTACH_DISTANCE_FROM_RAMP, -RECESS_HEIGHT])
            rotate([0,90,0])
                cylinder(h = 4, r = RAMP_ATTACH_DIAMETER / 2.0, $fn = 20);
        translate([ATTCH_LENGTH,0, -ATTACH_DISTANCE_FROM_RAMP/2 - 0.9])
            rotate([0,90,0])
                cylinder(h = 4, r = RAMP_ATTACH_DIAMETER / 2.0, $fn = 20);
    }
}

difference() {
    translate([0,0,4.1]) rotate([94.1,0,0]) main_door();
    translate([-10,-90,-5]) cube([100,100,5]);
}

// For test
//#translate([ATTACH_OFFSET_OUTER_WALL,-4.35,-RECESS_HEIGHT]) cube([5,2.25,3]);
//#translate([44.5,-4.35,-RECESS_HEIGHT]) cube([5,2.25,3]);
