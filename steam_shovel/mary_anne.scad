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
    cylinder(h = 1, r1 = 1.5, r2 = 0.75, center = false, $fn = 20);
    translate([0,0,1]) cylinder(h = 1, r = 0.75, center = false, $fn = 20);
    translate([0,0,-5]) cylinder(h = 5, r = 1.5, center = false, $fn = 20);
}

module treads() {
    translate ([0,-3,0]) rotate([90,0,0]) tread();
    translate ([0,3,0]) rotate([-90,0,0]) tread();
    hull() {
        translate([3,3,0]) rotate([90,0,0]) cylinder(h = 6.0, r = 0.8, $fn = 20);
        translate([7,3,0]) rotate([90,0,0]) cylinder(h = 6.0, r = 0.8, $fn = 20);
    }
}

module cabin_walls() {
    translate([0,0.1,0.5])
        corrugated_square(length = 9, height = 5, cor_width = 0.1, cor_depth = 0.5);
    translate([0,5.45,0.5])
        corrugated_square(length = 9, height = 5, cor_width = 0.1, cor_depth = 0.5);
    translate([0,6,0.5]) rotate([0,0,-90])
        corrugated_square(length = 5.75, height = 5, cor_width = 0.1, cor_depth = 0.5);
    
    // Coal Chute
    translate([0.5,0.1,0.5]) rotate([10,0,0])
        corrugated_square(length = 1.5, height = 2.5, cor_width = 0.1, cor_depth = 0.5);
}

module cabin_roof() {
    difference () {
        rotate([90,0,90]) cylinder(h = 7.2, r = 3, $fn = 40);
        union () {
            translate([-.5,0,0]) rotate([90,0,90]) cylinder(h = 8, r = 2.5, $fn = 40);
            translate([-5,-6,-8]) cube([15,10,10]);
        }
    }
}

module cabin() {
    // Spinny thingy...
    translate([4.5,3.125,-0.9]) cylinder(h = 1, r = 2.25, $fn = 20);
    // Floor
    cube([9,6,0.5]);
    // boom attachment
    translate([9.5,3,0.5]) rotate([0,-45,0]) scale(0.85)
        boom_attach();
    // Walls and chute
    difference() {
        cabin_walls();
        union () {
            translate([2.5,-0.5,0]) cube([1.5,2,5.5]);
            translate([4.5,-0.5,3]) cube([2,2,2]);
            translate([7,-0.5,0]) cube([1.5,2,5.5]);
            translate([0.7,.4,0]) rotate([10,0,0]) cube([1.1, 0.5, 3.5]);
        }
    }
    translate([0,3,3]) scale([1.25,1.25,1.25]) cabin_roof();
    difference() {
        translate([1.7,3,6.5]) color("green", 1.0) boiler();
        union() {
            translate([1.7,3,6.5]) scale([0.8, 0.8, 0.8]) boiler();
            translate([1.5,2,2]) cube([2,2,2]);
            translate([1.7,3,6]) cylinder(h = 3, r = 0.5, center = false, $fn = 20);
        }
    }
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

module boom() {
    difference () {
        union () {
            boom_half();
            translate([16,0,0.5]) rotate([0,180,0]) boom_half();
        }
        union () {
            // Two cuts to give range of motion to the dipper stick
            translate([4,-.2,2.75])
                rotate([0,35,0]) scale(1.3) dipper_stick_hull();
            translate([13,-.2,5.5])
                rotate([0,135,0]) scale(1.3) dipper_stick_hull();
            // A cut out of the top to allow top-lift line.
            translate([16.3,-0.15,-.1]) rotate([0,-60,0]) cube([2,0.3,3]);
            // Cut out for attachment to body
            boom_attach();
        }
    }
    translate([16.1,-0.15,.29]) rotate([-90,0,0])
        cylinder(h = 0.3, r = 0.24, $fn = 20);
    translate([12,-0.6,0.25]) rotate([90,0,4]) linear_extrude(0.25)
        text("Mary Anne", size = 0.5);
    translate([8.25,0.7,0.25]) rotate([90,0,0])
        cylinder(h=1.5, r=0.2, $fn = 20);
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
    }
}

module dipper_stick_hull() {
    hull() {
        translate([0,0,0]) sphere(r = 0.1, $fn = 20);
        translate([0,0,.8]) sphere(r = 0.1, $fn = 20);
        translate([0,0.3,0]) sphere(r = 0.1, $fn = 20);
        translate([0,0.3,.8]) sphere(r = 0.1, $fn = 20);
        translate([10,0,0]) sphere(r = 0.1, $fn = 20);
        translate([10,0,.8]) sphere(r = 0.1, $fn = 20);
        translate([10,0.3,0]) sphere(r = 0.1, $fn = 20);
        translate([10,0.3,.8]) sphere(r = 0.1, $fn = 20);
    }
}

module dipper_stick() {
    difference() {
        dipper_stick_hull();
        // Cut-out for dipper stick motion
        translate([0.5,-0.3,0.2]) cube([7,1,0.43]);
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
            cylinder(h=0.6, r=0.2, $fn=20);
    }
}

module bucket_mouth() {
    difference() {
        bucket_hull();
        translate([-0.5,-0.5,0.25]) cube([5,5,5]);
    }
    translate([0,0.8,0.9]) bucket_hinge();
    translate([0,2.6,0.9]) bucket_hinge();
}


module bucket_lift() {
    translate([1,1.5,3]) 
        difference() {
            rotate([0,90,0])
                rotate_extrude(convexity = 10, $fn = 20)
                    translate([1.5, 0, 0]) circle(r = 0.2);
            translate([-1,-2,-4]) cube([4,4,4]);
        }
}

module bucket() {
    intersection() {
        bucket_hull();
        translate([-0.5,-0.5,0.25]) cube([5,5,5]);
    }
    
    // Lift
    bucket_lift();

    // Teeth
    translate([3.35,1.3,3.9]) rotate([0,90,0]) cube([0.5,0.5,0.2]);
    translate([3.35,2.3,3.9]) rotate([0,90,0]) cube([0.5,0.5,0.2]);
    translate([3.35,0.3,3.9]) rotate([0,90,0]) cube([0.5,0.5,0.2]);
    // Eyes
    translate([2,-0.2,3]) rotate([0,90,0]) sphere(r = 0.3, $fn = 20);
    translate([2,3.25,3]) rotate([0,90,0]) sphere(r = 0.3, $fn = 20);

    // Mouth
    // Open bucket mount slightly for print
    translate([-0.62, 0, 1.75])
        rotate([0,60,0]) translate([0.62, 0, -1.75])
        bucket_mouth();
    translate([0,0.8,0.9]) bucket_hinge_pins();
    translate([0,2.6,0.9]) bucket_hinge_pins();
}

module dipper_stick_and_bucket() {
    translate([0.1,0.1,0.1]) dipper_stick();
    translate([10,-1.3,-1]) bucket();
}

// Full construction
module mary_anne() {
    //translate([0,0,0.3]) treads();
    //translate([0.5,-3,2]) cabin();
    translate([10,0,2.5]) rotate([0,-45,0]) boom();
    translate([11,-.25,8]) dipper_stick_and_bucket();
}

mary_anne();

// Blown Up
//translate([0,-10,0]) boom();
//translate ([0,-15,0]) dipper_stick();
//translate([0,-20,0]) bucket();
//translate([0,-25,0]) bucket_hinge();
//rotate([0,0,0]) translate([0.62,-30,-1.75]) bucket_mouth();
//scale(0.1) worm();