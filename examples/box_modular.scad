// File: box_modular.scad
//   This file is an example of application for modules defined in box_parts.scad.
//   It defines the following items:
//     - a box made to host a TFT screen, a circuit board and a battery (box top, box bottom, box support)
//     - an extension box made to be clipped to the side of the main box, with holes for two knobs (box top, box bottom, box support)
//
//   Rendered elements can be selected by settings the appropriate booleans to true (see options section below).
//   

use <toolbox.scad>;
use <box_parts.scad>;

/*************************/
/*** rendering options ***/
/*************************/
render_main_box = true; // if true, renders elements for main box
render_extension_box = true; // if true, renders elements for extension box

render_top = true; // if true, renders box top
render_bottom = false; // if true, renders box bottom cover
render_support = false; // if true, renders box support
hollowing_out = false; // if true, hollows out surfaces (see hollowing out settings below)

// minimum feature size
$fs=0.2;
$fn=64;

/*** settings common to main box and extension box ***/
wall_thickness = 1; // this also counts for extension box
bevel_resolution = 0; // 0 = automatic, otherwise must be >= 4

/*** main box: dimensions ***/
box_length = 80;
box_width = 60;
box_height = 19.5;

/** main box: screws **/
screw_distance = 5; // screw distance from edge (shortest distance)
screw_radius = 1.5; // screw radius (=> M3)
screw_hole_radius = screw_radius - 0.25; // hole in screw mount
screw_head_radius = 2.9; // radius of screw head (standard is d=5.3mm for M3 => added 0.5mm leeway)
screw_positions = [ [screw_distance, screw_distance, 3/2*wall_thickness, 3/2*wall_thickness], [box_length - screw_distance, screw_distance, -3/2*wall_thickness, 3/2*wall_thickness], [screw_distance, box_width - screw_distance, 3/2*wall_thickness, -3/2*wall_thickness], [box_length - screw_distance, box_width - screw_distance, -3/2*wall_thickness, -3/2*wall_thickness]];

/** main box: leg clips (placed on bottom cover) **/
clip_length = 5; // along long dimension
clip_width = 10; // along short dimension
clip_distance_x = 5 + clip_length/2; // longitudinal distance from clip centre to screw hole
clip_distance_y = -3 + clip_width/2; // lateral distance from clip centre to screw hole
clip_hole_radius = 2; // beam radius that fits in clip
clip_hole_clearance = 0.1;

/** main box: screen (Newhaven Display NHD-2.4-240320CF-BSXV-FT) **/
tft_width = 60.26;
tft_height = 42.72;
tft_thickness = 3.85;
tft_clearance = 0.1; // datasheet says 0.2 but we want tft to fit tight
tft_vis_width = 49.36; // width of visible area
tft_vis_height = 37.01; // height of visible area
tft_vis_distance = 2.82; // distance of visible area from top edge
screen_distance_y = (box_width - tft_vis_height)/2; // distance from box edge
screen_distance_x = (box_length - tft_vis_width)/2;

/** main box: power switch (CW Industries GF-126-0331) **/
switch_length = 10.0; // length of opening in back panel
switch_width = 4.0; // width of opening in back panel
switch_height = 9.1; // datasheet says 8.86 +/- 0.32
switch_bumper = switch_height - 8.86; // we add an edge to press against the switch to hold the board
switch_position_x = 50.8; // distance from box edge (not board edge)
switch_position_y = 48.5;

/** main box: circuit board (custom-made PCB) **/
board_position = wall_thickness + switch_height; // vertical position from bottom
board_width = 48;
board_length = 31.5;
board_clearance = 0.1;
board_distance = 0; // distance from wall in longitudinal direction
board_thickness = 1.6;

/** main box: battery - this is the maximum battery dimensions that fit in the box **/
battery_length = 49;
battery_width = 34.5;
battery_thickness = 10;
battery_clearance = 0.1;

