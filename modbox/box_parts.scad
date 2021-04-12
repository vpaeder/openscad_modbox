// LibFile: box_parts.scad
//   This file contains modules to generate rectangular box parts and a number
//   of snap-fit accessories.
// Includes:
//   use <box_parts.scad>;

use <toolbox.scad>;

// Section: Accessories
//   

// Module:  snap_joint_female()
// Usage:
//   snap_joint_female(length, wall_thickness, rmin, rmax, with_cross);
// Description:
//    Generates a female circular snap-fit connector.
// Arguments:
//    length = connector length
//    wall_thickness = thickness of connector wall
//    rmin = radius of male connector shaft
//    rmax = radius of male connector hub
//    with_cross = if true, cuts a cross through connector to make it more flexible
module snap_joint_female(length, wall_thickness, rmin, rmax, with_cross) {
    difference() {
        union() {
            rotate([0, 90, 0]) {
                // cylinder
                cylinder(h=length, r=rmin+wall_thickness, center=true);
                // ball
                translate([0, 0, length - rmax]) sphere(r=rmax+wall_thickness);
            }
            // rounded base
            translate([-length/2+wall_thickness/2-0.01, 0, 0]) rotate([0, 90, 0]) rounded_circular_edge(rmin+wall_thickness, wall_thickness, 0);
        }
        rotate([0, 90, 0]) union() {
            // hole through
            cylinder(h=length+2*wall_thickness+0.02, r=rmax, center=true);
            // ball volume
            translate([0, 0, length - rmax]) sphere(r=rmax);
            // cross
            if (with_cross) {
                translate([-wall_thickness/4, -rmax-2*wall_thickness, -length/2 - wall_thickness]) cube([wall_thickness/2, 2*rmax + 4*wall_thickness, length+4*wall_thickness+0.02]);
                translate([-rmax-2*wall_thickness, -wall_thickness/4, -length/2 - wall_thickness]) cube([2*rmax + 4*wall_thickness, wall_thickness/2, length+4*wall_thickness+0.02]);
            }
            // end cut
            translate([-rmax-2*wall_thickness, -rmax-2*wall_thickness, length-wall_thickness/2]) cube([2*rmax+4*wall_thickness, 2*rmax + 4*wall_thickness, 1.5*wall_thickness]);
        }
    }
}


// Module:  snap_joint_male()
// Usage:
//   snap_joint_male(length, wall_thickness, rmin, rmax, with_cross);
// Description:
//    Generates a male circular snap-fit connector.
// Arguments:
//    length = connector length
//    wall_thickness = thickness of connector wall
//    rmin = radius of connector shaft
//    rmax = radius of connector hub
//    with_cross = if true, cuts a cross through connector to make it more flexible
module snap_joint_male(length, wall_thickness, rmin, rmax, with_cross) {
    difference() {
        union() {
            translate([length/2, 0, 0]) rotate([0, 90, 0]) {
                // cylinder
                cylinder(h=length, r=rmin, center=true);
                // ball
                translate([0, 0, length - rmax]) sphere(r=rmax);
            }
            // rounded base
            translate([wall_thickness/2-0.01, 0, 0]) rotate([0, 90, 0]) rounded_circular_edge(rmin, wall_thickness, 0);
        }
        if (with_cross) translate([length/2 + wall_thickness/2, 0, 0]) rotate([0, 90, 0]) union() {
            // cross
            rotate([0, 0, 45]) cube([wall_thickness/2, 2*rmax, length+rmax+wall_thickness+0.02], center=true);
            rotate([0, 0, 45]) cube([2*rmax, wall_thickness/2, length+rmax+wall_thickness+0.02], center=true);
        }
    }
}


// Module:  snap_joint_female_block()
// Usage:
//   snap_joint_female_block(length, width, rmin, rmax, bevel_radius, bevel_resolution);
// Description:
//    Generates a female circular snap-fit connector within a rounded cuboid.
// Arguments:
//    length = cuboid length
//    width = cuboid width
//    rmin = radius of male connector shaft
//    rmax = radius of male connector hub
//    bevel_radius = beveling radius
//    bevel_resolution = beveling resolution (number of segments per 360 degrees, 0 = automatic)
module snap_joint_female_block(length, width, rmin, rmax, bevel_radius, bevel_resolution) {
    dr = rmax - rmin;
    difference() {
        // square block
        rounded_cube([length, width, width], bevel_radius, bevel_resolution);
        // hole
        translate([0, width/2, width/2]) rotate([0, 90, 0]) cylinder(h=2*rmax, r=rmin, center=true);
        // cavity
        translate([dr + rmax, width/2, width/2]) sphere(r = rmax);
        // chamfer
        translate([dr/2 - 0.01, width/2, width/2]) rotate([0, 90, 0]) cylinder(h=dr, r1=rmax, r2=rmin, center=true);
    }
}


