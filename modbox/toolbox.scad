// LibFile: toolbox.scad
//   This file contains low-level modules and functions used in box_parts.scad but with
//   a potentially wider field of application.
// Includes:
//   use <toolbox.scad>;

// Section: modules

// Module:  bevel()
// Usage:
//   bevel(point_start, point_end, radius, quadrant, resolution);
// Description:
//    Bevels an edge (if children are provided) or creates a shape for beveling an edge.
// Arguments:
//    point_start : starting point, in the form of a vector [x,y,z]
//    point_end : end point, in the form of a vector [x,y,z]
//    radius : beveling radius
//    quadrant : bevel orientation (1 = up-left, 2 = up-right, 3 = down-right, 4 = down-left)
//    resolution : beveling resolution (number of segments per 360 degrees, 0 = automatic)
module bevel(point_start, point_end, radius, quadrant, resolution) {
    length = sqrt((point_end.x - point_start.x)^2 + (point_end.y - point_start.y)^2 + (point_end.z - point_start.z)^2);
    angle1 = asin((point_end.x - point_start.x) / length);
    angle2 = asin((point_end.y - point_start.y) / length);
    angle3 = asin((point_end.z - point_start.z) / length);
    
    radius = radius + 0.02;
    
    difference() {
        if ($children>0) children();
        translate(point_start) rotate([-angle2, angle1, angle3]) if (quadrant == 1) {
            translate([-radius + 0.01, radius - 0.01, 0])
            difference() {
                translate([0, -radius, -0.01]) cube([radius, radius, length+0.02]);
                translate([0, 0, -0.5]) linear_extrude(length+1, slices=1) circle(r=radius, $fn=resolution);
            }
        } else if (quadrant == 2) {
            translate([radius - 0.01, radius - 0.01, 0])
            difference() {
                translate([-radius, -radius, -0.01]) cube([radius, radius, length+0.02]);
                translate([0, 0, -0.5]) linear_extrude(length+1, slices=1) circle(r=radius, $fn=resolution);
            }
        } else if (quadrant == 3) {
            translate([radius - 0.01, -radius + 0.01, 0])
            difference() {
                translate([-radius, 0, -0.01]) cube([radius, radius, length+0.02]);
                translate([0, 0, -0.5]) linear_extrude(length+1, slices=1) circle(r=radius, $fn=resolution);
            }
        } else {
            translate([-radius + 0.01, -radius + 0.01, 0])
            difference() {
                translate([0, 0, -0.01]) cube([radius, radius, length+0.02]);
                translate([0, 0, -0.5]) linear_extrude(length+1, slices=1) circle(r=radius, $fn=resolution);
            }
        }
    }
}


// Module:  extruded_rounded_rectangle()
// Usage:
//   extruded_rounded_rectangle(xyz, radius, resolution);
// Description:
//    Produces a cuboid with 4 rounded edges, akin to an extruded rounded rectangle.
// Arguments:
//    xyz: cuboid size as [length, width, height]
//    radius : beveling radius for edges
//    resolution : beveling resolution (number of segments per 360 degrees, 0 = automatic)
module extruded_rounded_rectangle(xyz, radius, resolution) {
    difference() {
        cube(xyz);
        x = xyz[0];
        y = xyz[1];
        z = xyz[2];
        // edges
        bevel([0, 0, 0], [0, 0, z], radius, 3, resolution);
        bevel([x, 0, 0], [x, 0, z], radius, 2, resolution);
        bevel([x, y, 0], [x, y, z], radius, 1, resolution);
        bevel([0, y, 0], [0, y, z], radius, 4, resolution);
    }
}


