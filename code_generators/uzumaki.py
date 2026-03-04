#!/usr/bin/env python3
"""
Uzumaki Spiral TEXTMAP Generator for GZDoom (UDMF format)
=============================================================

Generates a COMPLETE, self-contained TEXTMAP file:
  1. A box room sized to fit the spiral (auto-expands if needed)
  2. An Archimedean spiral (r = b * theta) embedded inside the box
  3. A 3D floor control sector that lifts the entire spiral off the ground

The output replaces your entire TEXTMAP — just copy it over.

Usage:
    python uzumaki.py
    produces TEXTMAP_uzumaki.txt (a complete TEXTMAP)

3D Floor Mechanism:
    Every spiral sector shares a single tag. One off-map control sector
    has a linedef with special 160 (Sector_Set3dFloor) targeting that tag.
    The control sector's floor/ceiling heights define the floating slab,
    and its textures define the slab's visible surfaces.
"""

import math
import sys


# =========================================================================
# CONFIGURATION — edit these values, then run the script
# =========================================================================

# --- Core spiral geometry ---
# Thicc Uzumaki
b = 16.0                  # Growth rate: r = b * theta (map units per radian)
thickness = 96.0          # Radial width of the spiral arm (map units)

# Thin Uzumaki
b = 24.0                  # Growth rate: r = b * theta (map units per radian)
thickness = 64.0          # Radial width of the spiral arm (map units)

number_of_loops = 9       # How many full 360-degree revolutions
start_vertex_x = 0.0      # X of spiral center
start_vertex_y = 0.0      # Y of spiral center

# --- Resolution ---
# Sectors per 360-degree loop. Higher = smoother, more geometry.
# 48 is smooth, 24 is coarse-but-light. Must be >= 8.
segments_per_loop = 8

# --- Box room ---
# Minimum half-width of the box (box extends from -half to +half on each
# axis, centered on the origin). If the spiral needs more space, the box
# auto-expands. Set this larger if you want extra room around the spiral.
box_min_halfwidth = 1024
box_height = 1024          # Ceiling height of the box room
box_texture_floor = "FLAT19"
box_texture_ceiling = "FLAT19"
box_texture_wall = "FLAT19"
box_lightlevel = 192

# --- Spiral sector appearance ---
# Floor/ceiling heights MUST match the box so the spiral sectors blend
# seamlessly into the room. The visual distinction comes from the 3D
# floor, not from these values. The texture here is what you see on the
# room floor *through* the spiral sector (under the floating slab).
spiral_texturefloor = "FLAT19"
spiral_textureceiling = "FLAT19"
spiral_lightlevel = 192

# --- 3D floor (the floating slab) ---
# This is the visible raised platform that makes the spiral stand out.
# The control sector's floor/ceiling define the slab's bottom/top Z.
floor3d_z_bottom = 128     # Bottom of the floating slab (Z)
floor3d_z_top = 192        # Top of the floating slab (Z)
floor3d_texture_floor = "DEM1_5"   # Underside of slab
floor3d_texture_ceiling = "DEM1_5" # Top surface of slab
floor3d_texture_wall = "DEM1_5"    # Edge of slab
floor3d_lightlevel = 192
floor3d_tag = 1            # Tag shared by all spiral sectors

# --- Output ---
output_file = "./wad_internals/TEXTMAP_uzumaki.txt"


# =========================================================================
# GENERATION — no need to edit below this line
# =========================================================================