/** extension box: dimensions **/
extension_length = 30;
extension_width = box_width;
extension_height = box_height;

/** extension box: knobs **/
knob_position_x = extension_length/2;
knob_position_y = 16; // knobs are positioned symmetrically => this is the distance from the closest edge
knob_hole_radius = 7.5 / 2;

/** common settings: hollowing out - some 3D printing services may charge less when less material is used **/
/** pattern used for hollowing out is defined in box_parts.scad (module hollowing_pattern) **/
hollowing_out_period = 2.0;
hollowing_out_radius = 0.3;
hollowing_out_parameters = hollowing_out ? [hollowing_out_period, hollowing_out_radius] : undef;

/** common settings: annular snap-fit connectors **/
snap_joint_shaft_radius = 1.5; // radius of the small part of the connector
snap_joint_hub_radius = 2.2; // radius of the ball part
snap_joint_length = snap_joint_hub_radius + wall_thickness + 0.2;
snap_joint_distance_y1 = 2*screw_distance + wall_thickness; // lateral distance from box edge, top connectors
snap_joint_distance_y2 = 2*screw_distance + 2*wall_thickness; // lateral distance from box edge, bottom connectors
snap_joint_distance_z = screw_distance; // vertical distance from box edge (upper or lower)

/** common settings: female USB connector (Amphenol 12401610E4#2A) **/
connector_clearance = 0.2;
female_connector_width = 9.2;
female_connector_height = 3.3;
/** common settings: male USB connector (JAE Electronics DX07P024AJ1R1500) **/
male_connector_width = 8.3;
male_connector_height = 2.4;


