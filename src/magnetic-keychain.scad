function in_to_mm(in) = in * 25.4;

// User Control Variables
$fs = 0.6;
$fa = 6;

TOLERANCE = 0.05;

MAGNET_DIAMETER = in_to_mm(1/4);
MAGNET_HEIGHT = in_to_mm(1/4);

WALL_THICKNESS = 2;

LOOP_THICKNESS = 1.4;
LOOP_WIDTH = 4;

SKIRT_WALL_THIKNESS = 0.6;

// Calculated Variables
MAGNET_RADIUS = MAGNET_DIAMETER/2;
BASE_RADIUS = MAGNET_RADIUS + WALL_THICKNESS;
LOOP_HOLE_RADIUS = (BASE_RADIUS - LOOP_THICKNESS) / 2;
BASE_HEIGHT = MAGNET_HEIGHT + WALL_THICKNESS;
TOTAL_HEIGHT = BASE_HEIGHT + BASE_RADIUS;
HOLE_HEIGHT = BASE_HEIGHT + BASE_RADIUS - LOOP_HOLE_RADIUS - LOOP_THICKNESS;


module Magnet(tolerance = 0){
	translate([0,0,-tolerance])
	cylinder( 
		h = MAGNET_HEIGHT + tolerance,
		r = MAGNET_RADIUS + tolerance / 2
	);
}

module Base(){
	union(){
		cylinder(
			h = MAGNET_HEIGHT + WALL_THICKNESS,
			r = MAGNET_RADIUS + WALL_THICKNESS
		);
			translate([0,0,MAGNET_HEIGHT + WALL_THICKNESS])
		sphere(
			r = MAGNET_RADIUS + WALL_THICKNESS
		);
	}
}

module LoopReliefCut(radius = 2, size = 10,){
	translate([-size/2,radius , radius])
	minkowski(){
		cube(size = size);
		sphere(radius);
	}
}

module Hole(){
	translate([0,0,HOLE_HEIGHT]) rotate([90,0,0])
	cylinder(
		r = LOOP_HOLE_RADIUS,
		h = MAGNET_HEIGHT + WALL_THICKNESS * 2,
		center = true
	);  
	translate([0,0,BASE_HEIGHT-WALL_THICKNESS/2]){
		translate([0,LOOP_WIDTH/2,0])
		LoopReliefCut();
		rotate([0,0,180])translate([0,LOOP_WIDTH/2,0])
		LoopReliefCut();
	}
}

module Skirt(){
	skirt_r1 = MAGNET_RADIUS + SKIRT_WALL_THIKNESS ;
	skirt_r2 = BASE_RADIUS - SKIRT_WALL_THIKNESS ;
	skirt_h = skirt_r2 - skirt_r1;
	difference(){
		cylinder(
			r = BASE_RADIUS,
			h = skirt_h
		);
		cylinder(
			r1 = skirt_r1,
			r2 = skirt_r2,
			h = skirt_h
		);
	}
}

module Body(){
	difference(){
		Base();
		Magnet(TOLERANCE);
		Hole();
		}
}

module KeyChain(style = "flat"){
	if (style == "male") {
		difference(){
			Body();
			Skirt();
		}
	} else if (style == "female"){
		union(){
			Body();
			rotate([180,0,0])
			Skirt();
		}
	} else if (style == "flat"){
		Body();
	} else {
	}
}

//color("yellow")
KeyChain("flat");