def generate():
    # --- Validate ---
    if b <= 0:
        sys.exit("Error: b must be positive.")
    if number_of_loops < 1:
        sys.exit("Error: number_of_loops must be >= 1.")
    if thickness <= 0:
        sys.exit("Error: thickness must be positive.")
    if segments_per_loop < 8:
        sys.exit("Error: segments_per_loop must be >= 8.")
    if floor3d_z_bottom >= floor3d_z_top:
        sys.exit("Error: floor3d_z_bottom must be less than floor3d_z_top.")
    if floor3d_z_top > box_height:
        sys.exit("Error: floor3d_z_top exceeds box_height.")

    arm_gap = 2 * math.pi * b - thickness
    if arm_gap < 0:
        sys.exit(
            f"Error: arms overlap. Gap = {arm_gap:.1f} (must be > 0).\n"
            f"Either increase b or decrease thickness. "
            f"Min b for this thickness: {thickness / (2 * math.pi):.2f}"
        )

    n_segments = segments_per_loop * number_of_loops
    dtheta = 2 * math.pi / segments_per_loop
    theta_max = dtheta * n_segments
    max_r = b * theta_max + thickness

    # --- Dynamic box sizing ---
    # The box must contain the spiral with some padding. Expand if needed.
    padding = 64
    needed_x = abs(start_vertex_x) + max_r + padding
    needed_y = abs(start_vertex_y) + max_r + padding
    needed = max(needed_x, needed_y)
    # Round up to next multiple of 64 for clean grid alignment
    half = max(box_min_halfwidth, math.ceil(needed / 64) * 64)

    cx, cy = start_vertex_x, start_vertex_y

    # --- Index counters ---
    vi = 0   # vertex
    li = 0   # linedef
    si = 0   # sidedef
    sec_i = 0  # sector

    vtx = []   # (index, x, y)
    lds = []   # list of dicts
    sds = []   # list of dicts
    secs = []  # list of dicts

    # =================================================================
    # PART 1: Box room
    # =================================================================
    # 4 vertices, 4 one-sided linedefs, 4 sidedefs, 1 sector
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

    # Box walls: one-sided linedefs winding clockwise (v0→v1→v2→v3→v0)
    for j in range(4):
        v1 = j
        v2 = (j + 1) % 4
        sds.append({'idx': si, 'sector': box_sector, 'texturemiddle': box_texture_wall})
        lds.append({
            'idx': li, 'v1': v1, 'v2': v2,
            'sidefront': si, 'blocking': True,
        })
        si += 1
        li += 1

    # =================================================================
    # PART 2: Spiral vertices
    # =================================================================
    outer_v = []
    inner_v = []

    for i in range(n_segments + 1):
        theta = i * dtheta
        r_in = b * theta
        r_out = r_in + thickness

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
    # PART 3: Spiral sectors (all share floor3d_tag)
    # =================================================================
    spiral_sector_indices = []
    for i in range(n_segments):
        spiral_sector_indices.append(sec_i)
        sec_data = {
            'idx': sec_i,
            'heightfloor': 0,
            'heightceiling': box_height,
            'texturefloor': spiral_texturefloor,
            'textureceiling': spiral_textureceiling,
            'lightlevel': spiral_lightlevel,
            'id': floor3d_tag,
        }
        secs.append(sec_data)
        sec_i += 1

    # =================================================================
    # PART 4: Spiral linedefs + sidedefs
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

    # Leading radial
    emit_twosided(outer_v[0], inner_v[0],
                  front_sector=spiral_sector_indices[0],
                  back_sector=box_sector)

    for i in range(n_segments):
        # Outer arc
        emit_twosided(outer_v[i], outer_v[i + 1],
                      front_sector=box_sector,
                      back_sector=spiral_sector_indices[i])
        # Trailing radial
        if i < n_segments - 1:
            emit_twosided(outer_v[i + 1], inner_v[i + 1],
                          front_sector=spiral_sector_indices[i + 1],
                          back_sector=spiral_sector_indices[i])
        else:
            emit_twosided(outer_v[i + 1], inner_v[i + 1],
                          front_sector=box_sector,
                          back_sector=spiral_sector_indices[i])
        # Inner arc
        emit_twosided(inner_v[i], inner_v[i + 1],
                      front_sector=spiral_sector_indices[i],
                      back_sector=box_sector)

    # =================================================================
    # PART 5: 3D floor control sector (off-map)
    # =================================================================
    # Place the control sector rectangle outside the box, top-right.
    ctrl_x = half + 64
    ctrl_y = 0
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

    # 4 linedefs for control sector; first one carries the 3D floor special
    for j in range(4):
        v1 = cv[j]
        v2 = cv[(j + 1) % 4]
        sds.append({
            'idx': si, 'sector': ctrl_sector,
            'texturemiddle': floor3d_texture_wall,
        })
        ld = {
            'idx': li, 'v1': v1, 'v2': v2,
            'sidefront': si, 'blocking': True,
        }
        if j == 0:
            # Sector_Set3dFloor: special=160, arg0=tag, arg1=1 (solid), arg3=255 (full opacity)
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

        # --- Header comment ---
        f.write(f"\n// ===========================================================\n")
        f.write(f"// UZUMAKI ARCHIMEDEAN SPIRAL: r = {b} * theta\n")
        f.write(f"// Center: ({cx}, {cy}), Box: {half*2} x {half*2} x {box_height}\n")
        f.write(f"// Loops: {number_of_loops}, Arm width: {thickness}\n")
        f.write(f"// Segments: {n_segments} ({segments_per_loop}/loop)\n")
        f.write(f"// 3D floor: Z {floor3d_z_bottom}-{floor3d_z_top}, "
                f"tag {floor3d_tag}, texture {floor3d_texture_floor}\n")
        f.write(f"// Outer radius: {thickness:.0f} -> {max_r:.0f}\n")
        f.write(f"// ===========================================================\n")

        # --- Vertices ---
        f.write(f"\n// ---- VERTICES (0 to {vi - 1}) ----\n\n")
        for idx, x, y in vtx:
            f.write(f"vertex // {idx}\n{{\nx = {x};\ny = {y};\n}}\n\n")

        # --- Linedefs ---
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

        # --- Sidedefs ---
        f.write(f"// ---- SIDEDEFS (0 to {si - 1}) ----\n\n")
        for sd in sds:
            f.write(f"sidedef // {sd['idx']}\n{{\n")
            f.write(f"sector = {sd['sector']};\n")
            if 'texturemiddle' in sd:
                f.write(f'texturemiddle = "{sd["texturemiddle"]}";\n')
            f.write("}\n\n")

        # --- Sectors ---
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

    # --- Summary ---
    print(f"Complete TEXTMAP generated -> {output_file}")
    print(f"  Box: {half*2}x{half*2}x{box_height}"
          f"{' (auto-expanded)' if half > box_min_halfwidth else ''}")
    print(f"  Spiral: r = {b}*theta, center ({cx}, {cy})")
    print(f"  {number_of_loops} loops x {segments_per_loop} seg/loop = {n_segments} sectors")
    print(f"  Arm width: {thickness}, loop gap: {arm_gap:.1f}")
    print(f"  Outer radius: {thickness:.0f} -> {max_r:.0f}")
    print(f"  3D floor: Z {floor3d_z_bottom}-{floor3d_z_top} (tag {floor3d_tag})")
    print(f"  Totals: {vi} vertices, {li} linedefs, {si} sidedefs, {sec_i} sectors")


if __name__ == "__main__":
    generate()