if (render_main_box) {
    /***************/
    /*** box top ***/
    /***************/
    if (render_top) {
        // screw stand height (adjusted to support PCB => female connector has to be aligned with corresponding hole)
        stand_height = box_height/2 - wall_thickness - female_connector_height/2 - board_thickness;
        
        color(c=[0.9, 0.7, 0.5]) union() {
            difference() {
                case_top(
                    box_length, box_width, box_height, wall_thickness, bevel_resolution,
                    
                    // connectors
                    [[0, female_connector_width + 2*connector_clearance, female_connector_height + 2*connector_clearance, 0, 0], [0, female_connector_width + 2*connector_clearance, female_connector_height + 2*connector_clearance, 0, 0]],
                    
                    // snap-fit joints
                    [snap_joint_shaft_radius, snap_joint_hub_radius, snap_joint_length, [[snap_joint_distance_y1, snap_joint_distance_z], [snap_joint_distance_y2, box_height-snap_joint_distance_z], [box_width-snap_joint_distance_y1, snap_joint_distance_z], [box_width-snap_joint_distance_y2, box_height-snap_joint_distance_z] ]],
                    
                    // screws
                    [for (screw_position = screw_positions) [screw_hole_radius, screw_head_radius, stand_height, screw_position]],
                    
                    // hollowing out
                    hollowing_out_parameters
                );
                
                // screen window
                union() {
                    translate([screen_distance_x, screen_distance_y, box_height - 2*wall_thickness]) cube([tft_vis_width,tft_vis_height, 3*wall_thickness]);
                    translate([screen_distance_x, screen_distance_y, box_height - wall_thickness + 0.2]) chamfered_rect_hole([tft_vis_width, tft_vis_height, wall_thickness], min(screen_distance_x, screen_distance_y)/2 + 0.4);
                }
                
                // slots for overlay clip
                slot_r = wall_thickness*3;
                for (y = [-slot_r+wall_thickness, box_width + slot_r - wall_thickness]) translate([tft_vis_width/2 + screen_distance_x, y, box_height - 2*wall_thickness]) rotate([0, 90, 0]) difference() {
                    cylinder(h=tft_vis_width, r=slot_r, center=true);
                    translate([-2*slot_r-0.01, -slot_r-0.01, -tft_vis_width/2-0.01]) cube([2*slot_r+0.02, 2*slot_r+0.02, tft_vis_width+0.02]);
                }
                
                // remove space for screen
                translate([screen_distance_x - tft_vis_distance - tft_clearance, screen_distance_y - (tft_height - tft_vis_height)/2 - tft_clearance, box_height - wall_thickness - tft_thickness])  cube([tft_width + 2*tft_clearance, tft_height + 2*tft_clearance, tft_thickness]);
                
                // remove space for battery
                translate([box_length-board_length-wall_thickness-board_distance - battery_width - wall_thickness - battery_clearance, (box_width - battery_length)/2 - battery_clearance, box_height - 2*wall_thickness - battery_thickness - tft_thickness - 3*battery_clearance]) cube([battery_width+battery_clearance, battery_length + 2*battery_clearance, battery_thickness + 2*battery_clearance]);
            } // end difference()
            
            // screen alignment marks
            // vertical elements
            translate(
                [screen_distance_x - tft_vis_distance - wall_thickness - tft_clearance,
                 screen_distance_y - (tft_height - tft_vis_height)/2,
                 box_height - wall_thickness - tft_thickness - tft_clearance]) cube([wall_thickness, tft_height, tft_thickness + tft_clearance]);
            for (y=[
                    screen_distance_y - (tft_height - tft_vis_height)/2 - wall_thickness - tft_clearance,
                    screen_distance_y - (tft_height - tft_vis_height)/2 + tft_clearance + tft_height]) {
                translate([screen_distance_x - tft_vis_distance + 5, y, box_height - wall_thickness - tft_thickness - tft_clearance])
                    cube([tft_width - 10, wall_thickness, tft_thickness + tft_clearance]);
            } // end for
            
            // horizontal elements
            translate(
                [screen_distance_x - tft_vis_distance - wall_thickness - tft_clearance,
                 screen_distance_y - (tft_height - tft_vis_height)/2,
                 box_height - 2*wall_thickness - tft_thickness - tft_clearance]) cube([2*wall_thickness, tft_height, wall_thickness]);
            for (y = [screen_distance_y - (tft_height - tft_vis_height)/2 - wall_thickness - tft_clearance, screen_distance_y - (tft_height - tft_vis_height)/2 - wall_thickness + tft_height - tft_clearance]) {
                translate([box_length-board_length-board_distance-wall_thickness, y, box_height - 2*wall_thickness - tft_thickness])
                cube([2*wall_thickness, 2*wall_thickness, wall_thickness]);
            } // end for
            
            // add thicker structures to support PCB as well => need to be thick enough to reach board surface
            for (y = [screen_distance_y - (tft_height - tft_vis_height)/2 - 2*wall_thickness - tft_clearance, screen_distance_y - (tft_height - tft_vis_height)/2 + tft_height - tft_clearance]) {
                translate([box_length-board_length-board_distance-wall_thickness, y, wall_thickness + board_thickness + switch_height])
                cube([2*wall_thickness, 2*wall_thickness, box_height - 2*wall_thickness - board_thickness - switch_height]);
            } // end for
        } // end union()
    } // end if (render_top)
    
    
    /********************/
    /*** bottom cover ***/
    /********************/
    if (render_bottom) {
        
        difference() {
            union() {
                case_bottom(
                    box_length, box_width, wall_thickness, bevel_resolution,
                    
                    // screws
                    [screw_radius + 0.05, screw_head_radius, box_height/2 - wall_thickness + female_connector_height/2, screw_positions ],
                    
                    // leg clips
                    [clip_length, clip_width, clip_hole_radius*2, clip_hole_radius+clip_hole_clearance, -clip_hole_clearance*2, [[screw_distance + clip_distance_x, screw_distance + clip_distance_y], [screw_distance + clip_distance_x, box_width - screw_distance - clip_distance_y],  [box_length - screw_distance - clip_distance_x, screw_distance + clip_distance_y], [box_length - screw_distance - clip_distance_x, box_width - screw_distance - clip_distance_y] ] ],
                    
                    // hollowing out
                    hollowing_out ? [hollowing_out_period, hollowing_out_radius, , [ [[switch_position_x - switch_length/2 - 2*hollowing_out_period, switch_position_y - switch_width/2 - 2*hollowing_out_period], [switch_position_x + switch_length/2 + 2*hollowing_out_period, switch_position_y + switch_width/2 + 2*hollowing_out_period]] ] ] : undef
                );
            
                /** switch bumper edge (= edge to press against switch to hold board in place) **/
                translate([switch_position_x - switch_length/2 - 2*wall_thickness, switch_position_y - switch_width/2 - 2*wall_thickness, wall_thickness-0.01])
                cube([switch_length + 4*wall_thickness, switch_width + 4*wall_thickness, switch_bumper+0.02]);
            } // end union()
            
            /*** opening for power switch ***/
            translate([switch_position_x - switch_length/2, switch_position_y - switch_width/2, -0.01]) {
                // opening
                cube([switch_length, switch_width, switch_bumper + wall_thickness+0.02]);
                // rounded edges
                rounded_rect_hole([switch_length, switch_width, switch_bumper + wall_thickness+0.02], (switch_bumper + wall_thickness)/2, bevel_resolution);
            } // end translate
        }
    } // end if (render_bottom)
    
    
    /****************************/
    /*** foldable box support ***/
    /****************************/
    color(c=[0.5,0.5,0.7]) if (render_support) {
        
        difference () {
            case_support(
                box_length, box_width, wall_thickness, bevel_resolution, 
            
                // leg clips
                [clip_length, clip_width, clip_hole_radius*2, clip_hole_radius+clip_hole_clearance, -clip_hole_clearance*2, [[screw_distance + clip_distance_x, screw_distance + clip_distance_y], [screw_distance + clip_distance_x, box_width - screw_distance - clip_distance_y],  [box_length - screw_distance - clip_distance_x, screw_distance + clip_distance_y], [box_length - screw_distance - clip_distance_x, box_width - screw_distance - clip_distance_y] ] ],
                
                // snap joints
                [snap_joint_shaft_radius, snap_joint_hub_radius, snap_joint_length, [1,1]],
                
                // hollowing out
                hollowing_out ? [hollowing_out_period, hollowing_out_radius, undef, [ [[switch_position_x, switch_position_y+switch_width/2],switch_length + hollowing_out_period/2] ] ] : undef
            );
            
            /** hole for switch **/
            translate([switch_position_x, switch_position_y + switch_width/2, -clip_hole_radius - clip_hole_clearance + wall_thickness/2 ]) {
                difference() {
                        rounded_circular_hole(3/4*max(switch_length, switch_width) + wall_thickness - 0.01, wall_thickness + 0.02, wall_thickness/2, bevel_resolution);
                    translate([-3/4*max(switch_length, switch_width) - wall_thickness, box_width - screw_distance - clip_distance_y - clip_hole_radius - switch_position_y - switch_width/2, -wall_thickness/2 - 0.01]) cube([3/2*max(switch_length, switch_width) + 2*wall_thickness, 3*clip_hole_radius, wall_thickness+0.02]);
                }
            }

        }
            
    } // end if (render_support)
    
} // end if (render_main_box)


