# gbjam

Repo is organized into `art/` for aseprite project files and `godot/` for the Godot project itself. Import the `godot/` directory in Godot 4 to begin working on the game.

The initial project consists of a few elements already to get us started:

- An animated 2D player sprite with WASD movement
- A simple tilemap (of 1 tile) to add some background
- A fixed SubViewport to render the game within a GameBoy aspect ratio
  - The viewport is set to the required GB screensize of 160x144 pixels, 
  - but scaled up in the engine for better playability, 
  - and kept centered in the window
