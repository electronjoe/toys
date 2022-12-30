include <BOSL2/std.scad>
include <BOSL2/walls.scad>

BUCKET_OPEN_ANGLE = 2;

module worm() {
    include <worm_drive.scad>
}

module tread() {
    difference() {
        hull() {
            translate([10,0,0]) cylinder(h = 1.0, r = 1, $fn=20);
            translate([0,0,0]) cylinder(h = 1.0, r = 1, $fn=20);
        };
        translate([.4,0,0.5]) scale([0.9,0.7,0.8]) hull() {
            translate([10,0,0]) cylinder(h = 1.0, r = 1, $fn=20);
            translate([0,0,0]) cylinder(h = 1.0, r = 1, $fn=20);
        };
    };
}

module boiler() {
    translate([0,0,1]) cylinder(h = 1, r = 0.75, center = false, $fn = 20);
    hull() {
        cylinder(h = 1, r1 = 1.5, r2 = 0.75, center = false, $fn = 20);
        translate([-1.5,-1.5,-5]) cube([3,3,5]);
    }
    translate([0,0,-6])
        prismoid(size1=[2,2], size2=[3,3], h=1.0);
}

module treads() {
    // Spinny thingy...
    translate([5,0,0.8]) cylinder(h = 1, r = 2.25, $fn = 20);

    translate ([0,-3,0]) rotate([90,0,0]) tread();
    translate ([0,3,0]) rotate([-90,0,0]) tread();
    hull() {
        translate([3,3,0]) rotate([90,0,0]) cylinder(h = 6.0, r = 0.8, $fn = 20);
        translate([7,3,0]) rotate([90,0,0]) cylinder(h = 6.0, r = 0.8, $fn = 20);
    }
}

module cabin_walls() {
    corrugated_wall(h=5.5, l=9, thick=0.5, strut=0.5, wall=0.3, spin=90,
        anchor=[-1,1,-1]);
    translate([0,6,0])
        corrugated_wall(h=5.5, l=9, thick=0.5, strut=0.5, wall=0.3, spin=90,
        anchor=[1,1,-1]);
    corrugated_wall(h=5.5, l=5.75, thick=0.5, strut=0.5, wall=0.3,
        anchor=[-1,-1,-1]);
    
    // Front support beam
    translate([8.35,3,0])
        cuboid([0.5,0.5,5.5], anchor=[0,0,-1]);
    
    // Coal Chute
    translate([0.5,0.1,0.3]) rotate([10,0,0])
        corrugated_square(length = 1.5, height = 2.5, cor_width = 0.1, cor_depth = 0.5);
}

module boom_cable_attach() {
    rotate([0,45,0]) translate([-0.1, -0.1, -0.4]) cube([0.2,0.2,0.8]);
    translate([0.425,0,0])
        rotate([0,-45,0]) translate([-0.1, -0.1, -0.4]) cube([0.2,0.2,0.8]);
}

module cabin_roof() {
    difference () {
        rotate([90,0,90]) cylinder(h = 8.9, r = 3.5, $fn = 40);
        translate([-5,-6,-8]) cube([15,10,10]);
        translate([1.65,-0.05,3]) boiler();
    }

    // Attachment points for the boom
    translate([1,-2,3]) rotate([25,0,0]) boom_cable_attach();
    translate([1,2,3]) rotate([-25,0,0]) boom_cable_attach();
    
    // Bridging support attempt
    translate([4.65,0,0.5])
        right_triangle([1.5, 1.5, 0.25], anchor=[1,1,0], spin=-90, orient=FRONT);
    translate([6.55,0,0.5])
        right_triangle([1.5, 1.5, 0.25], anchor=[1,1,0], spin=180, orient=FRONT);
    translate([6,0,2])
        cuboid([3,0.25,0.05]);
}

module boiler_cutout() {
    union() {
        translate([1.7,3,6.5]) scale([0.8, 0.8, 0.8]) boiler();
        translate([1.5,2,2]) cube([2,2,2]);
        translate([1.7,3,6]) cylinder(h = 3, r = 0.5, center = false, $fn = 20);
    }
}

