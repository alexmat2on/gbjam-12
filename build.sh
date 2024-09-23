#!/usr/bin/env bash

cwd=$(pwd)
mkdir -p "$cwd/builds/web"
rm -rf "$cwd/builds/web/*"

godot4 --headless --path ./godot --export-release Web "$cwd/builds/web/index.html"

zip -r "$cwd/builds/sauteslay-web.zip" "$cwd/builds/web"