// Module:  rounded_cube()
// Usage:
//   rounded_cube(xyz, radius, resolution, sharp_vertices);
// Description:
//    Produces a cuboid with all edges rounded.
// Arguments:
//    xyz: cuboid size as [length, width, height]
//    radius : beveling radius for edges
//    resolution : beveling resolution (number of segments per 360 degrees, 0 = automatic)
//    sharp_vertices : if true, produces a cuboid with angled vertices; if false (default), vertices are rounded.
module rounded_cube(xyz, radius, resolution, sharp_vertices) {
    x = xyz[0];
    y = xyz[1];
    z = xyz[2];
    if (!sharp_vertices) {
        translate([radius, radius, radius]) minkowski() {
            cube([x - 2*radius, y - 2*radius, z - 2*radius]);
            sphere(radius);
        }
    } else {
        difference() {
            cube(xyz);
            // edges
            bevel([0, 0, 0], [0, 0, z], radius, 3, resolution);
            bevel([x, 0, 0], [x, 0, z], radius, 2, resolution);
            bevel([x, y, 0], [x, y, z], radius, 1, resolution);
            bevel([0, y, 0], [0, y, z], radius, 4, resolution);
            
            // top
            bevel([0, 0, z], [0, y, z], radius, 2, resolution);
            bevel([x, 0, z], [x, y, z], radius, 1, resolution);
            bevel([0, 0, z], [x, 0, z], radius, 2, resolution);
            bevel([0, y, z], [x, y, z], radius, 3, resolution);
            
            // bottom
            bevel([0, 0, 0], [0, y, 0], radius, 3, resolution);
            bevel([0, 0, 0], [x, 0, 0], radius, 1, resolution);
            bevel([x, 0, 0], [x, y, 0], radius, 4, resolution);
            bevel([0, y, 0], [x, y, 0], radius, 4, resolution);
        }
    }
}


// Module:  rounded_rect_hole()
// Usage:
//   rounded_rect_hole(xyz, radius, resolution);
// Description:
//    Creates a rectangular hole with rounded edges in module children.
// Arguments:
//    xyz: hole size as [length, width, height]
//    radius : beveling radius for edges
//    resolution : beveling resolution (number of segments per 360 degrees, 0 = automatic)
module rounded_rect_hole(xyz, radius, resolution) {
    x = xyz[0];
    y = xyz[1];
    z = xyz[2];
    difference() {
        if ($children>0) children();
        translate([-radius, -radius, 0]) difference() {
            translate([0, 0, -0.01]) cube([x+2*radius, y+2*radius, z+0.02]);
            if (z > 2*radius) {
                translate([0, 0, radius]) cube([x+2*radius, radius, z - 2*radius]);
                translate([0, y+radius, radius]) cube([x+2*radius, radius, z - 2*radius]);
                translate([0, 0, radius]) cube([radius, y+2*radius, z - 2*radius]);
                translate([x+radius, 0, radius]) cube([radius, y+2*radius, z - 2*radius]);
            }
            translate([x/2 + radius, 0, radius]) rotate([0, 90, 0]) cylinder(h=x+3*radius, r=radius, center=true, $fn=resolution);
            translate([x/2 + radius, 0, z - radius]) rotate([0, 90, 0]) cylinder(h=x+3*radius, r=radius, center=true, $fn=resolution);
            translate([x/2 + radius, y+2*radius, radius]) rotate([0, 90, 0]) cylinder(h=x+3*radius, r=radius, center=true, $fn=resolution);
            translate([x/2 + radius, y+2*radius, z - radius]) rotate([0, 90, 0]) cylinder(h=x+3*radius, r=radius, center=true, $fn=resolution);
            translate([0, y/2 + radius, radius]) rotate([90, 0, 0]) cylinder(h=y+3*radius, r=radius, center=true, $fn=resolution);
            translate([0, y/2 + radius, z - radius]) rotate([90, 0, 0]) cylinder(h=y+3*radius, r=radius, center=true, $fn=resolution);
            translate([x+2*radius, y/2 + radius, radius]) rotate([90, 0, 0]) cylinder(h=y+3*radius, r=radius, center=true, $fn=resolution);
            translate([x+2*radius, y/2 + radius, z - radius]) rotate([90, 0, 0]) cylinder(h=y+3*radius, r=radius, center=true, $fn=resolution);
        }
    }
}