module controls() {
    translate([0, -0.5,0]) rotate([0,-15,0]) cube([0.3, 0.2, 2.5]);
    rotate([0,10,0]) cube([0.3, 0.2, 2.5]);
}

module engine() {
    cube([2.5,3,1.5]);
    translate([1,3,1.5]) rotate([90,0,0]) cylinder(h = 1, r = 1, $fn = 20);
    difference() {
        rotate([90,0,0]) cylinder(h = 0.4, r = 1.5, $fn = 30);
        translate([-2,-2,-2]) cube([5,5,2]);
    }
}

module cabin() {
    // Floor
    cube([9,6,0.5]);
    // boom attachment
    translate([9.5,3,0.9]) rotate([0,-45,0]) scale(0.85)
        boom_attach();
    // Walls and chute
    difference() {
        cabin_walls();
        union () {
            translate([2.5,-0.5,0]) cube([1.5,2,5.4]);
            translate([4.5,-0.5,3]) cube([2,2,2]);
            translate([7,-0.5,0]) cube([1.5,2,5.4]);
        }
    }
    
    // Support for front of roof - allows bridging width-wise before roof print
    translate([8.6,0.25,5]) cube([0.4,5.5,0.5]);
    
    translate([0.05,3.05,3.5]) cabin_roof();
    difference() {
        translate([1.7,3,6.5]) color("green", 1.0) boiler();
        boiler_cutout();
    }
    
    translate([8,4.5,0.4]) controls();
    translate([5,1.5,0.4]) engine();
}

module tread_mount_cutout() {
    cube([0.6, 0.6, 1.5]);
    translate([0,1,0]) cube([0.6, 0.6, 1.5]);
    translate([1,0,0]) cube([0.6, 0.6, 1.5]);
    translate([1,1,0]) cube([0.6, 0.6, 1.5]);
}

module corrugated_square(height, length, cor_width, cor_depth) {
    union() {
        for (i = [0:cor_width:length-cor_width]) {
            translate([i,cos(i*360.0/0.75)*cor_width/2,0])
                cube([cor_width, cor_depth, height]);
        }
    }
}

module boom_half() {
    hull() {
        sphere(r = 0.5, $fn = 20);
        translate([8,0.5,0]) sphere(r = 0.5, $fn = 20);
        translate([8,-0.5,0]) sphere(r = 0.5, $fn = 20);
        translate([8,0.5,0.5]) sphere(r = 0.5, $fn = 20);
        translate([8,-0.5,0.5]) sphere(r = 0.5, $fn = 20);
    }
}

module dipper_stick_boom_cutouts() {
    union() {
        // Two cuts to give range of motion to the dipper stick
        rotate([0,35,0]) dipper_stick_hull();
        rotate([0,135,0]) dipper_stick_hull();
    }
}

module boom() {
    difference () {
        union () {
            boom_half();
            translate([16,0,0]) rotate([0,0,180]) boom_half();
        }
        union () {
            translate([8.25,-0.22,0.25]) dipper_stick_boom_cutouts();
            translate([8.25,-0.28,0.25]) dipper_stick_boom_cutouts();
            // A cut out of the top to allow top-lift line.
            translate([16.3,-0.15,-.6]) rotate([0,-60,0]) cube([2,0.3,3]);
            
            // Cut out for attachment to body
            boom_attach();
            
            // Holes for cables to attach to body
            translate([16,-1,0.2]) rotate([-90,0,0])
                cylinder(h = 2, r = 0.1, $fn = 20);
        }
    }
    translate([16.1,-0.15,-.25]) rotate([-90,0,0])
        cylinder(h = 0.3, r = 0.20, $fn = 20);
    translate([10.5,-0.2,0.7]) rotate([0,4,0]) linear_extrude(0.25)
        text("Mary Anne", size = 0.5);
    translate([8.25,0.7,0.25]) rotate([90,0,0])
        cylinder(h=1.5, r=0.19, $fn = 20);
}

