CONTEXT: ZD_DAF Codebase Analysis — Goals, Gaps, and Imagined Extensions
==========================================================================

This document provides a full analysis of the ZD_DAF codebase as understood
by Claude Code, identifies knowledge gaps that need to be filled via doc/
documents, and lists both stated and imagined development goals.

Generated: 2026-03-05


1. WHAT THE PROJECT IS
=======================

ZD_DAF (Daft and Furious) is a GZDoom-based Virtual Table Top (VTT) and FPS
project for a D&D campaign. It combines:

  - Python procedural map generators (UDMF TEXTMAP text output)
  - GZDoom/UDB maps (5 campaign levels: Illithid Hive → Abyss layers)
  - Custom ZScript actors (D&D monsters, party characters, weapons, props)
  - 3D models + skins (67 MB, architectural and character)
  - Rich texture library (14+ packs: Giger, Gothic, Dark Souls, Egyptian, etc.)

Tech stack: Python 3 · GZDoom · UDB · SLADE · ZScript v4.14.2 · UDMF · Git LFS


2. WHAT THE CODE DOES
======================

2.1 code_generators/uzumaki.py
-------------------------------
The only current generator. Produces a complete, self-contained TEXTMAP file
for a floating Archimedean spiral embedded in a box room.

Algorithm:
  1. Validate parameters (arm gap, Z range, loop count)
  2. Auto-size box room (min 1024 half-width, expands to contain spiral + 64 padding)
  3. Generate inner/outer vertex rings: r = b*theta and r = b*theta + thickness
  4. Create one trapezoid sector per angular segment, all sharing floor3d_tag
  5. Wire two-sided linedefs with correct sidefront/sideback (reverse-engineered
     from a hand-built UDB spiral in TEXTMAP_ground_spiral.txt)
  6. Generate off-map 3D floor control sector (special=160, Sector_Set3dFloor)
  7. Write complete TEXTMAP text file

Current parameters: b=16, thickness=96, 4 loops, 24 segments/loop
Output: 202 vertices, 290 linedefs, 290 sidedefs, 99 sectors

2.2 wad_internals/ Reference TEXTMAPs
--------------------------------------
  TEXTMAP_uzumaki.txt           Current generator output
  TEXTMAP_ground_spiral.txt     Hand-built UDB reference (reverse-engineering source)
  TEXTMAP_demo_3d_G_shape.txt   Demonstrates sloped 3D floors (vertical G-shape)
  TEXTMAP_2048x2048x1024_box.txt  Minimal box room template
  TEXTMAP_floating_spiral.txt   Earlier spiral variant (156 KB)
  HIVE01.acs                    ACS script (music change on map entry only)

2.3 zd_daf/actors/ (ZScript, 31 files)
----------------------------------------
Custom D&D monsters and props. Notable:

  Illithids:  MindFlayer (990 HP, psychic blasts), MindFlayerArcanist,
              Alhoon, Ulitharid, IntellectDevourer, MindWitness
  Aquatic:    Sahuagin, SahuaginBaron, Grimlock
  Demons:     Succubus, PinkHorror, MotherImp
  Party:      Das, DasDog, Fiddler, Shtank
  Weapons:    Flashlight, ArcaneAxe
  Props:      GigerLights, Uzumaki, Anemone, ColumnAmpule

2.4 Campaign Maps (MAPINFO)
----------------------------
  HIVE01    Illithid Hive - Deep Sea Trench
  ABYSS222  222nd Abyss Layer - Shedaklah
  ABYSS045  45th Abyss Layer - Azzagrat
  ABYSS046  46th Abyss Layer - Zelatar
  ABYSS047  47th Abyss Layer - Argent Palace


3. YOUR 7 STATED GOALS — CURRENT STATE
========================================

Goal 1: Mathematically defined architecture generators
  STATUS: STRONG START — Archimedean spiral works end-to-end.
  NEXT: Logarithmic spiral, hexagonal/octagonal rooms, helical ramps,
        Voronoi corridors, parametric columns, fractal cave outlines.

Goal 2: Custom monsters from D&D (sprites, behaviour)
  STATUS: GOOD BASE — many custom ZScript actors already built.
  GAPS: Sprite conversion pipeline (spritesheet → Doom-format),
        AI state machine patterns, D&D stat → GZDoom stat conversion,
        DECORATE vs ZScript patterns for new monsters.

Goal 3: Custom models and things (aesthetically fitting)
  STATUS: PARTIAL — model infrastructure exists (MODELDEF, skins folder,
          existing models in project).
  GAPS: Blender → GZDoom export pipeline (glTF/MD3), UV unwrapping workflow,
        procedural Giger-aesthetic skin generation (Python + Pillow).

Goal 4: Textures that tile aesthetically at various viewing distances
  STATUS: NOT YET STARTED in code. Large library already imported.
  GAPS: GZDoom surface-type scale recommendations, procedural tiling
        analysis tools, viewing-distance testing methodology.

Goal 5: Organise flats/textures thematically for UDB painting
  STATUS: NOT YET STARTED. Multiple packs present, folder-organised by pack.
  GAPS: Theme-based namespace/prefix conventions, UDB texture browser
        organisation approach, wad vs pk3 organisation tradeoffs.

Goal 6: TEXTMAP test and triage scripts
  STATUS: NOT YET STARTED. Only uzumaki.py exists.
  OPPORTUNITY: A Python TEXTMAP parser to check:
    - Missing sidedefs on two-sided linedefs
    - Orphaned sectors (no sidedefs referencing them)
    - Tag mismatches (3D floor control tag not matched by any sector id)
    - Duplicate vertex positions
    - Unclosed sector boundaries
    - Out-of-range values