// Module:  chamfered_rect_hole()
// Usage:
//   chamfered_rect_hole(xyz, width);
// Description:
//    Creates a rectangular hole with chamfered edges in module children.
// Arguments:
//    xyz: hole size as [length, width, height]
//    width : chamfer width
module chamfered_rect_hole(xyz, width) {
    x = xyz[0];
    y = xyz[1];
    z = xyz[2];

    difference() {
        if ($children>0) children();
            
        translate([-width-0.01, -width-0.01, 0]) difference() {
        translate([0, 0, -0.01]) cube([x+2*width, y+2*width, z+0.02]);
        
        translate([width-0.01, y/2 + width, -0.02]) rotate([-90, 180, 0]) linear_extrude(y+2*width+0.02, center=true) polygon([[0,0], [width+0.02, 0], [width+0.02, z+0.02]]);
        translate([x + width+0.01, y/2 + width, -0.02]) rotate([90, 0, 0]) linear_extrude(y+2*width+0.02, center=true) polygon([[0,0], [width+0.02, 0], [width+0.02, z+0.02]]);
        translate([x/2 + width, width + 0.01, -0.02]) rotate([-90, 180, 90]) linear_extrude(x+2*width+0.02, center=true) polygon([[0,0], [width+0.02, 0], [width+0.02, z+0.02]]);
        translate([x/2 + width, y + width + 0.01, -0.02]) rotate([90, 0, 90]) linear_extrude(x+2*width+0.02, center=true) polygon([[0,0], [width+0.02, 0], [width+0.02, z+0.02]]);
        }
    }
    
}


// Module:  rounded_circular_edge()
// Usage:
//   rounded_circular_edge(circle_radius, rounding_radius, resolution, inside_circle);
// Description:
//    Creates a rounded edge on the inside or outside (default) of a circle.
// Arguments:
//    circle_radius: circle radius
//    rounding_radius: edge rounding radius
//    resolution : rounding resolution (number of segments per 360 degrees, 0 = automatic)
//    inside_circle: if true, rounded edge is created inside circle; if false, edge is outside (default)
module rounded_circular_edge(circle_radius, rounding_radius, resolution, inside_circle) {
    
    difference() {
        if (inside_circle) {
            cylinder(h = rounding_radius, r=circle_radius, center=true);
            cylinder(h = rounding_radius + 0.02, r=circle_radius - rounding_radius, center=true);
            translate([0, 0, rounding_radius/2]) rotate_extrude() translate([circle_radius-rounding_radius, 0, 0]) circle(r = rounding_radius, $fn=resolution);
        } else {
            cylinder(h = rounding_radius, r=circle_radius + rounding_radius, center=true);
            cylinder(h = rounding_radius+0.02, r=circle_radius, center=true);
            translate([0, 0, rounding_radius/2]) rotate_extrude() translate([circle_radius + rounding_radius, 0, 0]) circle(r = rounding_radius, $fn=resolution);
        }
    }
}

// Module:  rounded_circular_hole()
// Usage:
//   rounded_circular_hole(circle_radius, depth, rounding_radius, resolution);
// Description:
//    Creates a circular hole with rounded edge in module children.
// Arguments:
//    circle_radius: hole radius
//    depth: hole depth
//    rounding_radius: edge rounding radius
module rounded_circular_hole(circle_radius, depth, rounding_radius, resolution) {
    