module boom_attach() {
    hull() {
        translate([-0.2,-1,0]) rotate([-90,0,0])
            cylinder(h = 2, r = 0.25, $fn = 20);
        translate([-1,-1,0]) rotate([-90,0,0])
            cylinder(h = 2, r = 0.25, $fn = 20);
    }
}

module bucket_hull() {
    difference() {
        translate([0,0,0]) hull() {
            translate([0,0,0]) sphere(r = 0.2, $fn = 20);
            translate([0,0,3]) sphere(r = 0.2, $fn = 20);
            translate([0,3,0]) sphere(r = 0.2, $fn = 20);
            translate([0,3,3]) sphere(r = 0.2, $fn = 20);
            translate([3,0,0]) sphere(r = 0.2, $fn = 20);
            translate([3.5,0,3.5]) sphere(r = 0.2, $fn = 20);
            translate([3,3,0]) sphere(r = 0.2, $fn = 20);
            translate([3.5,3,3.5]) sphere(r = 0.2, $fn = 20);
        }
        translate([0.3275,0.375,0.3]) hull() {
            translate([0,0,0]) sphere(r = 0.2, $fn = 20);
            translate([0,0,2.85]) sphere(r = 0.2, $fn = 20);
            translate([0,2.25,0]) sphere(r = 0.2, $fn = 20);
            translate([0,2.25,2.85]) sphere(r = 0.2, $fn = 20);
            translate([2.25,0,0]) sphere(r = 0.2, $fn = 20);
            translate([2.95,0,3.2]) sphere(r = 0.2, $fn = 20);
            translate([2.25,2.25,0]) sphere(r = 0.2, $fn = 20);
            translate([2.95,2.25,3.2]) sphere(r = 0.2, $fn = 20);
        }
        // Pin hole
        translate([2.3,1.5,-0.25])
            rotate([0,65,0]) cylinder(h = 1.3, r = 0.10, $fn = 20);
    }
}

module dipper_stick_hull() {
    translate([-4,0,-0.615]) hull() {
        translate([0,0,0]) sphere(r = 0.1, $fn = 20);
        translate([0,0,1.2]) sphere(r = 0.1, $fn = 20);
        translate([0,0.5,0]) sphere(r = 0.1, $fn = 20);
        translate([0,0.5,1.2]) sphere(r = 0.1, $fn = 20);
        translate([10,0,0]) sphere(r = 0.1, $fn = 20);
        translate([10,0,1.2]) sphere(r = 0.1, $fn = 20);
        translate([10,0.5,0]) sphere(r = 0.1, $fn = 20);
        translate([10,0.5,1.2]) sphere(r = 0.1, $fn = 20);
    }
}

module dipper_stick() {
    difference() {
        dipper_stick_hull();
        // Cut-out for dipper stick motion
        translate([-4,0,-0.615]) translate([-1.5,-0.3,0.4]) cube([9,1,0.43]);
    }
}

module dipper_stick_plug() {
    intersection() {
        dipper_stick_hull();
        // Cut-out for dipper stick motion
        translate([-4,0,-0.615]) translate([-1.5,-0.3,0.4]) cube([2,1,0.43]);
    }
}


module bucket_hinge_pins() {
    translate([-0.62,0.05,0.85]) rotate([90,0,0])
        cylinder(h=0.5, r=0.17, $fn=20);
    difference() {
        union() {
            // Connect swivel pins to bucket
            translate([-0.2,0.25,0.85]) rotate([90,0,0])
                cylinder(h=0.2, r=0.6, $fn=20);
            translate([-0.2,-0.45,0.85]) rotate([90,0,0])
                cylinder(h=0.2, r=0.6, $fn=20);
        }
        translate([0,-1,0]) cube([3,3,3]);
    }
}

