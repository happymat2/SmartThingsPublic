// EV Battery Chamber 3D Technical Drawing (OpenSCAD)
// Units: mm
// Updated: adds technical view layout + dimension annotations

$fn = 48;

// =============================
// Display controls
// =============================
show_isometric = true;
show_front_view = true;
show_top_view = true;
show_right_view = true;
show_dimensions = true;

// =============================
// Main parameters
// =============================
chamber_w = 2600;
chamber_d = 1100;
chamber_h = 2600;

frame_t = 50;
wall_t = 8;

levels = 4;
level_clearance = 560;
base_offset = 160;

shelf_t = 25;
shelf_beam_h = 60;

packs_per_row = 3;
pack_w = 700;
pack_d = 500;
pack_h = 140;

row_side_margin = 140;
pack_gap = 140;
front_recess = 120;

// pack details (more realistic module details)
pack_corner_r = 10;
pack_cover_t = 10;
terminal_r = 10;
terminal_h = 16;
cooling_port_r = 7;

// drawing offsets
drawing_gap_x = chamber_w + 400;
drawing_gap_y = chamber_d + 500;

// =============================
// Colors
// =============================
frame_color = [0.06, 0.21, 0.37];
chamber_color = [0.13, 0.36, 0.59, 0.22];
shelf_color = [0.58, 0.86, 0.95];
pack_color = [0.05, 0.70, 0.32];
terminal_pos_color = [0.92, 0.78, 0.16];
terminal_neg_color = [0.65, 0.65, 0.65];
dim_color = [1.00, 0.85, 0.20];

layout();

module layout() {
    if (show_isometric)
        assembly_with_color();

    // Front view block
    if (show_front_view)
        translate([drawing_gap_x, 0, 0])
            front_view_block();

    // Top view block
    if (show_top_view)
        translate([0, drawing_gap_y, 0])
            top_view_block();

    // Right view block
    if (show_right_view)
        translate([drawing_gap_x, drawing_gap_y, 0])
            right_view_block();
}

module assembly_with_color() {
    color(chamber_color) chamber_shell();
    color(frame_color) frame_members();

    for (r = [0 : levels-1]) {
        z0 = base_offset + r * level_clearance;

        color(shelf_color) shelf(z0);

        for (c = [0 : packs_per_row-1]) {
            x0 = row_side_margin + c * (pack_w + pack_gap);
            y0 = front_recess;
            z_pack = z0 + shelf_t + 20;

            translate([x0, y0, z_pack]) battery_pack();
        }
    }

    if (show_dimensions)
        dimension_set_iso();
}

module front_view_block() {
    // flat technical projection using thin extrusion
    color([0.15, 0.85, 1.00])
    linear_extrude(height = 2)
        projection(cut = false)
            rotate([90, 0, 0])
                chamber_outline_with_packs();

    if (show_dimensions)
        front_dimensions();
}

module top_view_block() {
    color([0.15, 0.85, 1.00])
    linear_extrude(height = 2)
        projection(cut = false)
            chamber_outline_with_packs();

    if (show_dimensions)
        top_dimensions();
}

module right_view_block() {
    color([0.15, 0.85, 1.00])
    linear_extrude(height = 2)
        projection(cut = false)
            rotate([0, 90, 0])
                chamber_outline_with_packs();

    if (show_dimensions)
        right_dimensions();
}

module chamber_outline_with_packs() {
    chamber_shell();
    frame_members();

    for (r = [0 : levels-1]) {
        z0 = base_offset + r * level_clearance;
        shelf(z0);
        for (c = [0 : packs_per_row-1]) {
            x0 = row_side_margin + c * (pack_w + pack_gap);
            y0 = front_recess;
            z_pack = z0 + shelf_t + 20;
            translate([x0, y0, z_pack]) battery_pack_simplified();
        }
    }
}

module chamber_shell() {
    difference() {
        cube([chamber_w, chamber_d, chamber_h]);
        translate([wall_t, wall_t, wall_t])
            cube([chamber_w-2*wall_t, chamber_d-2*wall_t, chamber_h-wall_t]);
    }
}

module frame_members() {
    // Vertical posts
    for (x = [0, chamber_w-frame_t])
        for (y = [0, chamber_d-frame_t])
            translate([x, y, 0]) cube([frame_t, frame_t, chamber_h]);

    // Top/bottom perimeter beams
    for (z = [0, chamber_h-frame_t]) {
        translate([0, 0, z]) cube([chamber_w, frame_t, frame_t]);
        translate([0, chamber_d-frame_t, z]) cube([chamber_w, frame_t, frame_t]);
        translate([0, 0, z]) cube([frame_t, chamber_d, frame_t]);
        translate([chamber_w-frame_t, 0, z]) cube([frame_t, chamber_d, frame_t]);
    }