    difference() {
        cylinder(h = depth, r=circle_radius, center=true);
        translate([0, 0, max(0,depth/2 - rounding_radius)]) rotate_extrude() translate([circle_radius, 0, 0]) circle(r = rounding_radius+0.02, $fn=resolution);
        translate([0, 0, min(0,-depth/2 + rounding_radius)]) rotate_extrude() translate([circle_radius, 0, 0]) circle(r = rounding_radius+0.02, $fn=resolution);
        if (depth > 2*rounding_radius) {
            difference() {
                cylinder(h = depth - 2*rounding_radius, r = circle_radius, center=true);
                cylinder(h = depth, r = circle_radius - rounding_radius, center=true);
            }
        }
        difference() {
            cylinder(h = depth + 0.02, r=circle_radius + rounding_radius, center=true);
            cylinder(h = depth + 0.04, r=circle_radius, center=true);
        }
    }
}


// Module:  fill_with_pattern()
// Usage:
//   fill_with_pattern(point_min, point_max, period_x, period_y, exclusion_rects, exclusion_circles);
// Description:
//    Fills the rectangular area between point_min and point_max with module children.
// Arguments:
//    point_min : coordinates of top left corner as [x, y]
//    point_max : coordinates of bottom right corner as [x, y]
//    period_x : pattern period in longitudinal direction
//    period_y : pattern period in lateral direction
//    exclusion_rects : optional list of rectangles inside which pattern won't be drawn, as [[x0, y0], [x1, y1]]
//    exclusion_circles : optional list of circles inside which pattern won't be drawn, as [[cx, cy], radius]
module fill_with_pattern(point_min, point_max, period_x, period_y, exclusion_rects, exclusion_circles) {
    // displacement necessary to center pattern
    dx = ((point_max.x - point_min.x) % period_x) / 2;
    dy = ((point_max.y - point_min.y) % period_y) / 2;
    for (x = [(point_min.x+dx):period_x:(point_max.x+dx)]) 
        for (y = [(point_min.y+dy):period_y:(point_max.y+dy)])
            if (is_outside_circles_all(exclusion_circles, [x,y]) && is_outside_rects_all(exclusion_rects, [x,y]))
                translate([x, y, 0]) children();
}

// Section: functions

// Function:  is_inside_box()
// Usage:
//   is_inside_box(box, point);
// Description:
//    Tells if point is inside box.
// Arguments:
//    box: two extremal vertices of a cuboid, as [[x0, y0, z0], [x1, y1, z1]]
//    point: point coordinates as [xp, yp, zp]
// Returns:  true if point is inside box (or on its surface), false otherwise.
function is_inside_box(box, point) =
    point.x >= min(box[0].x, box[1].x) && point.x <= max(box[0].x, box[1].x) && point.y >= min(box[0].y, box[1].y) && point.y <= max(box[0].y, box[1].y) && point.z >= min(box[0].z, box[1].z) && point.z <= max(box[0].z, box[1].z);

// Function:  is_inside_boxes()
// Usage:
//   is_inside_boxes(boxes, point);
// Description:
//    Tells if point is inside a list of boxes.
// Arguments:
//    boxes: a list of boxes defined as required for is_inside_box
//    point: point coordinates as [xp, yp, zp]
// Returns:  a list of booleans, which, for each box, are true if point is inside (or on its surface), false otherwise.
function is_inside_boxes(boxes, point) = is_undef(boxes) ? false : [for (box = boxes) is_inside_box(box, point)];

// Function:  is_inside_boxes_all()
// Usage:
//   is_inside_boxes_all(boxes, point);
// Description:
//    Tells if point is inside every box from a list.
// Arguments:
//    boxes: a list of boxes defined as required for is_inside_box
//    point: point coordinates as [xp, yp, zp]
// Returns:  true if point is inside all boxes, false otherwise.
function is_inside_boxes_all(boxes, point) = is_undef(boxes) ? false : min(is_inside_boxes(boxes, point));

