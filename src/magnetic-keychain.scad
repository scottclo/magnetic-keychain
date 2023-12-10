// user controled variables

$fs = 0.6;
$fa = 6;
// flat, male or female
keychain_type = "flat";
tolerance = 0.05;
magnet_diameter = in_to_mm(1/4);
magnet_height = in_to_mm(1/4);
wall_thickness = 2;
loop_thickness = 1.4;
loop_width = 4;
relief_radius = 2;
cone_wall_thickness = 0.6;

// calculated variables
magnet_radius = magnet_diameter/2;
base_radius = magnet_radius + wall_thickness;
loop_hole_radius = (base_radius - loop_thickness) / 2;
base_height = magnet_height + wall_thickness;
total_height = base_height + base_radius;
hole_height = base_height + base_radius - loop_hole_radius - loop_thickness;

function in_to_mm(in) = in * 25.4;

module magnet(tolerance = 0){
	translate([0,0,-tolerance])
	cylinder( 
		h = magnet_height + tolerance,
		r = magnet_radius + tolerance / 2
	);
}

module base(){
	hull(){
		cylinder(
			h = magnet_height + wall_thickness,
			r = magnet_radius + wall_thickness
		);
			translate([0,0,magnet_height + wall_thickness])
		sphere(
			r = magnet_radius + wall_thickness
		);
	}
}

module loopreliefcut(){
	translate([-base_radius,relief_radius, relief_radius])
	minkowski(){
		cube(size = base_radius*2);
		sphere(relief_radius);
	}
}

module hole(){
	translate([0,0,hole_height]) rotate([90,0,0])
	cylinder(
		r = loop_hole_radius,
		h = magnet_height + wall_thickness * 2,
		center = true
	);  
	translate([0,0,base_height-wall_thickness/2]){
		translate([0,loop_width/2,0])
		loopreliefcut();
		rotate([0,0,180])translate([0,loop_width/2,0])
		loopreliefcut();
	}
}

module cone(tolerance = 0){
	cone_small_radius = magnet_radius + cone_wall_thickness + tolerance;
	cone_large_radius = base_radius - cone_wall_thickness + tolerance;
	cone_height = cone_large_radius - cone_small_radius;
	difference(){
		cylinder(
			r = base_radius,
			h = cone_height
		);
		cylinder(
			r1 = cone_small_radius,
			r2 = cone_large_radius,
			h = cone_height
		);
	}
}

module body(){
	difference(){
		base();
		magnet(tolerance);
		hole();
	}
}

module keychain(style = "flat"){
	if (style == "male") {
		difference(){
			body();
			cone(-tolerance/2);
		}
	} else if (style == "female"){
		union(){
			body();
			rotate([180,0,0])
			cone(tolerance/2);
		}
	} else if (style == "flat"){
		body();
	} else {}
}

render()keychain(style = keychain_type);