/************************/
/*** extension box ***/
/************************/
if (render_extension_box) {
    /*************************/
    /*** extension box top ***/
    /*************************/
    color(c=[0.5, 0.7, 0.9]) if (render_top) {
        // screw stand height (adjusted to support PCB => female connector has to be aligned with corresponding hole)
        stand_height = extension_height/2 - wall_thickness - female_connector_height/2 - board_thickness;
        
        translate([-extension_length, 0, 0]) union() {
            difference() {
                case_top(extension_length, extension_width, extension_height, wall_thickness, bevel_resolution,
                
                // connector holes
                [[0, female_connector_width + 2*connector_clearance, female_connector_height + 2*connector_clearance, 0, 0], [1, male_connector_width + 2*connector_clearance, male_connector_height + 2*connector_clearance, 0, (female_connector_height - male_connector_height)/2]],
                
                // snap-fit joints
                [snap_joint_shaft_radius, snap_joint_hub_radius, snap_joint_length, [[snap_joint_distance_y1, snap_joint_distance_z], [snap_joint_distance_y2, box_height-snap_joint_distance_z], [box_width-snap_joint_distance_y1, snap_joint_distance_z], [box_width-snap_joint_distance_y2, box_height-snap_joint_distance_z] ]],
                
                // screws
                [[screw_hole_radius, screw_head_radius, stand_height, [extension_length/2, screw_distance, 0, wall_thickness*3/2]], [screw_hole_radius, screw_head_radius, stand_height, [extension_length/2, extension_width-screw_distance, 0, -wall_thickness*3/2]]],
                
                // hollowing out
                hollowing_out_parameters
                );
            
                /** knob holes **/
                for (y=[knob_position_y, extension_width-knob_position_y]) {
                    translate([extension_length - knob_position_x, y, extension_height - wall_thickness/2]) rotate([180, 0, 0]) rounded_circular_hole(knob_hole_radius+wall_thickness-0.01, wall_thickness+0.04, wall_thickness/2, bevel_resolution);
                } // end for
                
            } // end difference()
        
            /** screw stands **/
            // we use screw stands as supports for the board, which gets pinched
            // between stand and counterparts on box bottom. Therefore, stands must
            // be calculated so that the female connector lands at the right height.
            // We assume the connectors are on the bottom of the board (=> -board_thickness).
        } // end if (render_top)
    } // end if (render_top)
    
    
    /**********************************/
    /*** extension box bottom cover ***/
    /**********************************/
    translate([-extension_length, 0, 0]) if (render_bottom) {
        
        case_bottom(
            extension_length, extension_width, wall_thickness, bevel_resolution,
            
            // screws
            [screw_radius + 0.05, screw_head_radius, extension_height/2 - wall_thickness + female_connector_height/2, [[extension_length/2, screw_distance], [extension_length/2, extension_width - screw_distance]] ],
            
            // leg clips
            [clip_length, clip_width, clip_hole_radius*2, clip_hole_radius+clip_hole_clearance, -clip_hole_clearance*2, [[clip_distance_x + wall_thickness, screw_distance + clip_distance_y], [clip_distance_x + wall_thickness, extension_width - screw_distance - clip_distance_y],  [extension_length - clip_distance_x - wall_thickness, screw_distance + clip_distance_y], [extension_length - clip_distance_x - wall_thickness, extension_width - screw_distance - clip_distance_y] ] ],
            
            // hollowing out
            hollowing_out_parameters 
        );
    } // end if (render_bottom)
    
    /*********************/
    /*** leg extension ***/
    /*********************/
    color(c=[0.5,0.5,0.7]) translate([-extension_length, 0, 0]) if (render_support) {
        
        case_support(
            extension_length, extension_width, wall_thickness, bevel_resolution,
            
            // holes for leg clips
            [clip_length, clip_width, clip_hole_radius*2, clip_hole_radius+clip_hole_clearance, -clip_hole_clearance*2, [[clip_distance_x + wall_thickness, screw_distance + clip_distance_y], [clip_distance_x + wall_thickness, extension_width - screw_distance - clip_distance_y],  [extension_length - clip_distance_x - wall_thickness, screw_distance + clip_distance_y], [extension_length - clip_distance_x - wall_thickness, extension_width - screw_distance - clip_distance_y] ] ],
            
            // snap-fit connectors
            [snap_joint_shaft_radius, snap_joint_hub_radius, snap_joint_length, [1,2]],
            
            // hollowing out
            hollowing_out_parameters
        );
    } // end if (render_support)
    
}
