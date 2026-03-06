#!/usr/bin/env python3
"""
Entasis Column TEXTMAP Generator for GZDoom (UDMF format)
===========================================================

Generates a COMPLETE, self-contained TEXTMAP file:
  1. A box room sized to fit the column (auto-expands if needed)
  2. An arc-shaped arch column: the centreline follows a circular arc,
     and the column has a width (thickness) that varies along the arc
     via an entasis profile
  3. A 3D floor control sector that lifts the column off the ground

Shape: a curved strip of sectors following a circular arc centreline.
The column lies flat in the XY plane — export as a model and rotate
90° to stand it vertically.

Entasis profile modulates the column half-width along the arc:
  t=0 and t=1  -> w_capital (the two springer/capital ends)
  t=0.5        -> w_crown   (the crown, midpoint of the arch)

  parabolic: w(t) = w_crown + (w_capital - w_crown) * (2t-1)^2
             Faster transition near ends, flatter middle.
  elliptic:  w(t) = w_crown + (w_capital - w_crown) * |2t-1|
             Linear taper from crown to capitals. (simple, clean)
  constant:  w(t) = w_capital throughout (set w_crown = w_capital)

Usage:
    python entasis_column.py
    produces TEXTMAP_entasis_column.txt (a complete TEXTMAP)

Defaults produce a horseshoe U-shape (arc_span=270°) matching the Giger
pilaster column style.
"""

import math
import sys


# =========================================================================
# CONFIGURATION — edit these values, then run the script
# Entasis = "width profile along the arc"
# Set w_crown equal to w_capital for uniform width (no entasis)
# arc_radius Centreline radius (map units)
# arc_span how much of the circle it arcs through
# =========================================================================

# Prometheus Ampule Room Params. 135, large, for support
arc_span     = 135.0 
arc_radius   = 512.0  
w_capital    = 64.0
w_crown      = 32.0

# Horseshoe params. 270, thin, small for door
arc_span     = 270.0
arc_radius   = 256.0   # Centreline radius (map units)
w_capital    = 32.0
w_crown      = 16.0 

profile_type = "parabolic"  # "parabolic", "elliptic", or "constant"

arc_start_angle = 0.0   # Start angle in degrees (CCW from +X axis)

segments = 24             # Number of arc sectors. Higher = smoother. >= 4.
segments = 8

# --- Arc centre position ---
arc_center_x = 0.0
arc_center_y = 0.0

# --- Box room ---
box_min_halfwidth = 1024
box_height        = 1024
box_texture_floor   = "FLAT19"
box_texture_ceiling = "FLAT19"
box_texture_wall    = "FLAT19"
box_lightlevel    = 192

# --- Column sector appearance ---
# Floor/ceiling heights MUST match box so column blends into room.
# The 3D floor creates the visual raised slab.
col_texturefloor   = "FLAT19"
col_textureceiling = "FLAT19"
col_lightlevel     = 192

# --- 3D floor (the floating slab) ---
floor3d_z_bottom = 128
floor3d_z_top    = 192
floor3d_texture_floor   = "DEM1_5"
floor3d_texture_ceiling = "DEM1_5"
floor3d_texture_wall    = "DEM1_5"
floor3d_lightlevel = 192
floor3d_tag        = 1   # Tag shared by all column sectors

# --- Output ---
output_file = "./wad_internals/entasis_column_TEXTMAP.txt"


# =========================================================================
# GENERATION — no need to edit below this line
# =========================================================================

def half_width(t):
    """Column half-width at arc parameter t (0=start, 0.5=crown, 1=end)."""
    if profile_type == "constant":
        return w_capital
    u = abs(2.0 * t - 1.0)   # 0 at crown, 1 at endpoints
    if profile_type == "parabolic":
        return w_crown + (w_capital - w_crown) * u * u
    elif profile_type == "elliptic":
        return w_crown + (w_capital - w_crown) * u
    else:
        sys.exit(f"Error: unknown profile_type '{profile_type}'. "
                 "Use 'parabolic', 'elliptic', or 'constant'.")


