CONTEXT: GZDoom UDMF TEXTMAP Procedural Architecture Generation
================================================================

This document provides full context for understanding and extending the
Python-based procedural map generators in this codebase. It covers the
UDMF TEXTMAP format, GZDoom-specific features (3D floors, slopes), the
Archimedean spiral mathematics, and the linedef conventions discovered
through reverse-engineering hand-built maps in UDB (Ultimate Doom Builder).


1. TOOLCHAIN OVERVIEW
=====================

The project uses these tools in combination:

- GZDoom: Source port that runs the maps. Supports UDMF, 3D floors,
  slopes, ZScript, and other advanced features. Automatically builds
  GL nodes at load time if they're missing.

- SLADE: WAD/PK3 editor. Used to replace the TEXTMAP lump inside the
  WAD with generator output. Also used for importing textures, managing
  lumps, and rebuilding ZDBSP nodes.

- UDB (Ultimate Doom Builder): Visual map editor. Used for hand-building
  reference geometry (the "G" shape, the octagon room, etc.) which is
  then analysed to reverse-engineer the TEXTMAP conventions. UDB's
  "Managed 3D Floor" plugin auto-generates control sectors when you
  place 3D floors visually.

- VS Code: Development environment. The Python generators and TEXTMAP
  files live in a VS Code workspace alongside the WAD internals.

- Python generators: Scripts that output valid TEXTMAP text which can be
  copy-pasted (or piped) into a WAD's TEXTMAP lump.

The workflow is: edit parameters in Python -> run script -> copy output
into TEXTMAP via SLADE (or full file replacement) -> test in GZDoom.


2. UDMF TEXTMAP FORMAT
=======================

TEXTMAP is a plain-text map format used by GZDoom's UDMF (Universal Doom
Map Format). A TEXTMAP file begins with:

    namespace = "zdoom";

Then contains blocks of four element types, in order:

    vertex // INDEX { x = FLOAT; y = FLOAT; }
    linedef // INDEX { v1 = INT; v2 = INT; sidefront = INT; ... }
    sidedef // INDEX { sector = INT; texturemiddle = "NAME"; ... }
    sector // INDEX { heightfloor = INT; heightceiling = INT; ... }

(Plus optional "thing" blocks at the start, before vertices.)

Key rules:
- Indices are 0-based and must be sequential within each element type.
- Every linedef needs at least sidefront. Two-sided linedefs also need
  sideback and "twosided = true;".
- Every sidedef references exactly one sector.
- Sectors define floor/ceiling heights, textures, and light level.
- All coordinates are in map units (integers or floats).

Ordering within the file: things, vertices, linedefs, sidedefs, sectors.
When inserting generated content, each element type must go with its
corresponding section - vertices with vertices, linedefs with linedefs, etc.


3. LINEDEF SIDEDNESS CONVENTION
================================

This is the single most important convention for generating valid geometry.
Getting this wrong causes HOM (Hall of Mirrors), invisible walls, or
sectors that don't render.

For a linedef from v1 to v2:
- sidefront (RIGHT side when facing v1->v2 direction) 
- sideback (LEFT side when facing v1->v2 direction)

For the Archimedean spiral, the conventions are:

    Outer arc (outer[i] -> outer[i+1]):
        sidefront = containing room sector
        sideback  = spiral sector i

    Inner arc (inner[i] -> inner[i+1]):
        sidefront = spiral sector i
        sideback  = containing room sector

    Shared radial (outer[j] -> inner[j]):
        If j == 0 (leading edge):
            sidefront = spiral sector 0
            sideback  = containing room sector
        If 0 < j < N (internal shared edge):
            sidefront = spiral sector j  (next)
            sideback  = spiral sector j-1  (previous)
        If j == N (trailing edge):
            sidefront = containing room sector
            sideback  = spiral sector N-1

These were reverse-engineered from a working spiral built by hand in UDB,
by tracing every linedef -> sidedef -> sector relationship. The existing
working spiral lives in sector 15 (DEM1_5 room) with 144 FLAT14 spiral
sectors (sectors 16-159), centered at (0, -768).