// Module:  snap_joint_male_block()
// Usage:
//   snap_joint_male_block(length, width, rmin, rmax, bevel_radius, bevel_resolution);
// Description:
//    Generates a male circular snap-fit connector atop a rounded cuboid.
// Arguments:
//    length = cuboid length
//    width = cuboid width
//    rmin = radius of connector shaft
//    rmax = radius of connector hub
//    bevel_radius = beveling radius
//    bevel_resolution = beveling resolution (number of segments per 360 degrees, 0 = automatic)
module snap_joint_male_block(block_length, block_width, rmin, rmax, joint_length, bevel_radius, bevel_resolution) {
    dr = rmax - rmin;
    union() {
        // square block
        rounded_cube([block_length, block_width, block_width], bevel_radius, bevel_resolution);
        // pin
        translate([block_length, block_width/2, block_width/2]) snap_joint_male(joint_length, bevel_radius/2, rmin, rmax, true);
    }
}


// Module:  screw_mount()
// Usage:
//   screw_mount(height, mount_radius, hole_radius, bevel_radius, bevel_resolution)
// Description:
//    Generates a circular mount with a beveled base and a hole along axis.
//    height = mount height
//    mount_radius = mount radius
//    hole_radius = central hole radius
//    bevel_radius = beveling radius
//    bevel_resolution = beveling resolution (number of segments per 360 degrees, 0 = automatic)
module screw_mount(height, mount_radius, hole_radius, bevel_radius, bevel_resolution) {
    union() {
        // stand with hole
        translate([0, 0, height/2]) difference() {
            // stand
            cylinder(h=height, r = mount_radius, center=true);
            // hole
            cylinder(h=height + 0.02, r = hole_radius, center=true);
        }
    translate([0, 0, height - bevel_radius/2]) rotate([180, 0, 0]) rounded_circular_edge(mount_radius, bevel_radius, bevel_resolution);
    }
}


// Module:  screw_standoff()
// Usage:
//   screw_standoff(height, standoff_radius, hole_radius, bevel_radius, bevel_resolution);
// Description:
//    Generates a circular standoff with a beveled base and a hole along axis.
// Arguments:
//    height = mount height
//    standoff_radius = standoff radius
//    hole_radius = central hole radius
//    bevel_radius = beveling radius
//    bevel_resolution = beveling resolution (number of segments per 360 degrees, 0 = automatic)
module screw_standoff(height, standoff_radius, hole_radius, bevel_radius, bevel_resolution) {
    difference() {
        union() {
            // stand
            translate([0, 0, height/2]) 
            cylinder(h=height, r = standoff_radius, center=true);
            // rounded base
            translate([0, 0, bevel_radius/2]) rounded_circular_edge(standoff_radius, bevel_radius, bevel_resolution);
        }
        // hole
        translate([0, 0, height/2]) 
        cylinder(h=height + 0.02, r = hole_radius, center=true);
    }
}