module bucket_hinge() {
    difference() {
        rotate([90,0,0]) cylinder(h=0.4, r=1.0, $fn = 40);
        translate([0,0.1,0]) rotate([90,0,0]) cylinder(h=0.6, r=0.7, $fn = 40);
        rotate([0,-25,0]) translate([-.3,-1,-1]) cube([2,2,2]);
        translate([-0.62,0.1,0.85]) rotate([90,0,0])
            cylinder(h=0.6, r=0.2, $fn=20);
    }
    // Pin-holders on bucket mouth
    difference() {
        translate([-0.62,0,0.85]) rotate([90,0,0])
            cylinder(h=0.4, r=0.4, $fn=20);
        translate([-0.62,0.1,0.85]) rotate([90,0,0])
            cylinder(h=0.6, r=0.21, $fn=20);
    }
}

module bucket_mouth() {
    difference() {
        bucket_hull();
        // Several translate differences to allow margin
        translate([-0.02,-0.02,-0.02]) bucket_cut();
        translate([-0.02,+0.02,-0.02]) bucket_cut();
    }
    translate([0,0.8,0.9]) bucket_hinge();
    translate([0,2.6,0.9]) bucket_hinge();
}


module bucket_lift() {
    translate([1.8,1.5,3]) 
        difference() {
            rotate([0,45,0])
                rotate_extrude(convexity = 10, $fn = 20)
                    translate([1.5, 0, 0]) circle(r = 0.2);
            translate([-1,-2,-4]) cube([4,4,4]);
        }
}

module bucket_cut() {
    translate([-1,-1,0.25]) union() {
        cube([5,5,5]);
        translate([3.75,2.25,-0.5]) cube([1.25,0.5,0.5]);
    }
}

module bucket() {
    intersection() {
        bucket_hull();
        bucket_cut();
    }
    
    // Lift
    bucket_lift();

    // Teeth
    translate([3.5,0,4]) rotate([0,99,0])
        union() {
            translate([0,1.3,0]) cube([0.5,0.5,0.2]);
            translate([0,2.3,0]) cube([0.5,0.5,0.2]);
            translate([0,0.3,0]) cube([0.5,0.5,0.2]);
        }
    // Eyes
    translate([2,-0.2,3]) rotate([0,90,0]) sphere(r = 0.3, $fn = 20);
    translate([2,3.25,3]) rotate([0,90,0]) sphere(r = 0.3, $fn = 20);

    // Mouth
    // Open bucket mount slightly for print
    translate([-0.62, 0, 1.75])
        rotate([0,BUCKET_OPEN_ANGLE,0]) translate([0.62, 0, -1.75])
        bucket_mouth();
    translate([0,0.8,0.9]) bucket_hinge_pins();
    translate([0,2.6,0.9]) bucket_hinge_pins();
}

module dipper_stick_and_bucket() {
    translate([4,0,0.615]) dipper_stick();
    translate([10.1,-1.25,-1]) bucket();
}

module dipper_stick_and_bucket_with_plug() {
    translate([4,0,0.615]) dipper_stick_plug();
    dipper_stick_and_bucket();
}

module cabin_with_mount() {
    difference() {
        cabin();
        translate([5.5,2.2,-0.1]) tread_mount_cutout();
    }
}

module treads_and_cabin() {
    translate([0,0,0.3]) treads();
    translate([0.5,-3,2]) cabin_with_mount();
}

// Full construction
module mary_anne() {
    translate([0,0,0.3]) treads();
    translate([0.5,-3,2]) cabin_with_mount();
    translate([10,0,2.9]) rotate([0,-45,0]) boom();
    translate([11,-.25,7.9]) dipper_stick_and_bucket_with_plug();
}

mary_anne();
//treads_and_cabin();
//cabin_with_mount();
//cabin_roof();
//translate([8,-2,0]) tread_mount_cutout(); 
//controls();
//boom_cable_attach();
//boiler();
//dipper_stick_and_bucket();
//dipper_stick_plug();
//boom();
//dipper_stick();
//dipper_stick_and_bucket_with_plug();

// Blown Up
//translate([0,-10,0]) boom();
//translate ([0,-15,0]) dipper_stick();
//translate([0,-20,0]) bucket();
//translate([0,-25,0]) bucket_hinge();
//rotate([0,0,0]) translate([0.62,-30,-1.75]) bucket_mouth();
//scale(0.1) worm();