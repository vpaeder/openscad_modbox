# LibFile: toolbox.scad
This file contains low-level modules and functions used in box\_parts.scad but with
a potentially wider field of application.

To use, add the following lines to the beginning of your file:

    use <toolbox.scad>;

---

# Table of Contents

1. [Section: modules](#section-modules)
    - [`bevel()`](#module-bevel)
    - [`extruded_rounded_rectangle()`](#module-extruded_rounded_rectangle)
    - [`rounded_cube()`](#module-rounded_cube)
    - [`rounded_rect_hole()`](#module-rounded_rect_hole)
    - [`chamfered_rect_hole()`](#module-chamfered_rect_hole)
    - [`rounded_circular_edge()`](#module-rounded_circular_edge)
    - [`rounded_circular_hole()`](#module-rounded_circular_hole)
    - [`fill_with_pattern()`](#module-fill_with_pattern)

2. [Section: functions](#section-functions)
    - [`is_inside_box()`](#function-is_inside_box)
    - [`is_inside_boxes()`](#function-is_inside_boxes)
    - [`is_inside_boxes_all()`](#function-is_inside_boxes_all)
    - [`is_inside_boxes_any()`](#function-is_inside_boxes_any)
    - [`is_outside_box()`](#function-is_outside_box)
    - [`is_outside_boxes()`](#function-is_outside_boxes)
    - [`is_outside_boxes_all()`](#function-is_outside_boxes_all)
    - [`is_outside_boxes_any()`](#function-is_outside_boxes_any)
    - [`is_inside_rect()`](#function-is_inside_rect)
    - [`is_inside_rects()`](#function-is_inside_rects)
    - [`is_inside_rects_all()`](#function-is_inside_rects_all)
    - [`is_inside_rects_any()`](#function-is_inside_rects_any)
    - [`is_outside_rect()`](#function-is_outside_rect)
    - [`is_outside_rects()`](#function-is_outside_rects)
    - [`is_outside_rects_all()`](#function-is_outside_rects_all)
    - [`is_outside_rects_any()`](#function-is_outside_rects_any)
    - [`is_inside_circle()`](#function-is_inside_circle)
    - [`is_inside_circles()`](#function-is_inside_circles)
    - [`is_inside_circles_all()`](#function-is_inside_circles_all)
    - [`is_inside_circles_any()`](#function-is_inside_circles_any)
    - [`is_outside_circle()`](#function-is_outside_circle)
    - [`is_outside_circles()`](#function-is_outside_circles)
    - [`is_outside_circles_all()`](#function-is_outside_circles_all)
    - [`is_outside_circles_any()`](#function-is_outside_circles_any)
    - [`is_inside_sphere()`](#function-is_inside_sphere)
    - [`is_inside_spheres()`](#function-is_inside_spheres)
    - [`is_inside_spheres_all()`](#function-is_inside_spheres_all)
    - [`is_inside_spheres_any()`](#function-is_inside_spheres_any)
    - [`is_outside_sphere()`](#function-is_outside_sphere)
    - [`is_outside_spheres()`](#function-is_outside_spheres)
    - [`is_outside_spheres_all()`](#function-is_outside_spheres_all)
    - [`is_outside_spheres_any()`](#function-is_outside_spheres_any)
    - [`quicksort()`](#function-quicksort)
    - [`argsort()`](#function-argsort)

---

## Section: modules

### Module: bevel()

**Usage:** 
- bevel(point\_start, point\_end, radius, quadrant, resolution);

**Description:** 
Bevels an edge (if children are provided) or creates a shape for beveling an edge.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`point_start : starting point, in the form of a vector [x,y,z]`
`point_end : end point, in the form of a vector [x,y,z]`
`radius : beveling radius`
`quadrant : bevel orientation (1` | up-left, 2 = up-right, 3 = down-right, 4 = down-left)
`resolution : beveling resolution (number of segments per 360 degrees, 0` | automatic)

---

### Module: extruded\_rounded\_rectangle()

**Usage:** 
- extruded\_rounded\_rectangle(xyz, radius, resolution);

**Description:** 
Produces a cuboid with 4 rounded edges, akin to an extruded rounded rectangle.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`xyz: cuboid size as [length, width, height]`
`radius : beveling radius for edges`
`resolution : beveling resolution (number of segments per 360 degrees, 0` | automatic)

---

### Module: rounded\_cube()

**Usage:** 
- rounded\_cube(xyz, radius, resolution, sharp\_vertices);

**Description:** 
Produces a cuboid with all edges rounded.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`xyz: cuboid size as [length, width, height]`
`radius : beveling radius for edges`
`resolution : beveling resolution (number of segments per 360 degrees, 0` | automatic)
`sharp_vertices : if true, produces a cuboid with angled vertices; if false (default), vertices are rounded.`

---

### Module: rounded\_rect\_hole()

**Usage:** 
- rounded\_rect\_hole(xyz, radius, resolution);

**Description:** 
Creates a rectangular hole with rounded edges in module children.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`xyz: hole size as [length, width, height]`
`radius : beveling radius for edges`
`resolution : beveling resolution (number of segments per 360 degrees, 0` | automatic)

---

### Module: chamfered\_rect\_hole()

**Usage:** 
- chamfered\_rect\_hole(xyz, width);

**Description:** 
Creates a rectangular hole with chamfered edges in module children.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`xyz: hole size as [length, width, height]`
`width : chamfer width`

---

### Module: rounded\_circular\_edge()

**Usage:** 
- rounded\_circular\_edge(circle\_radius, rounding\_radius, resolution, inside\_circle);

**Description:** 
Creates a rounded edge on the inside or outside (default) of a circle.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`circle_radius: circle radius`
`rounding_radius: edge rounding radius`
`resolution : rounding resolution (number of segments per 360 degrees, 0` | automatic)
`inside_circle: if true, rounded edge is created inside circle; if false, edge is outside (default)`

---

### Module: rounded\_circular\_hole()

**Usage:** 
- rounded\_circular\_hole(circle\_radius, depth, rounding\_radius, resolution);

**Description:** 
Creates a circular hole with rounded edge in module children.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`circle_radius: hole radius`
`depth: hole depth` 
`rounding_radius: edge rounding radius`

---

### Module: fill\_with\_pattern()

**Usage:** 
- fill\_with\_pattern(point\_min, point\_max, period\_x, period\_y, exclusion\_rects, exclusion\_circles);

**Description:** 
Fills the rectangular area between point\_min and point\_max with module children.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`point_min : coordinates of top left corner as [x, y]`
`point_max : coordinates of bottom right corner as [x, y]`
`period_x : pattern period in longitudinal direction`
`period_y : pattern period in lateral direction`
`exclusion_rects : optional list of rectangles inside which pattern won't be drawn, as [[x0, y0], [x1, y1]]`
`exclusion_circles : optional list of circles inside which pattern won't be drawn, as [[cx, cy], radius]`

---

## Section: functions

### Function: is\_inside\_box()

**Usage:** 
- is\_inside\_box(box, point);

**Description:** 
Tells if point is inside box.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`box: two extremal vertices of a cuboid, as [[x0, y0, z0], [x1, y1, z1]]`
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
true if point is inside box (or on its surface), false otherwise.

---

### Function: is\_inside\_boxes()

**Usage:** 
- is\_inside\_boxes(boxes, point);

**Description:** 
Tells if point is inside a list of boxes.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`boxes: a list of boxes defined as required for is_inside_box`
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
a list of booleans, which, for each box, are true if point is inside (or on its surface), false otherwise.

---

### Function: is\_inside\_boxes\_all()

**Usage:** 
- is\_inside\_boxes\_all(boxes, point);

**Description:** 
Tells if point is inside every box from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`boxes: a list of boxes defined as required for is_inside_box`
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
true if point is inside all boxes, false otherwise.

---

### Function: is\_inside\_boxes\_any()

**Usage:** 
- is\_inside\_boxes\_any(boxes, point);

**Description:** 
Tells if point is inside one of the boxes from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`boxes: a list of boxes defined as required for is_inside_box`
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
true if point is inside any of the boxes from list, false otherwise.

---

### Function: is\_outside\_box()

**Usage:** 
- is\_outside\_box(box, point);

**Description:** 
Tells if point is outside box.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`box: two extremal vertices of a cuboid, as [[x0, y0, z0], [x1, y1, z1]]`
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
true if point is outside box, false otherwise.

---

### Function: is\_outside\_boxes()

**Usage:** 
- is\_outside\_boxes(boxes, point);

**Description:** 
Tells if point is outside a list of boxes.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`boxes: a list of boxes defined as required for is_outside_box`
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
a list of booleans, which, for each box, are true if point is outside, false otherwise.

---

### Function: is\_outside\_boxes\_all()

**Usage:** 
- is\_outside\_boxes\_all(boxes, point);

**Description:** 
Tells if point is outside every box from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`boxes: a list of boxes defined as required for is_outside_box`
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
true if point is outside all boxes, false otherwise.

---

### Function: is\_outside\_boxes\_any()

**Usage:** 
- is\_outside\_boxes\_any(boxes, point);

**Description:** 
Tells if point is outside one of the boxes from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`boxes: a list of boxes defined as required for is_outside_box`
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
true if point is outside any of the boxes from list, false otherwise.

---

### Function: is\_inside\_rect()

**Usage:** 
- is\_inside\_rect(rect, point);

**Description:** 
Tells if point is inside rectangle.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`box: two extremal vertices of a rectangle, as [[x0, y0], [x1, y1]]`
`point: point coordinates as [xp, yp]`

**Returns:** 
true if point is inside rectangle (or on its boundary), false otherwise.

---

### Function: is\_inside\_rects()

**Usage:** 
- is\_inside\_rects(rects, point);

**Description:** 
Tells if point is inside a list of rectangles.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`rects: a list of rectangles defined as required for is_inside_rect`
`point: point coordinates as [xp, yp]`

**Returns:** 
a list of booleans, which, for each rectangle, are true if point is inside (or on its boundary), false otherwise.

---

### Function: is\_inside\_rects\_all()

**Usage:** 
- is\_inside\_rects\_all(boxes, point);

**Description:** 
Tells if point is inside every rectangle from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`rects: a list of rectangles defined as required for is_inside_rect`
`point: point coordinates as [xp, yp]`

**Returns:** 
true if point is inside all rectangles, false otherwise.

---

### Function: is\_inside\_rects\_any()

**Usage:** 
- is\_inside\_rects\_any(rects, point);

**Description:** 
Tells if point is inside one of the rectangles from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`rects: a list of rectangles defined as required for is_inside_rect`
`point: point coordinates as [xp, yp]`

**Returns:** 
true if point is inside any of the rectangles from list, false otherwise.

---

### Function: is\_outside\_rect()

**Usage:** 
- is\_outside\_rect(rect, point);

**Description:** 
Tells if point is outside rectangle.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`rect: two extremal vertices of a rectangle, as [[x0, y0], [x1, y1]]`
`point: point coordinates as [xp, yp]`

**Returns:** 
true if point is outside rectangle, false otherwise.

---

### Function: is\_outside\_rects()

**Usage:** 
- is\_outside\_rects(rects, point);

**Description:** 
Tells if point is outside a list of rectangles.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`rects: a list of rectangles defined as required for is_outside_rect`
`point: point coordinates as [xp, yp]`

**Returns:** 
a list of booleans, which, for each rectangle, are true if point is outside, false otherwise.

---

### Function: is\_outside\_rects\_all()

**Usage:** 
- is\_outside\_rects\_all(rects, point);

**Description:** 
Tells if point is outside every rectangle from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`rects: a list of rectangles defined as required for is_outside_rect`
`point: point coordinates as [xp, yp]`

**Returns:** 
true if point is outside all rectangles, false otherwise.

---

### Function: is\_outside\_rects\_any()

**Usage:** 
- is\_outside\_rects\_any(rects, point);

**Description:** 
Tells if point is outside one of the rectangles from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`rectangles: a list of rectangles defined as required for is_outside_rect`
`point: point coordinates as [xp, yp]`

**Returns:** 
true if point is outside any of the rectangles from list, false otherwise.

---

### Function: is\_inside\_circle()

**Usage:** 
- is\_inside\_circle(circle\_centre, circle\_radius, point);

**Description:** 
Tells if point is inside circle.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`circle_centre: coordinates of circle centre as [xc, yc]`
`circle_radius: circle radius`
`point: point coordinates as [xp, yp]`

**Returns:** 
true if point is inside circle (or on its boundary), false otherwise.

---

### Function: is\_inside\_circles()

**Usage:** 
- is\_inside\_circles(circles, point);

**Description:** 
Tells if point is inside a list of circles.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`circles: a list of circles defined as [circle_centre` | [xc, yc], circle\_radius]
`point: point coordinates as [xp, yp]`

**Returns:** 
a list of booleans, which, for each circle, are true if point is inside (or on its boundary), false otherwise.

---

### Function: is\_inside\_circles\_all()

**Usage:** 
- is\_inside\_circles\_all(circles, point);

**Description:** 
Tells if point is inside every circle from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`circles: a list of circles defined as for is_inside_circles`
`point: point coordinates as [xp, yp]`

**Returns:** 
true if point is inside all rectangles, false otherwise.

---

### Function: is\_inside\_circles\_any()

**Usage:** 
- is\_inside\_circles\_any(circles, point);

**Description:** 
Tells if point is inside one of the circles from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`circles: a list of circles defined as for is_inside_circles`
`point: point coordinates as [xp, yp]`

**Returns:** 
true if point is inside any of the circles from list, false otherwise.

---

### Function: is\_outside\_circle()

**Usage:** 
- is\_outside\_circle(circle\_centre, circle\_radius, point);

**Description:** 
Tells if point is outside circle.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`circle_centre: coordinates of circle centre as [xc, yc]`
`circle_radius: circle radius`
`point: point coordinates as [xp, yp]`

**Returns:** 
true if point is outside circle, false otherwise.

---

### Function: is\_outside\_circles()

**Usage:** 
- is\_outside\_circles(circles, point);

**Description:** 
Tells if point is outside a list of circles.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`circles: a list of circles defined as [circle_centre` | [xc, yc], circle\_radius]
`point: point coordinates as [xp, yp]`

**Returns:** 
a list of booleans, which, for each circle, are true if point is outside, false otherwise.

---

### Function: is\_outside\_circles\_all()

**Usage:** 
- is\_outside\_circles\_all(circles, point);

**Description:** 
Tells if point is outside every circle from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`circles: a list of circles defined as for is_outside_circles`
`point: point coordinates as [xp, yp]`

**Returns:** 
true if point is outside all rectangles, false otherwise.

---

### Function: is\_outside\_circles\_any()

**Usage:** 
- is\_outside\_circles\_any(circles, point);

**Description:** 
Tells if point is outside one of the circles from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`circles: a list of circles defined as for is_outside_circles`
`point: point coordinates as [xp, yp]`

**Returns:** 
true if point is outside any of the circles from list, false otherwise.

---

### Function: is\_inside\_sphere()

**Usage:** 
- is\_inside\_sphere(sphere\_centre, sphere\_radius, point);

**Description:** 
Tells if point is inside sphere.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`sphere_centre: coordinates of sphere centre as [xc, yc, zc]`
`sphere_radius: sphere radius`
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
true if point is inside sphere (or on its boundary), false otherwise.

---

### Function: is\_inside\_spheres()

**Usage:** 
- is\_inside\_spheres(spheres, point);

**Description:** 
Tells if point is inside a list of spheres.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`spheres: a list of spheres defined as [sphere_centre` | [xc, yc, zc], sphere\_radius]
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
a list of booleans, which, for each sphere, are true if point is inside (or on its surface), false otherwise.

---

### Function: is\_inside\_spheres\_all()

**Usage:** 
- is\_inside\_spheres\_all(spheres, point);

**Description:** 
Tells if point is inside every sphere from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`spheres: a list of spheres defined as for is_inside_spheres`
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
true if point is inside all spheres, false otherwise.

---

### Function: is\_inside\_spheres\_any()

**Usage:** 
- is\_inside\_spheres\_any(spheres, point);

**Description:** 
Tells if point is inside one of the spheres from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`spheres: a list of spheres defined as for is_inside_spheres`
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
true if point is inside any of the spheres from list, false otherwise.

---

### Function: is\_outside\_sphere()

**Usage:** 
- is\_outside\_sphere(sphere\_centre, sphere\_radius, point);

**Description:** 
Tells if point is outside sphere.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`sphere_centre: coordinates of sphere centre as [xc, yc, zc]`
`sphere_radius: sphere radius`
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
true if point is outside sphere, false otherwise.

---

### Function: is\_outside\_spheres()

**Usage:** 
- is\_outside\_spheres(spheres, point);

**Description:** 
Tells if point is outside a list of spheres.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`spheres: a list of spheres defined as [sphere_centre` | [xc, yc, zc], sphere\_radius]
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
a list of booleans, which, for each sphere, are true if point is outside, false otherwise.

---

### Function: is\_outside\_spheres\_all()

**Usage:** 
- is\_outside\_spheres\_all(spheres, point);

**Description:** 
Tells if point is outside every sphere from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`spheres: a list of spheres defined as for is_outside_spheres`
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
true if point is outside all spheres, false otherwise.

---

### Function: is\_outside\_spheres\_any()

**Usage:** 
- is\_outside\_spheres\_any(spheres, point);

**Description:** 
Tells if point is outside one of the spheres from a list.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`spheres: a list of spheres defined as for is_outside_spheres`
`point: point coordinates as [xp, yp, zp]`

**Returns:** 
true if point is outside any of the spheres from list, false otherwise.

---

### Function: quicksort()

**Usage:** 
- quicksort(arr);

**Description:** 
Sorts array using quicksort algorithm.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`arr: array to sort`

**Returns:** 
sorted array in increasing order.

---

### Function: argsort()

**Usage:** 
- argsort(arr);

**Description:** 
Sorts array and returns sorting order rather than sorted array.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`arr: array to sort`

**Returns:** 
indices of unsorted array content in sorted array.