4. ARCHIMEDEAN SPIRAL GEOMETRY
===============================

Equation: r = b * theta

Parameters:
    b           Growth rate (map units per radian)
    theta       Angle in radians (0 at start, increasing)
    thickness   Radial width of the spiral arm

The arm has two edges:
    inner edge: r_in(theta)  = b * theta
    outer edge: r_out(theta) = b * theta + thickness

At theta=0, the inner edge starts at the center point (r=0) and the
outer edge starts at r=thickness.

For N segments per loop and L loops, there are N*L total sectors.
Each sector is a quadrilateral (trapezoid) bounded by:
    - An outer arc segment (2 outer vertices)
    - An inner arc segment (2 inner vertices)
    - Two radial edges connecting outer to inner at each end

The angular step per segment is: dtheta = 2*pi / N

Vertex generation pattern:
    For i = 0 to (N*L):
        theta = i * dtheta
        outer_vertex: (cx + r_out * cos(theta), cy + r_out * sin(theta))
        inner_vertex: (cx + r_in * cos(theta),  cy + r_in * sin(theta))

Constraint: arm gap = 2*pi*b - thickness > 0, otherwise arms overlap.


5. 3D FLOORS (Sector_Set3dFloor)
=================================

3D floors create floating/solid platforms inside a room. They require:

A) Target sectors: The room sectors where the 3D floor appears. These
   need a tag ID. Multiple sectors can share the same tag.
   Set via: "id = TAG;" in the sector block.
   Multiple tags: "id = FIRST; moreids = "SECOND THIRD";"

B) Control sector: An off-map sector whose floor/ceiling heights define
   the 3D floor's bottom/top surfaces. The control sector should have:
   - heightfloor = bottom Z of the floating slab
   - heightceiling = top Z of the floating slab
   - texturefloor = underside texture of slab
   - textureceiling = top surface texture of slab
   - user_managed_3d_floor = true;
   - comment = "[!]DO NOT DELETE! 3D floor control sector.";

C) Trigger linedef: One linedef in the control sector must have:
   - special = 160;   (Sector_Set3dFloor action)
   - arg0 = TAG;      (matches target sector tag)
   - arg1 = 1;        (type: solid, non-translucent)
   - arg3 = 255;      (opacity: fully opaque)

The control sector is placed off-map (outside the playable area) as a
simple rectangle. Its sidedefs need texturemiddle set to the edge texture.

For the spiral generators: all spiral sectors share a single tag, and
one control sector with one trigger linedef creates a 3D floor across
the entire spiral shape.


6. SLOPED 3D FLOORS (Advanced)
================================

GZDoom supports slopes on 3D floors via plane equation parameters on
the control sector. These create tilted floating platforms.

Plane equation format: a*x + b*y + c*z + d = 0

Floor plane (normal points UP):
    floorplane_a, floorplane_b, floorplane_c (positive), floorplane_d

Ceiling plane (normal points DOWN):
    ceilingplane_a, ceilingplane_b, ceilingplane_c (negative), ceilingplane_d

For a slope in the X direction with gradient "slope" (dz/dx):
    Floor: z = z_ref + slope * (x - x_ref)
    Raw coefficients: a = -slope, b = 0, c = 1, d = slope*x_ref - z_ref
    Normalize: divide all by sqrt(a^2 + c^2) so that c > 0

    Ceiling: same slope direction but normal flipped
    Raw coefficients: a = slope, b = 0, c = -1, d = -slope*x_ref + z_ref
    Normalize: divide all by sqrt(a^2 + c^2) so that c < 0

The "G" shape in the FLAT10 room demonstrates this technique:
- 4 horizontal column sub-sectors (64x64 rectangles at Y=320-384)
- 8 sloped control sectors creating tilted 3D floors at various Z heights
- Multiple tags per sub-sector (via moreids) stack several sloped slabs
  within the same column, creating the illusion of a curved vertical shape

This is the building block for a vertical spiral: the spiral shape is
defined in the XZ plane, sub-sectors are horizontal X-columns, and slopes
in X create the vertical movement.