def generate():
    # --- Validate ---
    if arc_radius <= 0:
        sys.exit("Error: arc_radius must be positive.")
    if not (0 < arc_span < 360):
        sys.exit("Error: arc_span must be strictly between 0 and 360 degrees. "
                 "For a full ring use gothic_vault.py.")
    if w_capital <= 0 or w_crown <= 0:
        sys.exit("Error: w_capital and w_crown must be positive.")
    if arc_radius <= w_capital:
        sys.exit(f"Error: arc_radius ({arc_radius}) must be greater than "
                 f"w_capital ({w_capital}) so the inner edge doesn't fold inward.")
    if segments < 4:
        sys.exit("Error: segments must be >= 4.")
    if floor3d_z_bottom >= floor3d_z_top:
        sys.exit("Error: floor3d_z_bottom must be less than floor3d_z_top.")
    if floor3d_z_top > box_height:
        sys.exit("Error: floor3d_z_top exceeds box_height.")

    cx = arc_center_x
    cy = arc_center_y
    span_rad  = math.radians(arc_span)
    start_rad = math.radians(arc_start_angle)

    # Maximum possible outer radius (at the endpoints where w is largest)
    max_outer = arc_radius + w_capital

    # --- Dynamic box sizing ---
    padding = 64
    needed = max(abs(cx), abs(cy)) + max_outer + padding
    half = max(box_min_halfwidth, math.ceil(needed / 64) * 64)

    # --- Index counters ---
    vi = 0
    li = 0
    si = 0
    sec_i = 0

    vtx  = []
    lds  = []
    sds  = []
    secs = []

    # =================================================================
    # PART 1: Box room (same as uzumaki.py)
    # =================================================================
    box_verts = [
        (-half, -half),
        (-half,  half),
        ( half,  half),
        ( half, -half),
    ]
    for x, y in box_verts:
        vtx.append((vi, float(x), float(y)))
        vi += 1

    box_sector = sec_i
    secs.append({
        'idx': sec_i,
        'heightfloor': 0,
        'heightceiling': box_height,
        'texturefloor': box_texture_floor,
        'textureceiling': box_texture_ceiling,
        'lightlevel': box_lightlevel,
    })
    sec_i += 1

    for j in range(4):
        v1 = j
        v2 = (j + 1) % 4
        sds.append({'idx': si, 'sector': box_sector, 'texturemiddle': box_texture_wall})
        lds.append({'idx': li, 'v1': v1, 'v2': v2, 'sidefront': si, 'blocking': True})
        si += 1
        li += 1

    # =================================================================
    # PART 2: Arc vertices
    # =================================================================
    # outer_v[i]: on the outside of the arc (arc_radius + hw)
    # inner_v[i]: on the inside of the arc (arc_radius - hw)
    outer_v = []
    inner_v = []

    for i in range(segments + 1):
        t = i / segments
        theta = start_rad + t * span_rad
        hw = half_width(t)

        r_out = arc_radius + hw
        r_in  = arc_radius - hw

        ox = cx + r_out * math.cos(theta)
        oy = cy + r_out * math.sin(theta)
        outer_v.append(vi)
        vtx.append((vi, round(ox, 3), round(oy, 3)))
        vi += 1

        ix = cx + r_in * math.cos(theta)
        iy = cy + r_in * math.sin(theta)
        inner_v.append(vi)
        vtx.append((vi, round(ix, 3), round(iy, 3)))
        vi += 1

    # =================================================================
    # PART 3: Column sectors (all share floor3d_tag)
    # =================================================================
    col_sectors = []
    for i in range(segments):
        col_sectors.append(sec_i)
        secs.append({
            'idx': sec_i,
            'heightfloor': 0,
            'heightceiling': box_height,
            'texturefloor': col_texturefloor,
            'textureceiling': col_textureceiling,
            'lightlevel': col_lightlevel,
            'id': floor3d_tag,
        })
        sec_i += 1

    # =================================================================
    # PART 4: Linedefs + sidedefs  (identical pattern to uzumaki.py)
    # =================================================================
    def emit_twosided(v1, v2, front_sector, back_sector):
        nonlocal li, si
        sd_f = si; si += 1
        sd_b = si; si += 1
        sds.append({'idx': sd_f, 'sector': front_sector})
        sds.append({'idx': sd_b, 'sector': back_sector})
        lds.append({
            'idx': li, 'v1': v1, 'v2': v2,
            'sidefront': sd_f, 'sideback': sd_b,
            'twosided': True,
        })
        li += 1

    # Leading radial (start cap)
    emit_twosided(outer_v[0], inner_v[0],
                  front_sector=col_sectors[0],
                  back_sector=box_sector)

    for i in range(segments):
        # Outer arc: outer[i] -> outer[i+1]   front=box, back=col[i]
        emit_twosided(outer_v[i], outer_v[i + 1],
                      front_sector=box_sector,
                      back_sector=col_sectors[i])

        # Internal radial (shared between col[i] and col[i+1])
        # or trailing radial (end cap) for the last segment
        if i < segments - 1:
            emit_twosided(outer_v[i + 1], inner_v[i + 1],
                          front_sector=col_sectors[i + 1],
                          back_sector=col_sectors[i])
        else:
            emit_twosided(outer_v[i + 1], inner_v[i + 1],
                          front_sector=box_sector,
                          back_sector=col_sectors[i])

        # Inner arc: inner[i] -> inner[i+1]   front=col[i], back=box
        emit_twosided(inner_v[i], inner_v[i + 1],
                      front_sector=col_sectors[i],
                      back_sector=box_sector)

    # =================================================================
    # PART 5: 3D floor control sector (off-map, same as uzumaki.py)
    # =================================================================
    ctrl_x  = half + 64
    ctrl_y  = 0
    ctrl_sz = 64

    ctrl_verts = [
        (ctrl_x,           ctrl_y),
        (ctrl_x + ctrl_sz, ctrl_y),
        (ctrl_x + ctrl_sz, ctrl_y - ctrl_sz),
        (ctrl_x,           ctrl_y - ctrl_sz),
    ]
    cv = []
    for x, y in ctrl_verts:
        cv.append(vi)
        vtx.append((vi, float(x), float(y)))
        vi += 1

    ctrl_sector = sec_i
    secs.append({
        'idx': sec_i,
        'heightfloor': floor3d_z_bottom,
        'heightceiling': floor3d_z_top,
        'texturefloor': floor3d_texture_floor,
        'textureceiling': floor3d_texture_ceiling,
        'lightlevel': floor3d_lightlevel,
        'user_managed_3d_floor': True,
    })
    sec_i += 1

    for j in range(4):
        v1 = cv[j]
        v2 = cv[(j + 1) % 4]
        sds.append({'idx': si, 'sector': ctrl_sector,
                    'texturemiddle': floor3d_texture_wall})
        ld = {'idx': li, 'v1': v1, 'v2': v2, 'sidefront': si, 'blocking': True}
        if j == 0:
            ld['special'] = 160
            ld['arg0'] = floor3d_tag
            ld['arg1'] = 1
            ld['arg3'] = 255
        lds.append(ld)
        si += 1
        li += 1

    # =================================================================
    # WRITE OUTPUT
    # =================================================================
    with open(output_file, 'w') as f:
        f.write('namespace = "zdoom";\n')

        f.write(f"\n// ===========================================================\n")
        f.write(f"// ENTASIS ARCH COLUMN: {profile_type} profile\n")
        f.write(f"// Arc: radius={arc_radius}, span={arc_span}deg, "
                f"start={arc_start_angle}deg\n")
        f.write(f"// Width: w_capital={w_capital}, w_crown={w_crown}\n")
        f.write(f"// Centre: ({cx}, {cy}), Box: {half*2}x{half*2}x{box_height}\n")
        f.write(f"// Segments: {segments}\n")
        f.write(f"// 3D floor: Z {floor3d_z_bottom}-{floor3d_z_top}, "
                f"tag {floor3d_tag}, texture {floor3d_texture_floor}\n")
        f.write(f"// Totals: {vi} vertices, {li} linedefs, {si} sidedefs, "
                f"{sec_i} sectors\n")
        f.write(f"// ===========================================================\n")

        f.write(f"\n// ---- VERTICES (0 to {vi - 1}) ----\n\n")
        for idx, x, y in vtx:
            f.write(f"vertex // {idx}\n{{\nx = {x};\ny = {y};\n}}\n\n")

        f.write(f"// ---- LINEDEFS (0 to {li - 1}) ----\n\n")
        for ld in lds:
            f.write(f"linedef // {ld['idx']}\n{{\n")
            f.write(f"v1 = {ld['v1']};\n")
            f.write(f"v2 = {ld['v2']};\n")
            f.write(f"sidefront = {ld['sidefront']};\n")
            if 'sideback' in ld:
                f.write(f"sideback = {ld['sideback']};\n")
            if ld.get('twosided'):
                f.write("twosided = true;\n")
                f.write("blocking = false;\n")
            elif ld.get('blocking'):
                f.write("blocking = true;\n")
            if 'special' in ld:
                f.write(f"special = {ld['special']};\n")
                f.write(f"arg0 = {ld['arg0']};\n")
                f.write(f"arg1 = {ld['arg1']};\n")
                f.write(f"arg3 = {ld['arg3']};\n")
            f.write("}\n\n")

        f.write(f"// ---- SIDEDEFS (0 to {si - 1}) ----\n\n")
        for sd in sds:
            f.write(f"sidedef // {sd['idx']}\n{{\n")
            f.write(f"sector = {sd['sector']};\n")
            if 'texturemiddle' in sd:
                f.write(f'texturemiddle = "{sd["texturemiddle"]}";\n')
            f.write("}\n\n")

        f.write(f"// ---- SECTORS (0 to {sec_i - 1}) ----\n\n")
        for sec in secs:
            f.write(f"sector // {sec['idx']}\n{{\n")
            f.write(f"heightfloor = {sec['heightfloor']};\n")
            f.write(f"heightceiling = {sec['heightceiling']};\n")
            f.write(f'texturefloor = "{sec["texturefloor"]}";\n')
            f.write(f'textureceiling = "{sec["textureceiling"]}";\n')
            f.write(f"lightlevel = {sec['lightlevel']};\n")
            if 'id' in sec:
                f.write(f"id = {sec['id']};\n")
            if sec.get('user_managed_3d_floor'):
                f.write("user_managed_3d_floor = true;\n")
                f.write('comment = "[!]DO NOT DELETE! 3D floor control sector.";\n')
            f.write("}\n\n")

    print(f"Complete TEXTMAP generated -> {output_file}")
    print(f"  Box: {half*2}x{half*2}x{box_height}"
          f"{' (auto-expanded)' if half > box_min_halfwidth else ''}")
    print(f"  Arc: radius={arc_radius}, span={arc_span}deg, "
          f"start={arc_start_angle}deg")
    print(f"  Width: {profile_type}, w_capital={w_capital}, w_crown={w_crown}")
    print(f"  {segments} segments")
    print(f"  3D floor: Z {floor3d_z_bottom}-{floor3d_z_top} (tag {floor3d_tag})")
    print(f"  Totals: {vi} vertices, {li} linedefs, {si} sidedefs, {sec_i} sectors")


if __name__ == "__main__":
    generate()