// Function:  is_inside_boxes_any()
// Usage:
//   is_inside_boxes_any(boxes, point);
// Description:
//    Tells if point is inside one of the boxes from a list.
// Arguments:
//    boxes: a list of boxes defined as required for is_inside_box
//    point: point coordinates as [xp, yp, zp]
// Returns:  true if point is inside any of the boxes from list, false otherwise.
function is_inside_boxes_any(boxes, point) = is_undef(boxes) ? false : max(is_inside_boxes(boxes, point));

// Function:  is_outside_box()
// Usage:
//   is_outside_box(box, point);
// Description:
//    Tells if point is outside box.
// Arguments:
//    box: two extremal vertices of a cuboid, as [[x0, y0, z0], [x1, y1, z1]]
//    point: point coordinates as [xp, yp, zp]
// Returns:  true if point is outside box, false otherwise.
function is_outside_box(box, point) = !is_inside_box(box, point);

// Function:  is_outside_boxes()
// Usage:
//   is_outside_boxes(boxes, point);
// Description:
//    Tells if point is outside a list of boxes.
// Arguments:
//    boxes: a list of boxes defined as required for is_outside_box
//    point: point coordinates as [xp, yp, zp]
// Returns:  a list of booleans, which, for each box, are true if point is outside, false otherwise.
function is_outside_boxes(boxes, point) = is_undef(boxes) ? true : [for (box = boxes) is_outside_box(box, point)];

// Function:  is_outside_boxes_all()
// Usage:
//   is_outside_boxes_all(boxes, point);
// Description:
//    Tells if point is outside every box from a list.
// Arguments:
//    boxes: a list of boxes defined as required for is_outside_box
//    point: point coordinates as [xp, yp, zp]
// Returns:  true if point is outside all boxes, false otherwise.
function is_outside_boxes_all(boxes, point) = is_undef(boxes) ? true : min(is_outside_boxes(boxes, point));

// Function:  is_outside_boxes_any()
// Usage:
//   is_outside_boxes_any(boxes, point);
// Description:
//    Tells if point is outside one of the boxes from a list.
// Arguments:
//    boxes: a list of boxes defined as required for is_outside_box
//    point: point coordinates as [xp, yp, zp]
// Returns:  true if point is outside any of the boxes from list, false otherwise.
function is_outside_boxes_any(boxes, point) = is_undef(boxes) ? true : max(is_outside_boxes(boxes, point));


// Function:  is_inside_rect()
// Usage:
//   is_inside_rect(rect, point);
// Description:
//    Tells if point is inside rectangle.
// Arguments:
//    box: two extremal vertices of a rectangle, as [[x0, y0], [x1, y1]]
//    point: point coordinates as [xp, yp]
// Returns:  true if point is inside rectangle (or on its boundary), false otherwise.
function is_inside_rect(rect, point) = point.x >= min(rect[0].x, rect[1].x) && point.x <= max(rect[0].x, rect[1].x) && point.y >= min(rect[0].y, rect[1].y) && point.y <= max(rect[0].y, rect[1].y);

// Function:  is_inside_rects()
// Usage:
//   is_inside_rects(rects, point);
// Description:
//    Tells if point is inside a list of rectangles.
// Arguments:
//    rects: a list of rectangles defined as required for is_inside_rect
//    point: point coordinates as [xp, yp]
// Returns:  a list of booleans, which, for each rectangle, are true if point is inside (or on its boundary), false otherwise.
function is_inside_rects(rects, point) = is_undef(rects) ? false : [for (rect = rects) is_inside_rect(rect, point)];

// Function:  is_inside_rects_all()
// Usage:
//   is_inside_rects_all(boxes, point);
// Description:
//    Tells if point is inside every rectangle from a list.
// Arguments:
//    rects: a list of rectangles defined as required for is_inside_rect
//    point: point coordinates as [xp, yp]
// Returns:  true if point is inside all rectangles, false otherwise.
function is_inside_rects_all(rects, point) = is_undef(rects) ? false : min(is_inside_rects(rects, point));

