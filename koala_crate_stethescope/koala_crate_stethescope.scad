HEIGHT = 4.75;

POST_DIAMETER = 6.85;
POST_HOLE_DIAMETER = 7.66;
ELASTIC_DIAMETER = 1.45;

MOUNT_DIAMETER = 25.25;

EAR_PIECE_DIAMETER = 20.7;
MAIN_POLE_X_OFFSET = -27.0;
MAIN_POLE_WIDTH = 12.5;
EAR_PIECE_HEIGHT = 140.0;
EAR_PIECE_X_OFFSET = 9.0;

module ear_piece() {
    hull() {
        cylinder(h = HEIGHT, r = EAR_PIECE_DIAMETER/2.0, $fn = 20);
        translate([MAIN_POLE_X_OFFSET,9,0]) cylinder(h = HEIGHT, r = 6.0, $fn = 20);
    }
}


module assembly() {
    // Ear piece
    translate([EAR_PIECE_X_OFFSET, EAR_PIECE_HEIGHT, 0]) ear_piece();
    
    // Main arm
    hull () {
        translate([
            MAIN_POLE_X_OFFSET + EAR_PIECE_X_OFFSET,
            EAR_PIECE_HEIGHT + 9,
            0
        ])
            cylinder(h = HEIGHT, r = 6.0, $fn = 20);
        translate([
            MAIN_POLE_X_OFFSET + EAR_PIECE_X_OFFSET,
            30,
            0
        ])
            cylinder(h = HEIGHT, r = MAIN_POLE_WIDTH/2.0, $fn = 20);
    }
    
    hull() {
        translate([
            MAIN_POLE_X_OFFSET + EAR_PIECE_X_OFFSET,
            30,
            0
        ])
            cylinder(h = HEIGHT, r = MAIN_POLE_WIDTH/2.0, $fn = 20);
        translate([0,20,0])
            cylinder(h = HEIGHT, r = MAIN_POLE_WIDTH/2.0, $fn = 20);
    }
    
    hull() {
        cylinder(h = HEIGHT, r = MAIN_POLE_WIDTH/2.0, $fn = 20);
        translate([0,20,0])
            cylinder(h = HEIGHT, r = MAIN_POLE_WIDTH/2.0, $fn = 20);
    }
    
    // Mount to base
    cylinder(h = HEIGHT, r = MOUNT_DIAMETER/2.0, $fn = 30);
    
    // Name
    translate([-13,80,HEIGHT])
        rotate([0,0,90])
            linear_extrude(height = 0.5) {
                text("kai", font = "Liberation Sans:style=Bold Italic");
            }
}

// Cut for mounting
module cut_mount() {
    rotate([0,0,45])
        hull() {
            translate([0,0,-1])
                cylinder(h = HEIGHT + 2, r = POST_HOLE_DIAMETER/2.0, $fn = 20);
            translate([0,20,-1])
                cylinder(h = HEIGHT + 2, r = POST_HOLE_DIAMETER/2.0, $fn = 20);
        }
    rotate([0,0,65])
        hull() {
            translate([0,0,-1])
                cylinder(h = HEIGHT + 2, r = POST_HOLE_DIAMETER/2.0, $fn = 20);
            translate([0,20,-1])
                cylinder(h = HEIGHT + 2, r = POST_HOLE_DIAMETER/2.0, $fn = 20);
        }
    // Elastic hole and slot
    rotate([0,0,3])
        union() {
            hull() {
                translate([0,0,-1])
                    cylinder(h = HEIGHT + 2, r = ELASTIC_DIAMETER/2.0, $fn = 20);
                translate([0,20,-1])
                    cylinder(h = HEIGHT + 2, r = ELASTIC_DIAMETER/2.0, $fn = 20);
            }
            translate([0,20,-1])
                cylinder(h = HEIGHT + 2, r = ELASTIC_DIAMETER/2.0+1, $fn = 20);
        }

}

module assembly_cutout() {
    difference() {
        assembly();
        cut_mount();
    }
}

rotate([0,0,0]) assembly_cutout();
//rotate([0,0,135]) assembly_cutout();

// Design Objectives

module objectives() {
    // The post on which we will install
    #translate([0,0,-1]) cylinder(h = HEIGHT + 2.0, r = POST_DIAMETER/2);
    // Ear placement inner-most
    # translate([9,140,-1]) cylinder(h = HEIGHT + 2.0, r = 3);
    // Ear placement outer-most
    # rotate([0,0,45]) translate([9,140,-1]) cylinder(h = HEIGHT + 2.0, r = 3);
}
//objectives();