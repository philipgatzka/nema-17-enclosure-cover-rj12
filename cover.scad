$fn = 72;

base_height = 4;
screwhole_diameter = 4;

enclosure_corner_radius = 4;
enclosure_width = 48 - enclosure_corner_radius * 2;
enclosure_height = 56 - enclosure_corner_radius * 2;

connector_type = "rj12_6p6c";

function corner_vectors(verticalOffset = 0) = [
  [0, 0, verticalOffset],
  [0, enclosure_height, verticalOffset],
  [enclosure_width, enclosure_height, verticalOffset],
  [enclosure_width, 0, verticalOffset]
];

module screwhole_padding() {
  for(i = corner_vectors()) {
    translate(i)
      cylinder(r = enclosure_corner_radius, h = base_height);
  }
}

module base() {
  difference () {
    hull() {
      screwhole_padding();
    }
    translate([0, 0, base_height / 2])
      cube([enclosure_width, enclosure_height, 10]);
  }
}

module pin() {
  translate([0, 0, -1])
    cylinder(d = screwhole_diameter , h = base_height+2);
}

module screwholes() {
  for(i = corner_vectors()) {
    translate(i)
      pin();
  }
}

module bulge() {
  translate([enclosure_corner_radius + 1, enclosure_corner_radius + 2, 0])
   scale([0.75, 0.75, 1])
     hull() {
       for(i = corner_vectors(base_height / 2)) {
         translate(i)
           cylinder(d = 8, h = 0.25);
       }
       translate([enclosure_width / 4, enclosure_height / 2.5, enclosure_width / 2.5])
         rotate([0, 90, 0])
           cylinder(d = 8, h = enclosure_width / 2);
     }
}

module connector(type) {
  translate([enclosure_width / 3 - 0.5, enclosure_width / 3 + 0.5, 0])
    rotate([50, 0, 0])
      if (type == "rj12_6p6c") {
        cube([14, 15, 20]);
      }
}

module cap() {
  difference() {
    union() {
      base();
      bulge();
      screwhole_padding();
    }
    screwholes();
    translate([0, 0, -3])
      bulge();
    connector(connector_type);
  }
}

cap();