// Module:  case_clip()
// Usage:
//   case_clip(lwh, beam_radius, hole_displacement, bevel_resolution);
// Description:
//    Generates a clip for a cylindrical beam.
// Arguments:
//    lwh = clip dimensions, as a vector [length, width, height]
//    beam_radius = radius of cylindrical beam to fit
//    hole_displacement = vertical displacement of hole centre
//    bevel_resolution = beveling resolution (number of segments per 360 degrees, 0 = automatic)
module case_clip(lwh, beam_radius, hole_displacement, bevel_resolution) {
    length = lwh[0];
    width = lwh[1];
    height = lwh[2];
    translate([-length/2, -width/2, -height/2]) difference() {
        // base cube
        cube([length, width, height]);
        // hole
        translate([-0.01, width/2, beam_radius+hole_displacement]) rotate([0, 90, 0]) cylinder(h = length+0.02, r = beam_radius);
        // rounded edge: top right side of hole
        translate([0, 0 + width/2 + 1, hole_displacement]) bevel([0,0,0], [length,0,0], 2, 1, bevel_resolution);
        // rounded edge: top left side of hole
        translate([0, 0 + width/2 - 1, hole_displacement]) bevel([0,0,0], [length,0,0], 2, 4, bevel_resolution);
        // rounded edge: top left of block
        translate([0, 0, 0]) bevel([0,0,0], [length,0,0], 4, 1, bevel_resolution);
        // rounded edge: top right of block
        translate([0, width, 0]) bevel([0,0,0], [length,0,0], 4, 4, bevel_resolution);
        // rounded edge: middle left of block
        translate([-0.01, -1.0, beam_radius]) rotate([0, 90, 0]) cylinder(h = length+0.02, r = beam_radius);
        translate([0, 1, -1]) rotate([3, 0, 0]) bevel([0,0,0], [length,0,0], 4, 1, bevel_resolution);
        // rounded edge: middle right of block
        translate([-0.01, width+1.0, beam_radius]) rotate([0, 90, 0]) cylinder(h = length+0.02, r = beam_radius);
        translate([0, width - 1, -1]) rotate([-3, 0, 0]) bevel([0,0,0], [length,0,0], 4, 4, bevel_resolution);
        // glitch cleanup above hole
        translate([-0.01, (width - beam_radius*1.5)/2, -0.5]) cube([length + 0.02, beam_radius*1.5, 1]);
    }
}


// Module:  hollowing_pattern()
// Usage:
//   hollowing_pattern(x, y, thickness, radius, period);
// Description:
//    Generates a pattern unit cell, composed of cylinders, for hollowing out.
// Arguments:
//    x = longitudinal position
//    y = lateral position
//    thickness = pattern thickness
//    radius = pattern elements radius
//    period = pattern period
module hollowing_pattern(x, y, thickness, radius, period) {
    dp = period/2;
  translate([x, y - dp, 0])  cylinder(h=thickness + 0.02, r=radius, center=true);
  translate([x - dp, y, 0])  cylinder(h=thickness + 0.02, r=radius, center=true);
  translate([x + dp, y, 0])  cylinder(h=thickness + 0.02, r=radius, center=true);
  translate([x, y + dp, 0])  cylinder(h=thickness + 0.02, r=radius, center=true);
}


// Module:  case_top()
// Usage:
//   case_top(length, width, height, wall_thickness, bevel_resolution, connectors, snap_joints, screws, hollowing_out);
// Description:
//    Generates the top part of a case with modular features.
// Arguments:
//    length = case length
//    width = case width
//    height = case height
//    wall_thickness = wall thickness
//    bevel_resolution = beveling resolution (number of segments per 360 degrees, 0 = automatic)
//    connectors = an optional list of up to two connector features, such as [[type (0=female, 1=male), width, height, offset_x, offset_y], ... ]
//    snap_joints = an optional list of snap-fit joints features, such as [shaft_radius, hub_radius, length, [[position1_x, position1_y], [position2_x, position2_y], ...] ]
//    screws = an optional list of screws positions and features, as [[hole_radius, head_radius, mount_height, [position_x, position_y]], ... ]
//    hollowing_out = optional hollowing out settings, as [hollowing_period, hollowing_radius, exclusion_rects, exclusion_circles]
module case_top(length, width, height, wall_thickness, bevel_resolution, connectors, snap_joints, screws, hollowing_out) {
    union() {
        /** snap joints **/
        // snap joints are placed on longitudinal faces; they can be either female (type=0) or male (type=1)
        if (!is_undef(snap_joints)) {
            for (n=[0,1]) {
                if (!is_undef(connectors[n])) {
                    for (joint=snap_joints[3]) {
                        translate([n*length, joint[0], joint[1]]) rotate([0, 0, 180*n]) if (connectors[n][0] == 0) {
                            translate([snap_joints[2]/2+wall_thickness, 0, 0]) snap_joint_female(snap_joints[2], wall_thickness, snap_joints[0], snap_joints[1], false);
                        } else if (connectors[n][0] == 1) {
                            rotate([0, 0, 180]) snap_joint_male(snap_joints[2], wall_thickness, snap_joints[0], snap_joints[1], true);
                        } // end if
                    } // end for
                } // end if (!is_undef(connectors[n]))
            } // end for (n=...)
        } // end if (!is_undef(snap_joints))
        
