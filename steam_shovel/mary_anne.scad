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
    translate([4.5,3.125,-0.9]) cylinder(h = 1, r = 2.25, $fn = 20);
    cube([9,6,0.5]);
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
    boom_half();
    translate([16,0,0.5]) rotate([0,180,0]) boom_half();
}

module bucket() {
    difference() {
        translate([9,-1.5,-1]) hull() {
            translate([0,0,0]) sphere(r = 0.2, $fn = 20);
            translate([0,0,3]) sphere(r = 0.2, $fn = 20);
            translate([0,3,0]) sphere(r = 0.2, $fn = 20);
            translate([0,3,3]) sphere(r = 0.2, $fn = 20);
            translate([3,0,0]) sphere(r = 0.2, $fn = 20);
            translate([3.5,0,3.5]) sphere(r = 0.2, $fn = 20);
            translate([3,3,0]) sphere(r = 0.2, $fn = 20);
            translate([3.5,3,3.5]) sphere(r = 0.2, $fn = 20);
        }
        translate([9.3275,-1.125,-.7]) hull() {
            translate([0,0,0]) sphere(r = 0.2, $fn = 20);
            translate([0,0,2.85]) sphere(r = 0.2, $fn = 20);
            translate([0,2.25,0]) sphere(r = 0.2, $fn = 20);
            translate([0,2.25,2.85]) sphere(r = 0.2, $fn = 20);
            translate([2.25,0,0]) sphere(r = 0.2, $fn = 20);
            translate([2.75,0,3.2]) sphere(r = 0.2, $fn = 20);
            translate([2.25,2.25,0]) sphere(r = 0.2, $fn = 20);
            translate([2.75,2.25,3.2]) sphere(r = 0.2, $fn = 20);
        }
    }
}

module dipper_stick() {
    translate([0.1,0.1,0.1]) hull() {
        translate([0,0,0]) sphere(r = 0.1, $fn = 20);
        translate([0,0,.8]) sphere(r = 0.1, $fn = 20);
        translate([0,0.3,0]) sphere(r = 0.1, $fn = 20);
        translate([0,0.3,.8]) sphere(r = 0.1, $fn = 20);
        translate([9,0,0]) sphere(r = 0.1, $fn = 20);
        translate([9,0,.8]) sphere(r = 0.1, $fn = 20);
        translate([9,0.3,0]) sphere(r = 0.1, $fn = 20);
        translate([9,0.3,.8]) sphere(r = 0.1, $fn = 20);
    }
    difference () {
        translate([0,0.2,0]) bucket();
        //translate([8.5,-2.5,-1.8]) cube([5,5,1]);
    }
    // Teeth
    translate([12.2,0,2.9]) rotate([0,90,0]) cube([0.5,0.5,0.3]);
    translate([12.2,1,2.9]) rotate([0,90,0]) cube([0.5,0.5,0.3]);
    translate([12.2,-1,2.9]) rotate([0,90,0]) cube([0.5,0.5,0.3]);
    // Eyes
    translate([11,-1.5,2]) rotate([0,90,0]) sphere(r = 0.3, $fn = 20);
    translate([11,1.95,2]) rotate([0,90,0]) sphere(r = 0.3, $fn = 20);
}

treads();
translate([0.5,-3,2]) cabin();
translate([10,0,2.5]) rotate([0,-45,0]) boom();
translate([11,-.25,8]) dipper_stick();