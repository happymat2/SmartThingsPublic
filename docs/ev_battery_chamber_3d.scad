// EV Battery Chamber 3D Drawing (OpenSCAD)
// Units: mm
// Created from user sketch: 4 levels x 3 battery packs per level

$fn = 48;

// ===== Parameters =====
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

// ===== Colors =====
frame_color = [0.06, 0.21, 0.37];
chamber_color = [0.13, 0.36, 0.59, 0.25];
shelf_color = [0.58, 0.86, 0.95];
pack_color = [0.05, 0.70, 0.32];
terminal_color = [0.92, 0.78, 0.16];

// ===== Main Assembly =====
translate([0, 0, 0])
assembly();

module assembly() {
    // Semi-transparent chamber body
    color(chamber_color)
    chamber_shell();

    // Structural frame
    color(frame_color)
    frame_members();

    // Shelves + packs
    for (r = [0 : levels-1]) {
        z0 = base_offset + r * level_clearance;

        color(shelf_color)
        shelf(z0);

        for (c = [0 : packs_per_row-1]) {
            x0 = row_side_margin + c * (pack_w + pack_gap);
            y0 = front_recess;
            z_pack = z0 + shelf_t + 20;

            translate([x0, y0, z_pack])
            battery_pack();
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
            translate([x, y, 0])
                cube([frame_t, frame_t, chamber_h]);

    // Top/bottom perimeter beams
    for (z = [0, chamber_h-frame_t]) {
        // Front/back beams
        translate([0, 0, z]) cube([chamber_w, frame_t, frame_t]);
        translate([0, chamber_d-frame_t, z]) cube([chamber_w, frame_t, frame_t]);
        // Left/right beams
        translate([0, 0, z]) cube([frame_t, chamber_d, frame_t]);
        translate([chamber_w-frame_t, 0, z]) cube([frame_t, chamber_d, frame_t]);
    }

    // Intermediate support beams under each shelf
    for (r = [0 : levels-1]) {
        z0 = base_offset + r * level_clearance - shelf_beam_h;
        translate([frame_t, frame_t, z0])
            cube([chamber_w-2*frame_t, frame_t, shelf_beam_h]);
        translate([frame_t, chamber_d-2*frame_t, z0])
            cube([chamber_w-2*frame_t, frame_t, shelf_beam_h]);
    }
}

module shelf(z0) {
    translate([frame_t, frame_t, z0])
        cube([chamber_w-2*frame_t, chamber_d-2*frame_t, shelf_t]);
}

module battery_pack() {
    // Pack body (rounded rectangular via minkowski)
    color(pack_color)
    rounded_box(pack_w, pack_d, pack_h, 8);

    // Top cover step
    color([0.03, 0.55, 0.25])
    translate([15, 15, pack_h])
        cube([pack_w-30, pack_d-30, 12]);

    // Terminals (positive / negative)
    color(terminal_color)
    translate([pack_w*0.30, pack_d*0.12, pack_h+12]) cylinder(h=16, r=10);

    color([0.65, 0.65, 0.65])
    translate([pack_w*0.70, pack_d*0.12, pack_h+12]) cylinder(h=16, r=10);
}

module rounded_box(w, d, h, r) {
    minkowski() {
        cube([w-2*r, d-2*r, h-r]);
        cylinder(r=r, h=r);
    }
}