        if (!is_undef(screws))
            for (screw = screws)
                translate([screw[3].x, screw[3].y, height - wall_thickness - screw[2]]) screw_mount(screw[2], screw[1], screw[0], wall_thickness, bevel_resolution);
        
        difference() {
            /** case boundaries **/
            rounded_cube([length, width, height], wall_thickness, bevel_resolution);
            
            /** inner volume **/
            translate([wall_thickness, wall_thickness, -wall_thickness]) rounded_cube([length - 2*wall_thickness, width - 2*wall_thickness, height], wall_thickness, bevel_resolution);
            
            /** holes for connectors and snap-fit joints **/
            if (!is_undef(connectors)) {
                for (n=[0,1]) { // box side
                    if (!is_undef(connectors[n])) {
                        // hole for connector
                        translate([-0.01 + n*(length - wall_thickness), connectors[n][3] + (width-connectors[n][1])/2, connectors[n][4] + (height-connectors[n][2])/2]) rotate([90, 0, 90])
                            rounded_rect_hole([connectors[n][1], connectors[n][2], wall_thickness+0.02], wall_thickness/2, bevel_resolution);
                        
                        // holes for snap-fit joints
                        if (connectors[n][0] == 0 && !is_undef(snap_joints)) {
                            // we put female snap-fit joints with female connectors, and male joints with male connectors;
                            // only female snap-fit joints require holes
                            for(joint=snap_joints[3])  {
                                // hole
                                translate([n*(length - wall_thickness) + wall_thickness/2, joint.x, joint.y]) rotate([0,90,n*180]) cylinder(h=wall_thickness+0.02, r=snap_joints[0], center=true);
                                // chamfer
                                translate([-0.01 + wall_thickness/2 + n*(length - wall_thickness +0.02), joint.x, joint.y]) rotate([0, 90+n*180, 0]) cylinder(h=wall_thickness, r1=snap_joints[0] + wall_thickness, r2=snap_joints[0], center=true);
                            } // end for
                        } // end if (connectors[n][0] == 0 && ...)
                    } // end if (!is_undef(connectors[n]))
                } // end for
            } // end if (!is_undef(connectors))
            
            /** hollowing out **/
            if (!is_undef(hollowing_out)) {
                hollowing_period = hollowing_out[0];
                hollowing_radius = hollowing_out[1];
                // drill holes  through to reduce material consumption
                gap_edge = 2*hollowing_period;
                
                // lateral faces (without exclusion zones)
                for (y = [wall_thickness/2, width - wall_thickness/2])
                    translate([length/2, y, height/2]) rotate([90, 0, 0]) fill_with_pattern([-length/2+gap_edge, -height/2+gap_edge], [length/2 - gap_edge, height/2 - gap_edge], hollowing_period, hollowing_period) hollowing_pattern(0, 0, wall_thickness, hollowing_radius, hollowing_period);
                
                // longitudinal faces
                for (n=[0,1]) {
                    if (!is_undef(connectors[n])) {
                        // remove hollowing out around connector holes and snap joints
                        exclusion_rects = [[[-connectors[n][1]/2 - hollowing_period, -connectors[n][2]/2 - hollowing_period],[connectors[n][1]/2 + hollowing_period, connectors[n][2]/2 + hollowing_period]]];
                        exclusion_circles = is_undef(snap_joints) ? undef : [for (joint=snap_joints[3]) [[joint[0]-width/2, joint[1]-height/2], snap_joints[0] + wall_thickness + hollowing_period]];
                        translate([wall_thickness/2 + n*(length - wall_thickness), width/2, height/2]) rotate([90, 0, 0]) rotate([0, 90, 0]) fill_with_pattern([-width/2+gap_edge, -height/2+gap_edge], [width/2 - gap_edge, height/2 - gap_edge], hollowing_period, hollowing_period, exclusion_rects, exclusion_circles) hollowing_pattern(0, 0, wall_thickness, hollowing_radius, hollowing_period);
                    } else {
                        translate([wall_thickness/2 + n*(length - wall_thickness), width/2, height/2]) rotate([90, 0, 0]) rotate([0, 90, 0]) fill_with_pattern([-width/2+gap_edge, -height/2+gap_edge], [width/2 - gap_edge, height/2 - gap_edge], hollowing_period, hollowing_period) hollowing_pattern(0, 0, wall_thickness, hollowing_r, hollowing_period);
                    } // end if
                } // end for
            } // end if (hollowing_out)
        } // end difference()
        