// Function:  is_inside_rects_any()
// Usage:
//   is_inside_rects_any(rects, point);
// Description:
//    Tells if point is inside one of the rectangles from a list.
// Arguments:
//    rects: a list of rectangles defined as required for is_inside_rect
//    point: point coordinates as [xp, yp]
// Returns:  true if point is inside any of the rectangles from list, false otherwise.
function is_inside_rects_any(rects, point) = is_undef(rects) ? false : max(is_inside_rects(rects, point));

// Function:  is_outside_rect()
// Usage:
//   is_outside_rect(rect, point);
// Description:
//    Tells if point is outside rectangle.
// Arguments:
//    rect: two extremal vertices of a rectangle, as [[x0, y0], [x1, y1]]
//    point: point coordinates as [xp, yp]
// Returns:  true if point is outside rectangle, false otherwise.
function is_outside_rect(rect, point) = !is_inside_rect(rect, point);

// Function:  is_outside_rects()
// Usage:
//   is_outside_rects(rects, point);
// Description:
//    Tells if point is outside a list of rectangles.
// Arguments:
//    rects: a list of rectangles defined as required for is_outside_rect
//    point: point coordinates as [xp, yp]
// Returns:  a list of booleans, which, for each rectangle, are true if point is outside, false otherwise.
function is_outside_rects(rects, point) = is_undef(rects) ? true : [for (rect = rects) is_outside_rect(rect, point)];

// Function:  is_outside_rects_all()
// Usage:
//   is_outside_rects_all(rects, point);
// Description:
//    Tells if point is outside every rectangle from a list.
// Arguments:
//    rects: a list of rectangles defined as required for is_outside_rect
//    point: point coordinates as [xp, yp]
// Returns:  true if point is outside all rectangles, false otherwise.
function is_outside_rects_all(rects, point) = is_undef(rects) ? true : min(is_outside_rects(rects, point));

// Function:  is_outside_rects_any()
// Usage:
//   is_outside_rects_any(rects, point);
// Description:
//    Tells if point is outside one of the rectangles from a list.
// Arguments:
//    rectangles: a list of rectangles defined as required for is_outside_rect
//    point: point coordinates as [xp, yp]
// Returns:  true if point is outside any of the rectangles from list, false otherwise.
function is_outside_rects_any(rects, point) = is_undef(rects) ? true : max(is_outside_rects(rects, point));


// Function:  is_inside_circle()
// Usage:
//   is_inside_circle(circle_centre, circle_radius, point);
// Description:
//    Tells if point is inside circle.
// Arguments:
//    circle_centre: coordinates of circle centre as [xc, yc]
//    circle_radius: circle radius
//    point: point coordinates as [xp, yp]
// Returns:  true if point is inside circle (or on its boundary), false otherwise.
function is_inside_circle(circle_centre, circle_radius, point) = (point.x - circle_centre.x)^2 + (point.y - circle_centre.y)^2 < circle_radius^2;

// Function:  is_inside_circles()
// Usage:
//   is_inside_circles(circles, point);
// Description:
//    Tells if point is inside a list of circles.
// Arguments:
//    circles: a list of circles defined as [circle_centre = [xc, yc], circle_radius]
//    point: point coordinates as [xp, yp]
// Returns:  a list of booleans, which, for each circle, are true if point is inside (or on its boundary), false otherwise.
function is_inside_circles(circles, point) = is_undef(circles) ? false : [for (circle = circles) is_inside_circle(circle[0], circle[1], point)];

// Function:  is_inside_circles_all()
// Usage:
//   is_inside_circles_all(circles, point);
// Description:
//    Tells if point is inside every circle from a list.
// Arguments:
//    circles: a list of circles defined as for is_inside_circles
//    point: point coordinates as [xp, yp]
// Returns:  true if point is inside all rectangles, false otherwise.
function is_inside_circles_all(circles, point) = is_undef(circles) ? false : min(is_inside_circles(circles, point));