7. CONTAINING SECTOR PATTERN
==============================

When embedding generated geometry (like a spiral) inside an existing room:

- The room is the "containing sector" (e.g., sector 0 for the box room)
- Every boundary linedef of the generated geometry must be two-sided
- One side faces the generated sector, the other faces the containing sector
- Floor/ceiling heights of generated sectors MUST match the containing
  sector, otherwise visible walls appear at boundaries
- The visual distinction comes from either:
  a) Different floor/ceiling textures (for flat spirals)
  b) 3D floors (for floating spirals) - the base sector matches the room,
     the 3D floor creates the raised platform

The current generator creates the containing box room as part of its
output, so the TEXTMAP is fully self-contained.


8. BOX ROOM GENERATION
========================

The generator creates a simple rectangular room first:

    4 vertices at corners: (-half, -half), (-half, +half), 
                           (+half, +half), (+half, -half)
    4 one-sided linedefs forming the walls (clockwise winding)
    4 sidedefs with texturemiddle for wall texture
    1 sector with floor/ceiling heights and textures

The box auto-expands if the spiral's outer radius exceeds the default
half-width (1024). Expansion rounds up to the nearest 64-unit grid
boundary with 64 units of padding.


9. INDEX MANAGEMENT
====================

TEXTMAP indices are global per element type. The generator tracks:
    vi    = next vertex index
    li    = next linedef index  
    si    = next sidedef index
    sec_i = next sector index

The box consumes: vertices 0-3, linedefs 0-3, sidedefs 0-3, sector 0.
The spiral starts at: vertices 4+, linedefs 4+, sidedefs 4+, sectors 1+.
The control sector comes last.

When appending to an existing TEXTMAP instead of generating standalone,
all start indices must be set to one past the maximum existing index.


10. VALIDATION AND CONSTRAINTS
================================

The generator validates:
- b > 0 (growth rate must be positive)
- number_of_loops >= 1
- thickness > 0
- segments_per_loop >= 8
- arm_gap = 2*pi*b - thickness > 0 (arms must not overlap)
- 3D floor Z range: floor3d_z_bottom < floor3d_z_top <= box_height
- Room bounds: warns if spiral outer radius exceeds box


11. FILE STRUCTURE IN THE CODEBASE
====================================

Key files:

    code_generators/
        gen_archimedean_spiral.py   - Main spiral generator (standalone TEXTMAP)

    wad_internals/
        TEXTMAP_2048x2048x1024_box.txt   - Reference box room
        TEXTMAP_demo_3d_G_shape.txt      - Reference map with G shape and spiral
        TEXTMAP_ground_spiral.txt        - Earlier Sonnet-generated spiral
        spiral_fragment_v2.txt           - Fragment for insertion into existing maps

The gen_archimedean_spiral.py produces a complete TEXTMAP (namespace
declaration, box room, spiral sectors, control sector). Its output
replaces the entire TEXTMAP lump.


12. REFERENCE: EXISTING SPIRAL ANALYSIS
=========================================

The hand-built reference spiral (in TEXTMAP_ground_spiral.txt, DEM1_5 room):

    Center: (0, -768)
    Growth: b ≈ 20 map units per radian (r = b*theta + offset)
    Thickness: 60 map units
    Segments per loop: 48 (7.5 degrees each)
    Loops: ~6 (sectors 16-159, 144 total)
    Containing sector: 15 (DEM1_5 room, floor=0, ceiling=128)

    Vertex layout:
        Outer edge: vertices 37-181 (one per angular step)
        Inner edge: vertices 182-326 (one per angular step)
    
    Each sector has exactly 4 vertices forming a quad:
        outer[i], outer[i+1], inner[i+1], inner[i]

    Verified vertex positions (relative to center):
        v37:  r=80.0,  theta=0.0 degrees     (outer, theta=0)
        v182: r=20.0,  theta=0.0 degrees     (inner, theta=0)
        v49:  r=111.7, theta=90.0 degrees    (outer, theta=pi/2)
        v61:  r=143.3, theta=180.0 degrees   (outer, theta=pi)

    This matches: r_out = b*theta + thickness, r_in = b*theta
    with b ≈ 2.639 per 7.5 degrees ≈ 20.16 per radian, thickness ≈ 60