Goal 7: ACS and ZScript for dynamic behaviour
  STATUS: BASIC ACS EXISTS (HIVE01.acs changes music).
          Rich ZScript actor system exists.
  GAPS: Map-level scripting patterns for VTT (fog of war, encounter
        triggers, movement indicators, initiative tracking).


4. IMAGINED ADDITIONAL GOALS
==============================

These are natural extensions based on the codebase:

Goal 8: Procedural dungeon room generators
  Generators for corridors, T-junctions, chambers with pillar arrays, niches,
  archways. Composable with the spiral using shared index counters (vi, li,
  si, sec_i). A "compose" entry point that chains multiple generators and
  outputs one TEXTMAP.

Goal 9: Heightmap / terrain generator
  Convert a 2D greyscale image into GZDoom sector geometry — stepped terrain
  or sloped 3D floors. Useful for cave floors, underdark topography, alien
  biomass terrain.

Goal 10: VTT tooling in ZScript
  Fog-of-war sectors that toggle with player proximity, movement range
  indicators (circle of sectors that glow), initiative/turn-order HUD overlays,
  dice-roll announcements via actor messages or console text.

Goal 11: Encounter scripting system
  ACS/ZScript triggers for spawning monster waves at specific initiative
  counts, retreat/reinforcement logic, D&D encounter zone boundaries with
  enter/exit triggers, post-encounter reward spawning.

Goal 12: Texture atlas / catalog tool
  A script that scans flat/texture folders and generates an HTML gallery
  (thumbnails + names) or a UDB-compatible texture namespace file, so you
  can browse textures visually outside UDB.

Goal 13: Procedural skin generator
  Python + PIL/Pillow to generate Giger-aesthetic skins for models:
  biomechanical patterns, bony ridges, dark metallic gradients mapped to
  UV coordinates. Could also generate tiling wall/floor textures algorithmically.

Goal 14: MAPINFO / campaign tooling
  Scripts to validate MAPINFO (all referenced maps exist, music files exist,
  next-map chains are acyclic/valid), generate new campaign branch structures,
  and produce a human-readable campaign map diagram.

Goal 15: Automated TEXTMAP → WAD pipeline
  A Makefile or shell script that: runs all generators, replaces TEXTMAP
  lumps in WADs via SLADE CLI, runs GZDoom headlessly for a smoke test, and
  reports any load errors. Enables "make maps" as a full build step.


5. KNOWLEDGE GAPS — WHAT TO ADD TO doc/
=========================================

These are things Claude cannot determine from the codebase or internet alone.
Add these as doc/ files for the next iteration.

HIGH PRIORITY
--------------

doc/texture_inventory.md
  What texture and flat packs are imported, what they look like, naming
  conventions, which are most used. I can see folder names but not image
  content. Critical for Goal 5 (organisation) and Goal 4 (tiling).

doc/map_layouts.md
  What rooms, sectors, and actor placements currently exist in HIVE01 and
  the ABYSS maps. I cannot parse binary WAD files. Critical for Goal 1
  (where to embed new geometry) and Goal 7 (where to add scripts).

doc/monster_design_intent.md
  Design reasoning behind each custom actor — e.g. how MindFlayer AI should
  differ from Doom base AI, desired movement patterns, special abilities,
  D&D stat conversion methodology. Critical for Goal 2.

doc/model_inventory.md
  What 3D models exist in zd_daf/models/, their formats (glTF? MD3?),
  poly counts, what they visually look like. I cannot read binary model files.
  Critical for Goal 3.

doc/aesthetic_vision.md
  What "fits" the Giger/D&D aesthetic: preferred colour palettes, lighting
  moods per map, architectural motifs (organic, crystalline, biomechanical),
  texture/flat combinations that work well together. Subjective but important
  for Goals 3, 4, 13.

doc/gzdoom_version.md
  GZDoom version in use. Some ZScript/3D floor features are version-gated.
  No gzdoom.ini or version lock was found in the codebase.

MEDIUM PRIORITY
----------------

doc/sprite_conventions.md
  How custom sprites are named (Doom SPRITEFX format: 8-char + frame + angle),
  how directional frames are laid out in spritesheets, how to convert external
  art to Doom-format. I can see sprite folders but not the naming details or
  conversion workflow.

doc/dnd_monster_sources.md
  Which D&D source books or stat blocks are being adapted for which actors.
  Helps with stat conversion (HP, AC, speed, damage) and ability design.

LOW PRIORITY (researchable from internet)
------------------------------------------

  - ZScript language reference (zdoom.org wiki)
  - ACS scripting reference (zdoom.org wiki)
  - GZDoom UDMF extensions (zdoom.org wiki)
  - Doom sprite naming convention (well-documented)
  - Blender → GZDoom glTF/MD3 export workflow
  - DECORATE → ZScript migration guide


6. WHAT .claude/ IS
====================

The .claude/ directory is Claude Code's local configuration system:

  CLAUDE.md           Project-level instructions loaded automatically into
                      every conversation (persistent system prompt for the
                      project). Now created at c:\dev\zd_daf\CLAUDE.md.

  memory/MEMORY.md    Auto-memory: key facts Claude writes across sessions.
                      Loaded at the start of every conversation.

  memory/*.md         Topic-specific memory files (linked from MEMORY.md).

  plans/              Plan files written during plan mode (read-only except
                      during planning).

  keybindings.json    Custom keyboard shortcuts for the CLI.

CLAUDE.md is the most important one for this project. It has been created
with project conventions, tool paths, workflow, UDMF rules, and goals.
