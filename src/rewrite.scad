$fs = 0.6;
$fa = 6;

function in_to_mm(in) = in * 25.4;

magnet_diameter = in_to_mm(1/4);
magnet_height = in_to_mm(1/4);
base_wall_thickness = 2;


//calculated variables
magnet_radius = magnet_diameter / 2;
base_radius = magnet_radius + base_wall_thickness;
base_diameter = base_radius * 2;
base_height = magnet_height + base_wall_thickness;

module magnet() {
	cylinder(h = magnet_height, r = magnet_radius); 
}

module base() {
	cylinder(r = base_radius, h = base_height);
}

module top() {
	translate([0,0,base_height]){
		cylinder(h = 1, r = 1, center = false);
	}
}

base();
