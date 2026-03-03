#!/usr/bin/env python3
"""
Archimedean Spiral TEXTMAP Generator for GZDoom (UDMF format)
=============================================================

Generates TEXTMAP code for a flat Archimedean spiral (r = b * theta) that can
be copy-pasted into an existing TEXTMAP file.

The spiral is a ribbon-shaped arm that starts at a center point and winds
outward. Each segment of the arm is a quad-shaped sector bounded by inner
and outer edges plus radial edges shared with neighboring segments.

Assumes the target TEXTMAP is a simple box room:
    TEXTMAP_2048x2048x1024_box.txt
    - 4 vertices (0-3), 4 linedefs (0-3), 4 sidedefs (0-3), 1 sector (0)
    - Room bounds: X [-1024, 1024], Y [-1024, 1024], Z [0, 1024]
    - All starting indices are set accordingly.

Usage:
    python uzumaki.py

    Edit the parameters in the CONFIGURATION section below, then run.
    Paste the output directly after the last sector in the box TEXTMAP
    (before the final blank line / EOF).

Linedef Convention:
    For a linedef v1 -> v2, the RIGHT side is sidefront, LEFT side is sideback.
    - Outer arc:      front = containing room,  back = spiral sector
    - Inner arc:      front = spiral sector,    back = containing room
    - Shared radial:  front = next sector,      back = previous sector
    - Boundary radial endpoints: front = spiral, back = containing room
"""

import math
import sys


# =========================================================================
# CONFIGURATION — edit these values, then run the script
# =========================================================================

# --- Core spiral parameters ---

# Thicc Uzumaki
b = 16.0                  # Growth rate: r = b * theta (map units per radian)
thickness = 96.0          # Radial width of the spiral arm (map units)

# Thin Uzumaki
b = 24.0                  # Growth rate: r = b * theta (map units per radian)
thickness = 64.0          # Radial width of the spiral arm (map units)

number_of_loops = 5       # How many full 360-degree revolutions the arm makes

start_vertex_x = 0.0      # X of spiral center (0 = room center)
start_vertex_y = 0.0       # Y of spiral center (0 = room center)

# --- Resolution ---
# Sectors per 360-degree loop. Higher = smoother curve, more geometry.
# 48 is smooth, 24 is coarse-but-light. Must be >= 8.
segments_per_loop = 24

# --- TEXTMAP index offsets ---
# These pick up where the 2048x2048x1024 box leaves off.
# The box uses vertices 0-3, linedefs 0-3, sidedefs 0-3, sector 0.
# If you have OTHER geometry already added to the box, increase these
# to one past the highest existing index for each element type.
start_vertex_idx = 4
start_linedef_idx = 4
start_sidedef_idx = 4
start_sector_idx = 1

# --- Containing sector ---
# The sector the spiral sits inside. For the box, this is sector 0.
# All spiral boundary linedefs are two-sided with this sector on the
# opposite face — required so edges render correctly (no void/HOM).
containing_sector = 0

# --- Sector appearance ---
# Floor and ceiling heights MUST match the containing room, otherwise
# the spiral sectors create visible height steps at their boundaries.
# The box has floor=0, ceiling=1024.
# Change texturefloor to give the spiral a visually distinct surface.
heightfloor = 0
heightceiling = 1024
texturefloor = "FLAT14"
textureceiling = "FLAT19"
lightlevel = 192

# --- Output ---
output_file = "./wad_internals/uzumaki_for_TEXTMAP.txt"


# =========================================================================
# GENERATION — no need to edit below this line
# =========================================================================

