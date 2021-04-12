# LibFile: box\_parts.scad
This file contains modules to generate rectangular box parts and a number
of snap-fit accessories.

To use, add the following lines to the beginning of your file:

    use <box_parts.scad>;

---

# Table of Contents

1. [Section: Accessories](#section-accessories)
    - [`snap_joint_female()`](#module-snap_joint_female)
    - [`snap_joint_male()`](#module-snap_joint_male)
    - [`snap_joint_female_block()`](#module-snap_joint_female_block)
    - [`snap_joint_male_block()`](#module-snap_joint_male_block)
    - [`screw_mount()`](#module-screw_mount)
    - [`screw_standoff()`](#module-screw_standoff)
    - [`case_clip()`](#module-case_clip)
    - [`hollowing_pattern()`](#module-hollowing_pattern)
    - [`case_top()`](#module-case_top)
    - [`case_bottom()`](#module-case_bottom)
    - [`case_support()`](#module-case_support)

---

## Section: Accessories


### Module: snap\_joint\_female()

**Usage:** 
- snap\_joint\_female(length, wall\_thickness, rmin, rmax, with\_cross);

**Description:** 
Generates a female circular snap-fit connector.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`length`             | connector length
`wall_thickness`     | thickness of connector wall
`rmin`               | radius of male connector shaft
`rmax`               | radius of male connector hub
`with_cross`         | if true, cuts a cross through connector to make it more flexible

---

### Module: snap\_joint\_male()

**Usage:** 
- snap\_joint\_male(length, wall\_thickness, rmin, rmax, with\_cross);

**Description:** 
Generates a male circular snap-fit connector.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`length`             | connector length
`wall_thickness`     | thickness of connector wall
`rmin`               | radius of connector shaft
`rmax`               | radius of connector hub
`with_cross`         | if true, cuts a cross through connector to make it more flexible

---

### Module: snap\_joint\_female\_block()

**Usage:** 
- snap\_joint\_female\_block(length, width, rmin, rmax, bevel\_radius, bevel\_resolution);

**Description:** 
Generates a female circular snap-fit connector within a rounded cuboid.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`length`             | cuboid length
`width`              | cuboid width
`rmin`               | radius of male connector shaft
`rmax`               | radius of male connector hub
`bevel_radius`       | beveling radius
`bevel_resolution`   | beveling resolution (number of segments per 360 degrees, 0 = automatic)

---

### Module: snap\_joint\_male\_block()

**Usage:** 
- snap\_joint\_male\_block(length, width, rmin, rmax, bevel\_radius, bevel\_resolution);

**Description:** 
Generates a male circular snap-fit connector atop a rounded cuboid.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`length`             | cuboid length
`width`              | cuboid width
`rmin`               | radius of connector shaft
`rmax`               | radius of connector hub
`bevel_radius`       | beveling radius
`bevel_resolution`   | beveling resolution (number of segments per 360 degrees, 0 = automatic)

---

### Module: screw\_mount()

**Usage:** 
- screw\_mount(height, mount\_radius, hole\_radius, bevel\_radius, bevel\_resolution)

**Description:** 
Generates a circular mount with a beveled base and a hole along axis.
height = mount height
mount\_radius = mount radius
hole\_radius = central hole radius
bevel\_radius = beveling radius
bevel\_resolution = beveling resolution (number of segments per 360 degrees, 0 = automatic)

---

### Module: screw\_standoff()

**Usage:** 
- screw\_standoff(height, standoff\_radius, hole\_radius, bevel\_radius, bevel\_resolution);

**Description:** 
Generates a circular standoff with a beveled base and a hole along axis.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`height`             | mount height
`standoff_radius`    | standoff radius
`hole_radius`        | central hole radius
`bevel_radius`       | beveling radius
`bevel_resolution`   | beveling resolution (number of segments per 360 degrees, 0 = automatic)

---

### Module: case\_clip()

**Usage:** 
- case\_clip(lwh, beam\_radius, hole\_displacement, bevel\_resolution);

**Description:** 
Generates a clip for a cylindrical beam.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`lwh`                | clip dimensions, as a vector [length, width, height]
`beam_radius`        | radius of cylindrical beam to fit
`hole_displacement`  | vertical displacement of hole centre
`bevel_resolution`   | beveling resolution (number of segments per 360 degrees, 0 = automatic)

---

### Module: hollowing\_pattern()

**Usage:** 
- hollowing\_pattern(x, y, thickness, radius, period);

**Description:** 
Generates a pattern unit cell, composed of cylinders, for hollowing out.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`x`                  | longitudinal position
`y`                  | lateral position
`thickness`          | pattern thickness
`radius`             | pattern elements radius
`period`             | pattern period

---

### Module: case\_top()

**Usage:** 
- case\_top(length, width, height, wall\_thickness, bevel\_resolution, connectors, snap\_joints, screws, hollowing\_out);

**Description:** 
Generates the top part of a case with modular features.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`length`             | case length
`width`              | case width
`height`             | case height
`wall_thickness`     | wall thickness
`bevel_resolution`   | beveling resolution (number of segments per 360 degrees, 0 = automatic)
`connectors`         | an optional list of up to two connector features, such as [[type (0=female, 1=male), width, height, offset\_x, offset\_y], ... ]
`snap_joints`        | an optional list of snap-fit joints features, such as [shaft\_radius, hub\_radius, length, [[position1\_x, position1\_y], [position2\_x, position2\_y], ...] ]
`screws`             | an optional list of screws positions and features, as [[hole\_radius, head\_radius, mount\_height, [position\_x, position\_y]], ... ]
`hollowing_out`      | optional hollowing out settings, as [hollowing\_period, hollowing\_radius, exclusion\_rects, exclusion\_circles]

---

### Module: case\_bottom()

**Usage:** 
- case\_bottom(length, width, wall\_thickness, bevel\_resolution, screws, clips, hollowing\_out);

**Description:** 
Generates the bottom part of a case with modular features.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`length`             | case length
`width`              | case width
`wall_thickness`     | wall thickness
`bevel_resolution`   | beveling resolution (number of segments per 360 degrees, 0 = automatic)
`screws`             | an optional list of screws positions and features, as [[hole\_radius, head\_radius, standoff\_height, [position\_x, position\_y]], ... ]
`clips`              | an optional list of clips, as [length, width, height, beam\_radius, hole\_offset, [[leg1\_x, leg1\_y], [leg2\_x, leg2\_y],...] ]
`hollowing_out`      | optional hollowing out settings, as [hollowing\_period, hollowing\_radius, exclusion\_rects, exclusion\_circles]

---

### Module: case\_support()

**Usage:** 
- case\_support(case\_length, case\_width, wall\_thickness, bevel\_resolution, clips, snap\_joints, hollowing\_out);

**Description:** 
Generates a foldable leg to be clipped behind a modular case.

**Arguments:** 
<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`case_length`        | case length
`case_width`         | case width
`wall_thickness`     | wall thickness
`bevel_resolution`   | beveling resolution (number of segments per 360 degrees, 0 = automatic)
`screws`             | an optional list of screws positions and features, as [[hole\_radius, head\_radius, standoff\_height, [position\_x, position\_y]], ... ]
`clips`              | an optional list of clips, as [length, width, height, hole\_radius, hole\_offset, [[leg1\_x, leg1\_y], [leg2\_x, leg2\_y],...] ]; this will be used to leave leeway around clips
`snap_joints`        | optional list of snap-fit joints features, as [shaft\_radius, hub\_radius, length, [type\_side1 = 0 (none), 1 (female), 2 (male), type\_side2] ]
`hollowing_out`      | optional hollowing out settings, as [hollowing\_period, hollowing\_radius, exclusion\_rects, exclusion\_circles]