        /** edge to support case bottom **/
        translate([2*wall_thickness - 0.01, width/2, wall_thickness]) rotate([-90, 0, 180]) linear_extrude(width - wall_thickness*2, center=true) polygon([[0,0], [wall_thickness, 0], [wall_thickness, -2*wall_thickness]]);
        translate([length - 2*wall_thickness + 0.01, width/2, wall_thickness]) rotate([-90, 0, 0]) linear_extrude(width - wall_thickness*2, center=true) polygon([[0,0], [wall_thickness, 0], [wall_thickness, -2*wall_thickness]]);
        translate([length/2, width - 2*wall_thickness + 0.01, wall_thickness]) rotate([-90, 0, 90]) linear_extrude(length - wall_thickness*2, center=true) polygon([[0,0], [wall_thickness, 0], [wall_thickness, -2*wall_thickness]]);
        translate([length/2, 2*wall_thickness - 0.01, wall_thickness]) rotate([-90, 0, -90]) linear_extrude(length - wall_thickness*2, center=true) polygon([[0,0], [wall_thickness, 0], [wall_thickness, -2*wall_thickness]]);
        
    } // end union()
}


// Module:  case_bottom()
// Usage:
//   case_bottom(length, width, wall_thickness, bevel_resolution, screws, clips, hollowing_out);
// Description:
//    Generates the bottom part of a case with modular features.
// Arguments:
//    length = case length
//    width = case width
//    wall_thickness = wall thickness
//    bevel_resolution = beveling resolution (number of segments per 360 degrees, 0 = automatic)
//    screws = an optional list of screws positions and features, as [[hole_radius, head_radius, standoff_height, [position_x, position_y]], ... ]
//    clips = an optional list of clips, as [length, width, height, beam_radius, hole_offset, [[leg1_x, leg1_y], [leg2_x, leg2_y],...] ]
//    hollowing_out = optional hollowing out settings, as [hollowing_period, hollowing_radius, exclusion_rects, exclusion_circles]
module case_bottom(length, width, wall_thickness, bevel_resolution, screws, clips, hollowing_out) {
    difference() {
        union() {
            /** base plate **/
            translate([wall_thickness, wall_thickness, 0]) extruded_rounded_rectangle([length - 2*wall_thickness, width - 2*wall_thickness, wall_thickness], wall_thickness, bevel_resolution);
            
            /** counterparts for screw stands **/
            if (!is_undef(screws))
                for (screw = screws[3])
                    translate([screw.x, screw.y, wall_thickness]) screw_standoff(screws[2], screws[1], screws[0], wall_thickness, bevel_resolution);
            
            /** leg clips **/
            if (!is_undef(clips))
                for (clip = clips[5])
                    translate([clip.x, clip.y, -clips[2]/2]) case_clip([clips[0], clips[1], clips[2]], clips[3], clips[4], bevel_resolution);
        }
        
        // screw holes
        if (!is_undef(screws))
            for (screw = screws[3]) {
                // hole
                translate([screw.x, screw.y, wall_thickness/2]) cylinder(h=wall_thickness+0.02, r=screws[0], center = true);
                // chamfer
                translate([screw.x, screw.y, (screws[1] - screws[0])/2]) cylinder(h=screws[1] - screws[0] + 0.02, r1=screws[1], r2=screws[0], center=true);

            }
        
        /** hollowing out **/
        if (!is_undef(hollowing_out)) {
            hollowing_period = hollowing_out[0];
            hollowing_radius = hollowing_out[1];
            gap_edge = 2*hollowing_period + wall_thickness;
            
            // remove hollowing out around leg clips
            exclusion_rects = is_undef(clips) ? (is_undef(hollowing_out[2]) ? undef : hollowing_out[2]) : concat([ for (clip = clips[5]) [[clip.x - clips.x/2 - hollowing_period, clip.y - clips.y/2 - hollowing_period], [clip.x + clips.x/2 + hollowing_period, clip.y + clips.y/2 + hollowing_period]] ], is_undef(hollowing_out[2]) ? [] : hollowing_out[2]);
            
            // remove hollowing out around screw holes
            exclusion_circles = is_undef(screws) ? undef : concat([for (screw=screws[3]) [screw, screws[1] + hollowing_period]], is_undef(hollowing_out[3]) ? [] : hollowing_out[3]);
            
            translate([0, 0, wall_thickness/2]) fill_with_pattern([gap_edge, gap_edge], [length - gap_edge, width - gap_edge], hollowing_period, hollowing_period, exclusion_rects, exclusion_circles) hollowing_pattern(0, 0, wall_thickness, hollowing_radius, hollowing_period);

        } // end if (hollowing_out)
    } // end difference()
}


