# openscad_modbox: a modular box design with OpenSCAD
This is a set of OpenSCAD modules and functions to generate boxes that can be attached to each other with snap-fit connectors.

I started doing this as I wanted to build a small and inexpensive live stream controller as a fun project, and then my imagination went wild. I thought of something which, unlike some IoT-oriented projects around (see M5Stack or Seeed Wio Terminal for instance), extends sideways and would eventually form a row of chain-linked components (touch screen, potentiometers, sliders, ...). This repository contains the OpenSCAD files that I wrote to generate boxes and box stands.

# Files
You'll find the OpenSCAD files in [modbox folder](https://github.com/vpaeder/openscad_modbox/tree/master/modbox). I've split the project in *low-level* (toolbox.scad) and *high-level* (box_parts.scad) functions and modules. Both are needed to generate complete boxes.

# Documentation
Please check the files in [docs folder](https://github.com/vpaeder/openscad_modbox/tree/master/docs). This documentation is also included within the .scad files. The Markdown files have been generated with [openscad-docsgen](https://pypi.org/project/openscad-docsgen/).

# Installation
Copy *toolbox.scad* and *box_parts.scad* in your OpenSCAD libraries folder. You can also copy them under a subfolder, in which case you'll have to update the *include* or *use* directives accordingly.

# Example(s)
Check the [examples folder](https://github.com/vpaeder/openscad_modbox/tree/master/examples) for applications.
