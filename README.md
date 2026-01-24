# ZD DaF

ZDoom maps for the **DaF (Daft and Furious)** D&D campaign. Intended as a VTT (Virtual Table Top) for the sessions themselves, but maybe later some FPS gameplay inspired by the sessions.

## Installation

### Prerequisites

- [Git LFS (Large File Storage)](https://git-lfs.com/), for pulling down models and other large files
- [GZDoom](https://zdoom.org/downloads)
- [UDB (Ultimate Doom Builder)](https://ultimatedoombuilder.github.io/) for using the maps as a VTT
- (OPTIONAL) [SLADE](https://slade.mancubus.net/), edit the project's scripts, defs, lumps etc

### Cloning and Models

1. `git clone https://github.com/tommarkallen/zd_daf.git`
2. `git lfs install`
3. `git lfs pull`

## Usage

### As an FPS

1. Drag `zd_daf` sub-folder over `gzdoom.exe`

### As a VTT

1. Open UDB (Ultimate Doom Builder)
2. Open a .wad under `zd_daf/maps/`
3. Add Resource > From Directory > Select `zd_daf` sub-folder

### Project Structure
- `zd_daf/`: Add this as resource from directory, or Archive into pk3 with SLADE
  - `MAPINFO`: Map definitions.
  - `MODELDEF`: Model configurations.
  - `zscript.zs`: ZScript for custom actors.
  - `actors/`: Actor definitions (e.g., plants).
  - `maps/`: WAD files for levels.
  - `models/`: 3D models, definitions and skins.
  - `music/`: Atmospheric mp3s
- `backups/`: Backups of experiments etc
- `lumps_in_wads/`: Extracted WAD contents.

## Contributing

Not yet, though suggestions are welcome.

## License

Default for now.

## Authors

- Zeverin
