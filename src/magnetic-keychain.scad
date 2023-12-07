// User Controled Variables

$fs = 0.6;
$fa = 6;
// flat, male or female
KEYCHAIN_TYPE = "male";
TOLERANCE = 0.05;
MAGNET_DIAMETER = in_to_mm(1/4);
MAGNET_HEIGHT = in_to_mm(1/4);
WALL_THICKNESS = 2;
LOOP_THICKNESS = 1.4;
LOOP_WIDTH = 4;
RELIEF_RADIUS = 2;
SKIRT_WALL_THIKNESS = 0.6;

// Calculated Variables
MAGNET_RADIUS = MAGNET_DIAMETER/2;
BASE_RADIUS = MAGNET_RADIUS + WALL_THICKNESS;
LOOP_HOLE_RADIUS = (BASE_RADIUS - LOOP_THICKNESS) / 2;
BASE_HEIGHT = MAGNET_HEIGHT + WALL_THICKNESS;
TOTAL_HEIGHT = BASE_HEIGHT + BASE_RADIUS;
HOLE_HEIGHT = BASE_HEIGHT + BASE_RADIUS - LOOP_HOLE_RADIUS - LOOP_THICKNESS;

function in_to_mm(in) = in * 25.4;

module Magnet(tolerance = 0){
	translate([0,0,-tolerance])
	cylinder( 
		h = MAGNET_HEIGHT + tolerance,
		r = MAGNET_RADIUS + tolerance / 2
	);
}

module Base(){
	hull(){
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

module LoopReliefCut(){
	translate([-BASE_RADIUS,RELIEF_RADIUS, RELIEF_RADIUS])
	minkowski(){
		cube(size = BASE_RADIUS*2);
		sphere(RELIEF_RADIUS);
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

module Skirt(tolerance = 0){
	skirt_small_radius = MAGNET_RADIUS + SKIRT_WALL_THIKNESS + tolerance;
	skirt_large_radius = BASE_RADIUS - SKIRT_WALL_THIKNESS + tolerance;
	skirt_height = skirt_large_radius - skirt_small_radius;
	difference(){
		cylinder(
			r = BASE_RADIUS,
			h = skirt_height
		);
		cylinder(
			r1 = skirt_small_radius,
			r2 = skirt_large_radius,
			h = skirt_height
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
			Skirt(-TOLERANCE/2);
		}
	} else if (style == "female"){
		union(){
			Body();
			rotate([180,0,0])
			Skirt(tolerance/2);
		}
	} else if (style == "flat"){
		Body();
	} else {}
}

KeyChain(style = KEYCHAIN_TYPE);