// Module:  case_support()
// Usage:
//   case_support(case_length, case_width, wall_thickness, bevel_resolution, clips, snap_joints, hollowing_out);
// Description:
//    Generates a foldable leg to be clipped behind a modular case.
// Arguments:
//    case_length = case length
//    case_width = case width
//    wall_thickness = wall thickness
//    bevel_resolution = beveling resolution (number of segments per 360 degrees, 0 = automatic)
//    screws = an optional list of screws positions and features, as [[hole_radius, head_radius, standoff_height, [position_x, position_y]], ... ]
//    clips = an optional list of clips, as [length, width, height, hole_radius, hole_offset, [[leg1_x, leg1_y], [leg2_x, leg2_y],...] ]; this will be used to leave leeway around clips
//    snap_joints = optional list of snap-fit joints features, as [shaft_radius, hub_radius, length, [type_side1 = 0 (none), 1 (female), 2 (male), type_side2] ]
//    hollowing_out = optional hollowing out settings, as [hollowing_period, hollowing_radius, exclusion_rects, exclusion_circles]
module case_support(case_length, case_width, wall_thickness, bevel_resolution, clips, snap_joints, hollowing_out) {
    // we set leg length based on case length and beam radius; we want to leave
    // enough space for snap-fit clips on each end;
    beam_x_length = case_length - 2*wall_thickness;
    // we set leg width to clip span
    leg_min = min([for (clip = clips[5]) clip.y]);
    leg_max = max([for (clip = clips[5]) clip.y]);
    beam_y_length = leg_max - leg_min;
    // leg stop: this is the rectangular bits that are placed on the beams
    // to lean against the back of the case and block the leg at 90 degrees.
    // It is calculated so that it reaches at most the edge of the case.
    stop_height = min(leg_min, case_width - leg_max);
    beam_radius = clips[3];
    beam_z = -clips[2] + beam_radius + clips[4];
    
    union() {
        difference() {
            union() {
                /** rounded beams along box length **/
                for (y = [leg_min, leg_max])
                    translate([(case_length - beam_x_length)/2 + beam_radius, y, beam_z])
                    rotate([0,90,0]) cylinder(h=beam_x_length - 2*beam_radius, r=beam_radius);
                
                /** round beams along box width **/
                for (x = [(case_length - beam_x_length)/2 + beam_radius, (case_length + beam_x_length)/2 - beam_radius])
                    translate([x, (case_width + beam_y_length)/2, beam_z]) rotate([90,0,0]) cylinder(h=beam_y_length, r=beam_radius);
                
                /** rounded beam corners **/
                for (y = [leg_min, leg_max], x = [(case_length - beam_x_length)/2 + beam_radius, (case_length + beam_x_length)/2 - beam_radius])
                    translate([x, y, beam_z]) sphere(beam_radius);
            } // end union
            
            // remove space for snap-fit joint if type is female
            if (!is_undef(snap_joints))
                for (n = [0,1], snap_y = [leg_min - beam_radius, leg_max - stop_height + wall_thickness]) if (snap_joints[3][n] == 1)
                translate([beam_radius - 2*wall_thickness + n*(- 4*beam_radius + 4*wall_thickness + (case_length+beam_x_length)/2 ), snap_y, beam_z - stop_height + wall_thickness]) rounded_cube([(case_length-beam_x_length)/2 + 2*beam_radius, stop_height + beam_radius - wall_thickness, stop_height + beam_radius - wall_thickness], beam_radius, bevel_resolution);
        
        } // end difference()
        