// Function:  is_inside_circles_any()
// Usage:
//   is_inside_circles_any(circles, point);
// Description:
//    Tells if point is inside one of the circles from a list.
// Arguments:
//    circles: a list of circles defined as for is_inside_circles
//    point: point coordinates as [xp, yp]
// Returns:  true if point is inside any of the circles from list, false otherwise.
function is_inside_circles_any(circles, point) = is_undef(circles) ? false : max(is_inside_circles(circles, point));

// Function:  is_outside_circle()
// Usage:
//   is_outside_circle(circle_centre, circle_radius, point);
// Description:
//    Tells if point is outside circle.
// Arguments:
//    circle_centre: coordinates of circle centre as [xc, yc]
//    circle_radius: circle radius
//    point: point coordinates as [xp, yp]
// Returns:  true if point is outside circle, false otherwise.
function is_outside_circle(circle_centre, circle_radius, point) = !is_inside_circle(circle_centre, circle_radius, point);

// Function:  is_outside_circles()
// Usage:
//   is_outside_circles(circles, point);
// Description:
//    Tells if point is outside a list of circles.
// Arguments:
//    circles: a list of circles defined as [circle_centre = [xc, yc], circle_radius]
//    point: point coordinates as [xp, yp]
// Returns:  a list of booleans, which, for each circle, are true if point is outside, false otherwise.
function is_outside_circles(circles, point) = is_undef(circles) ? true : [for (circle = circles) is_outside_circle(circle[0], circle[1], point)];

// Function:  is_outside_circles_all()
// Usage:
//   is_outside_circles_all(circles, point);
// Description:
//    Tells if point is outside every circle from a list.
// Arguments:
//    circles: a list of circles defined as for is_outside_circles
//    point: point coordinates as [xp, yp]
// Returns:  true if point is outside all rectangles, false otherwise.
function is_outside_circles_all(circles, point) = is_undef(circles) ? true : min(is_outside_circles(circles, point));

// Function:  is_outside_circles_any()
// Usage:
//   is_outside_circles_any(circles, point);
// Description:
//    Tells if point is outside one of the circles from a list.
// Arguments:
//    circles: a list of circles defined as for is_outside_circles
//    point: point coordinates as [xp, yp]
// Returns:  true if point is outside any of the circles from list, false otherwise.
function is_outside_circles_any(circles, point) = is_undef(circles) ? true : max(is_outside_circles(circles, point));


// Function:  is_inside_sphere()
// Usage:
//   is_inside_sphere(sphere_centre, sphere_radius, point);
// Description:
//    Tells if point is inside sphere.
// Arguments:
//    sphere_centre: coordinates of sphere centre as [xc, yc, zc]
//    sphere_radius: sphere radius
//    point: point coordinates as [xp, yp, zp]
// Returns:  true if point is inside sphere (or on its boundary), false otherwise.
function is_inside_sphere(sphere_centre, sphere_radius, point) = (point.x - sphere_centre.x)^2 + (point.y - sphere_centre.y)^2 + (point.z - sphere_centre.z)^2 < sphere_radius^2;

// Function:  is_inside_spheres()
// Usage:
//   is_inside_spheres(spheres, point);
// Description:
//    Tells if point is inside a list of spheres.
// Arguments:
//    spheres: a list of spheres defined as [sphere_centre = [xc, yc, zc], sphere_radius]
//    point: point coordinates as [xp, yp, zp]
// Returns:  a list of booleans, which, for each sphere, are true if point is inside (or on its surface), false otherwise.
function is_inside_spheres(spheres, point) = is_undef(spheres) ? false : [for (sphere = spheres) is_inside_sphere(sphere[0], sphere[1], point)];