def generate_spiral():
    """Generate all TEXTMAP elements for the Archimedean spiral."""

    # --- Validate ---
    if b <= 0:
        sys.exit("Error: b must be positive.")
    if number_of_loops < 1:
        sys.exit("Error: number_of_loops must be >= 1.")
    if thickness <= 0:
        sys.exit("Error: thickness must be positive.")
    if segments_per_loop < 8:
        sys.exit("Error: segments_per_loop must be >= 8.")

    # Arm spacing: gap between successive loops = 2*pi*b - thickness.
    # Negative means the arms overlap, which creates invalid geometry.
    arm_gap = 2 * math.pi * b - thickness
    if arm_gap < 0:
        sys.exit(
            f"Error: arms overlap. With b={b} and thickness={thickness}, "
            f"the radial gap between loops is {arm_gap:.1f} (must be > 0).\n"
            f"Either increase b or decrease thickness. "
            f"Min b for this thickness: {thickness / (2 * math.pi):.2f}"
        )

    # Check the spiral fits inside the box room (+-1024 from origin)
    n_segments = segments_per_loop * number_of_loops
    dtheta = 2 * math.pi / segments_per_loop
    theta_max = dtheta * n_segments
    max_r = b * theta_max + thickness
    room_half = 1024.0
    margin = room_half - max(abs(start_vertex_x), abs(start_vertex_y)) - max_r
    if margin < 0:
        print(
            f"WARNING: spiral outer radius ({max_r:.0f}) may exceed room "
            f"bounds by ~{-margin:.0f} map units. The spiral will clip "
            f"through walls. Reduce b, number_of_loops, or thickness.",
            file=sys.stderr
        )

    cx, cy = start_vertex_x, start_vertex_y

    # --- Index counters ---
    vi = start_vertex_idx
    li = start_linedef_idx
    si = start_sidedef_idx
    sec_i = start_sector_idx

    vertex_lines = []
    linedef_lines = []
    sidedef_lines = []
    sector_lines = []

    # =================================================================
    # STEP 1: Vertices
    # =================================================================
    # Two concentric edges trace the arm:
    #   inner: r_in(theta)  = b * theta
    #   outer: r_out(theta) = b * theta + thickness
    #
    # At theta=0 the inner edge is at the center point (r=0).
    # We emit (n_segments + 1) vertices on each edge, interleaved:
    #   even indices = outer, odd indices = inner.

    outer_v = []
    inner_v = []

    for i in range(n_segments + 1):
        theta = i * dtheta
        r_in = b * theta
        r_out = r_in + thickness

        ox = cx + r_out * math.cos(theta)
        oy = cy + r_out * math.sin(theta)
        outer_v.append(vi)
        vertex_lines.append(
            f"vertex // {vi}\n{{\nx = {round(ox, 3)};\ny = {round(oy, 3)};\n}}\n"
        )
        vi += 1

        ix = cx + r_in * math.cos(theta)
        iy = cy + r_in * math.sin(theta)
        inner_v.append(vi)
        vertex_lines.append(
            f"vertex // {vi}\n{{\nx = {round(ix, 3)};\ny = {round(iy, 3)};\n}}\n"
        )
        vi += 1

    # =================================================================
    # STEP 2: Sectors
    # =================================================================
    sector_indices = []
    for i in range(n_segments):
        sector_indices.append(sec_i)
        sector_lines.append(
            f"sector // {sec_i}\n{{\n"
            f"heightfloor = {heightfloor};\n"
            f"heightceiling = {heightceiling};\n"
            f'texturefloor = "{texturefloor}";\n'
            f'textureceiling = "{textureceiling}";\n'
            f"lightlevel = {lightlevel};\n"
            f"}}\n"
        )
        sec_i += 1

    # =================================================================
    # STEP 3: Linedefs + Sidedefs
    # =================================================================
    def emit_twosided(v1, v2, front_sector, back_sector):
        """Emit a two-sided linedef and its two sidedefs."""
        nonlocal li, si
        sd_front = si; si += 1
        sd_back = si; si += 1
        sidedef_lines.append(
            f"sidedef // {sd_front}\n{{\nsector = {front_sector};\n}}\n"
        )
        sidedef_lines.append(
            f"sidedef // {sd_back}\n{{\nsector = {back_sector};\n}}\n"
        )
        linedef_lines.append(
            f"linedef // {li}\n{{\n"
            f"v1 = {v1};\nv2 = {v2};\n"
            f"sidefront = {sd_front};\nsideback = {sd_back};\n"
            f"twosided = true;\nblocking = false;\n"
            f"}}\n"
        )
        li += 1

    # Leading radial (start of arm): outer[0] -> inner[0]
    emit_twosided(outer_v[0], inner_v[0],
                  front_sector=sector_indices[0],
                  back_sector=containing_sector)

    for i in range(n_segments):
        # Outer arc: outer[i] -> outer[i+1]
        emit_twosided(outer_v[i], outer_v[i + 1],
                      front_sector=containing_sector,
                      back_sector=sector_indices[i])

        # Trailing radial: outer[i+1] -> inner[i+1]
        if i < n_segments - 1:
            emit_twosided(outer_v[i + 1], inner_v[i + 1],
                          front_sector=sector_indices[i + 1],
                          back_sector=sector_indices[i])
        else:
            emit_twosided(outer_v[i + 1], inner_v[i + 1],
                          front_sector=containing_sector,
                          back_sector=sector_indices[i])

        # Inner arc: inner[i] -> inner[i+1]
        emit_twosided(inner_v[i], inner_v[i + 1],
                      front_sector=sector_indices[i],
                      back_sector=containing_sector)

    # =================================================================
    # STEP 4: Write output
    # =================================================================
    with open(output_file, 'w') as f:
        f.write(f"// ===========================================================\n")
        f.write(f"// UZUMAKI r = {b} * theta\n")
        f.write(f"// Center: ({cx}, {cy})\n")
        f.write(f"// Loops: {number_of_loops}, Arm width: {thickness}\n")
        f.write(f"// Segments: {n_segments} ({segments_per_loop}/loop)\n")
        f.write(f"// Containing sector: {containing_sector}\n")
        f.write(f"// Outer radius range: {thickness:.1f} -> "
                f"{b * theta_max + thickness:.1f}\n")
        f.write(f"// ===========================================================\n\n")

        f.write(f"// ---- VERTICES (idx {start_vertex_idx} to {vi - 1}) ----\n\n")
        f.writelines(vertex_lines)

        f.write(f"\n// ---- LINEDEFS (idx {start_linedef_idx} to {li - 1}) ----\n\n")
        f.writelines(linedef_lines)

        f.write(f"\n// ---- SIDEDEFS (idx {start_sidedef_idx} to {si - 1}) ----\n\n")
        f.writelines(sidedef_lines)

        f.write(f"\n// ---- SECTORS (idx {start_sector_idx} to {sec_i - 1}) ----\n\n")
        f.writelines(sector_lines)

    # --- Summary ---
    print(f"Spiral generated -> {output_file}")
    print(f"  r = {b} * theta, center ({cx}, {cy})")
    print(f"  {number_of_loops} loops x {segments_per_loop} seg/loop = {n_segments} sectors")
    print(f"  Arm width: {thickness}, loop gap: {arm_gap:.1f}")
    print(f"  Outer radius: {thickness:.0f} -> {b * theta_max + thickness:.0f}")
    print(f"  Vertices:  {start_vertex_idx} to {vi - 1} ({vi - start_vertex_idx})")
    print(f"  Linedefs:  {start_linedef_idx} to {li - 1} ({li - start_linedef_idx})")
    print(f"  Sidedefs:  {start_sidedef_idx} to {si - 1} ({si - start_sidedef_idx})")
    print(f"  Sectors:   {start_sector_idx} to {sec_i - 1} ({sec_i - start_sector_idx})")
    if margin < 0:
        print(f"  WARNING: Spiral exceeds room bounds by ~{-margin:.0f} units")


if __name__ == "__main__":
    generate_spiral()