    // Intermediate support beams
    for (r = [0 : levels-1]) {
        z0 = base_offset + r * level_clearance - shelf_beam_h;
        translate([frame_t, frame_t, z0]) cube([chamber_w-2*frame_t, frame_t, shelf_beam_h]);
        translate([frame_t, chamber_d-2*frame_t, z0]) cube([chamber_w-2*frame_t, frame_t, shelf_beam_h]);
    }
}

module shelf(z0) {
    translate([frame_t, frame_t, z0])
        cube([chamber_w-2*frame_t, chamber_d-2*frame_t, shelf_t]);
}

module battery_pack() {
    // Main body
    color(pack_color)
    rounded_box(pack_w, pack_d, pack_h, pack_corner_r);

    // Cover step
    color([0.03, 0.55, 0.25])
    translate([12, 12, pack_h])
        rounded_box(pack_w-24, pack_d-24, pack_cover_t, 6);

    // Handle pockets
    color([0.04, 0.45, 0.22])
    translate([pack_w*0.10, pack_d*0.44, pack_h*0.50])
        cube([50, 60, 28]);
    color([0.04, 0.45, 0.22])
    translate([pack_w*0.82, pack_d*0.44, pack_h*0.50])
        cube([50, 60, 28]);

    // Electrical terminals
    color(terminal_pos_color)
    translate([pack_w*0.28, pack_d*0.10, pack_h+pack_cover_t])
        cylinder(h=terminal_h, r=terminal_r);

    color(terminal_neg_color)
    translate([pack_w*0.72, pack_d*0.10, pack_h+pack_cover_t])
        cylinder(h=terminal_h, r=terminal_r);

    // Cooling quick ports (pair)
    color([0.22, 0.22, 0.22])
    translate([pack_w*0.50, pack_d+2, pack_h*0.60])
        rotate([90, 0, 0]) cylinder(h=16, r=cooling_port_r);

    color([0.22, 0.22, 0.22])
    translate([pack_w*0.58, pack_d+2, pack_h*0.60])
        rotate([90, 0, 0]) cylinder(h=16, r=cooling_port_r);
}

module battery_pack_simplified() {
    rounded_box(pack_w, pack_d, pack_h, pack_corner_r);
}

module rounded_box(w, d, h, r) {
    minkowski() {
        cube([w-2*r, d-2*r, h-r]);
        cylinder(r=r, h=r);
    }
}

// =============================
// Dimension helpers
// =============================
module dimension_set_iso() {
    color(dim_color) {
        dim_x([-120, -120, 0], chamber_w, "W");
        dim_y([-170, 0, 0], chamber_d, "D");
        dim_z([-220, -220, 0], chamber_h, "H");
    }
}

module front_dimensions() {
    color(dim_color) {
        // Width at front view area
        translate([0, -80, 0])
            dim_x([0, 0, 0], chamber_w, "W");

        // Height at front view area
        translate([-80, 0, 0])
            dim_z([0, 0, 0], chamber_h, "H");
    }
}

module top_dimensions() {
    color(dim_color) {
        translate([0, -80, 0])
            dim_x([0, 0, 0], chamber_w, "W");
        translate([-80, 0, 0])
            dim_y([0, 0, 0], chamber_d, "D");
    }
}

module right_dimensions() {
    color(dim_color) {
        translate([0, -80, 0])
            dim_y([0, 0, 0], chamber_d, "D");
        translate([-80, 0, 0])
            dim_z([0, 0, 0], chamber_h, "H");
    }
}

module dim_x(origin, len, label) {
    translate(origin) {
        cube([len, 2, 2]);
        translate([0, -8, 0]) cube([2, 18, 2]);
        translate([len-2, -8, 0]) cube([2, 18, 2]);
        translate([len/2, 6, 0]) linear_extrude(1.2) text(str(label, "=", len, "mm"), size=20, halign="center");
    }
}

module dim_y(origin, len, label) {
    translate(origin) {
        cube([2, len, 2]);
        translate([-8, 0, 0]) cube([18, 2, 2]);
        translate([-8, len-2, 0]) cube([18, 2, 2]);
        translate([8, len/2, 0]) linear_extrude(1.2) text(str(label, "=", len, "mm"), size=20, halign="left");
    }
}

module dim_z(origin, len, label) {
    translate(origin) {
        cube([2, 2, len]);
        translate([-8, 0, 0]) cube([18, 2, 2]);
        translate([-8, 0, len-2]) cube([18, 2, 2]);
        translate([8, 0, len/2]) rotate([90, 0, 0]) linear_extrude(1.2) text(str(label, "=", len, "mm"), size=20, halign="left");
    }
}
