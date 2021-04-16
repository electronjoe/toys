difference() {
    cylinder(h = 16, r = 44.7/2, $fn = 60);
    union () {
        translate([0,0,10]) cylinder(h = 16, r = (44.7)/2-8.6, $fn = 60);
        translate([0,0,-1]) cylinder(h = 6, r = 17.5/2, $fn = 60);
    }
}
difference() {
    cylinder(h = 16, r = 5, $fn = 60);
    // Axel hole
    translate([0,0,4.6]) cylinder(h=14.5-3, r=2.5/2, $fn=20);
}