13. REFERENCE: G SHAPE (SLOPED 3D FLOORS)
===========================================

The floating "G" shape in the FLAT10 room demonstrates vertical 3D
floor construction without any horizontal spiral:

    Room: sector 176 (FLAT10 floor), bounds X: -2304 to -1792, Y: 0-640
    
    4 column sub-sectors arranged in a horizontal strip:
        Sector 178: X=[-2048,-1984], Y=[320,384], tags 5,6,7
        Sector 179: X=[-1984,-1920], Y=[320,384], tags 8,9
        Sector 180: X=[-2176,-2112], Y=[320,384], tag 16
        Sector 181: X=[-2112,-2048], Y=[320,384], tags 15,14

    8 control sectors (182-189) with slopes, creating the G shape:
        ctrl_182 -> tag 5  -> sector 178: Z=[64,128],   slope -0.5 in X
        ctrl_183 -> tag 6  -> sector 178: Z=[192,256],  slope -0.5 in X (ceil only)
        ctrl_184 -> tag 7  -> sector 178: Z=[320,384],  slope -0.5 in X
        ctrl_185 -> tag 8  -> sector 179: Z=[96,224],   slope -0.5 in X
        ctrl_186 -> tag 9  -> sector 179: Z=[288,352],  slope +0.5 in X
        ctrl_187 -> tag 14 -> sector 181: Z=[96,160],   slope +0.5 in X
        ctrl_188 -> tag 15 -> sector 181: Z=[288,352],  slope -0.5 in X
        ctrl_189 -> tag 16 -> sector 180: Z=[128,320],  slope 1.0 in X

    The slope magnitude 0.5 corresponds to:
        floorplane_a = ±0.447213595499958 (which is ±1/sqrt(5))
        floorplane_c =  0.894427190999916 (which is  2/sqrt(5))
        These are the normalised coefficients for slope = 0.5

    The technique: each sub-sector receives multiple 3D floors via
    stacked tags. The slopes tilt each slab to approximate curves.
    The Y dimension is just the tube's depth (not part of the shape).


14. COMMON PITFALLS
=====================

Mistakes that cause broken rendering:

1. Reversed sidedness: If sidefront/sideback are swapped, the sector
   won't render or will show HOM. Always verify against the winding
   convention (right side = front when facing v1->v2).

2. Mismatched floor/ceiling heights: If the spiral sectors have different
   heights than the containing room, visible walls/steps appear at every
   boundary edge. The spiral sectors must match the room exactly; use
   3D floors for visual height differences.

3. Overlapping sub-sectors: If spiral arms overlap in XY (arm_gap < 0),
   or if multiple sectors claim the same space, the BSP tree breaks.

4. Missing sideback on two-sided lines: Forgetting sideback or twosided
   causes the engine to treat the line as one-sided (a wall).

5. Wrong tag in control sector linedef: If arg0 doesn't match any
   sector's id, the 3D floor doesn't appear.

6. Control sector inside the map: The control sector must be placed
   off-map. If it's inside the playable area, players can enter it
   and it renders as a normal room.

7. Slope plane normal direction: Floor planes must have c > 0 (normal
   pointing up). Ceiling planes must have c < 0 (normal pointing down).
   Getting this wrong inverts the surface.


15. EXTENDING THE GENERATORS
==============================

To add a new architectural generator:

1. Start with the box room pattern (vertices 0-3, linedefs 0-3, etc.)
2. Track index counters (vi, li, si, sec_i) globally
3. Generate geometry vertices using parametric equations
4. Create sectors with matching floor/ceiling to the containing room
5. Create two-sided linedefs using the emit_twosided helper pattern
6. Add 3D floor control sector if the shape should float
7. Validate parameters (overlap, bounds, Z ranges)
8. Output as a complete TEXTMAP with namespace declaration

The architecture is designed so that multiple generators could be
composed: generate a box, then a spiral, then add things (player
starts, items, monsters), all tracking shared index counters.