// Function:  is_inside_spheres_all()
// Usage:
//   is_inside_spheres_all(spheres, point);
// Description:
//    Tells if point is inside every sphere from a list.
// Arguments:
//    spheres: a list of spheres defined as for is_inside_spheres
//    point: point coordinates as [xp, yp, zp]
// Returns:  true if point is inside all spheres, false otherwise.
function is_inside_spheres_all(spheres, point) = is_undef(spheres) ? false : min(is_inside_spheres(spheres, point));

// Function:  is_inside_spheres_any()
// Usage:
//   is_inside_spheres_any(spheres, point);
// Description:
//    Tells if point is inside one of the spheres from a list.
// Arguments:
//    spheres: a list of spheres defined as for is_inside_spheres
//    point: point coordinates as [xp, yp, zp]
// Returns:  true if point is inside any of the spheres from list, false otherwise.
function is_inside_spheres_any(spheres, point) = is_undef(spheres) ? false : max(is_inside_spheres(spheres, point));

// Function:  is_outside_sphere()
// Usage:
//   is_outside_sphere(sphere_centre, sphere_radius, point);
// Description:
//    Tells if point is outside sphere.
// Arguments:
//    sphere_centre: coordinates of sphere centre as [xc, yc, zc]
//    sphere_radius: sphere radius
//    point: point coordinates as [xp, yp, zp]
// Returns:  true if point is outside sphere, false otherwise.
function is_outside_sphere(sphere_centre, sphere_radius, point) = !is_inside_sphere(sphere_centre, sphere_radius, point);

// Function:  is_outside_spheres()
// Usage:
//   is_outside_spheres(spheres, point);
// Description:
//    Tells if point is outside a list of spheres.
// Arguments:
//    spheres: a list of spheres defined as [sphere_centre = [xc, yc, zc], sphere_radius]
//    point: point coordinates as [xp, yp, zp]
// Returns:  a list of booleans, which, for each sphere, are true if point is outside, false otherwise.
function is_outside_spheres(spheres, point) = is_undef(spheres) ? true : [for (sphere = spheres) is_outside_sphere(sphere[0], sphere[1], point)];

// Function:  is_outside_spheres_all()
// Usage:
//   is_outside_spheres_all(spheres, point);
// Description:
//    Tells if point is outside every sphere from a list.
// Arguments:
//    spheres: a list of spheres defined as for is_outside_spheres
//    point: point coordinates as [xp, yp, zp]
// Returns:  true if point is outside all spheres, false otherwise.
function is_outside_spheres_all(spheres, point) = is_undef(spheres) ? true : min(is_outside_spheres(spheres, point));

// Function:  is_outside_spheres_any()
// Usage:
//   is_outside_spheres_any(spheres, point);
// Description:
//    Tells if point is outside one of the spheres from a list.
// Arguments:
//    spheres: a list of spheres defined as for is_outside_spheres
//    point: point coordinates as [xp, yp, zp]
// Returns:  true if point is outside any of the spheres from list, false otherwise.
function is_outside_spheres_any(spheres, point) = is_undef(spheres) ? true : max(is_outside_spheres(spheres, point));


// Function:  quicksort()
// Usage:
//   quicksort(arr);
// Description:
//    Sorts array using quicksort algorithm.
// Arguments:
//    arr: array to sort
// Returns:  sorted array in increasing order.
function quicksort(arr) = 
  !(len(arr)>0) ? [] : 
      let(  pivot   = arr[floor(len(arr)/2)], 
            lesser  = [ for (y = arr) if (y  < pivot) y ], 
            equal   = [ for (y = arr) if (y == pivot) y ], 
            greater = [ for (y = arr) if (y  > pivot) y ]
      ) 
      concat( quicksort(lesser), equal, quicksort(greater) );

// Function:  argsort()
// Usage:
//   argsort(arr);
// Description:
//    Sorts array and returns sorting order rather than sorted array.
// Arguments:
//    arr: array to sort
// Returns:  indices of unsorted array content in sorted array.
function argsort(arr) =
    let (sortarr = quicksort(arr)) [ for (y = sortarr) search(y, arr)];