        /** leg stops **/
        // we can insert stops only between clips
        // => we select every clip present on one side, sort them, and place
        // stops in between
        for (leg_y = [leg_min, leg_max]) {
            clips_leg = quicksort([for (clip = clips[5]) if (clip.y == leg_y) clip.x]);
            for (i = [1:len(clips_leg)-1])
                translate([clips_leg[i-1] + clips[0]/2 + wall_thickness, leg_y - beam_radius, beam_z - stop_height + wall_thickness]) rounded_cube([clips_leg[i] - clips_leg[i-1] - clips[0] - 2*wall_thickness, beam_radius*2, stop_height], wall_thickness, bevel_resolution);
            
        } // end for
        
        /** snap-fit connectors **/
        if (!is_undef(snap_joints)) {
            block_length = (case_length-beam_x_length)/2 + 2*beam_radius;
            block_width = stop_height + beam_radius - wall_thickness;
            for (n = [0,1], snap_y = [leg_min - beam_radius, leg_max - stop_height + wall_thickness]) {
                // connectors can be either absent (0), female (1) or male (2)
                if (snap_joints[3][n] == 1) {
                    translate([beam_radius - 2*wall_thickness + n*(case_length - 2*beam_radius + 4*wall_thickness), snap_y + n*block_width, beam_z - stop_height + wall_thickness]) rotate([0,0,180*n]) snap_joint_female_block(block_length, block_width, snap_joints[0], snap_joints[1], beam_radius, bevel_resolution);
                } else if (snap_joints[3][n] == 2) {
                    translate([beam_radius - 2*wall_thickness + block_length + n*(case_length - 2*block_length - 2*beam_radius + 4*wall_thickness), snap_y + (1-n)*block_width, beam_z - stop_height + wall_thickness])  rotate([0,0,180*(n+1)]) snap_joint_male_block(block_length, block_width, snap_joints[0], snap_joints[1], snap_joints[2], beam_radius, bevel_resolution);
                } // end if
            } // end for
        } // end if (!is_undef(snap_joints))
        
        /** reinforcement plate **/
        // we place a thin plate in between the beams for strengthening
        // we need to create holes to let clips through and allow movement
        difference() {
            translate([(case_length - beam_x_length)/2 + beam_radius, leg_min, beam_z]) cube([beam_x_length - 2*beam_radius, beam_y_length, wall_thickness]);
            
            if (!is_undef(clips)) for (clip = clips[5])
                translate([clip.x - clips.x/2 - wall_thickness, clip.y - clips.y/2 - wall_thickness, beam_z]) rounded_rect_hole([clips.x + 2*wall_thickness, clips.y + 2*wall_thickness, wall_thickness+0.02], wall_thickness/2, bevel_resolution);
            
            /** hollowing out **/
            if (!is_undef(hollowing_out)) {
                hollowing_period = hollowing_out[0];
                hollowing_radius = hollowing_out[1];
                gap_edge = 2*hollowing_period;
                
                // remove hollowing out around leg clips
                exclusion_rects = is_undef(clips) ? (is_undef(hollowing_out[2]) ? undef : hollowing_out[2]) : concat([ for (clip = clips[5]) [[clip.x - clips.x/2 - hollowing_period - wall_thickness, clip.y - clips.y/2 - hollowing_period - wall_thickness], [clip.x + clips.x/2 + 2*hollowing_period + wall_thickness, clip.y + clips.y/2 + hollowing_period + wall_thickness]] ], is_undef(hollowing_out[2]) ? [] : hollowing_out[2]);
                
                // remove hollowing out around screw holes
                exclusion_circles = is_undef(hollowing_out[3]) ? undef : hollowing_out[3];
                
                translate([0, 0, beam_z + wall_thickness/2]) fill_with_pattern([(case_length - beam_x_length)/2 + beam_radius + gap_edge, leg_min + gap_edge], [(case_length + beam_x_length)/2 - beam_radius - gap_edge, leg_max - gap_edge], hollowing_period, hollowing_period, exclusion_rects, exclusion_circles) hollowing_pattern(0, 0, wall_thickness, hollowing_radius, hollowing_period);

            } // end if (!is_undef(hollowing_out))
        } // end difference()
   } // end union
}
