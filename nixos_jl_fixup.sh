#!/usr/bin/env nix-shell
#! nix-shell -i bash -p patchelf parallel

# Based on scripts by cstich, et. al.
# Fixes up Julia Artifacts on NixOS
# Discussion: https://discourse.julialang.org/t/build-julia-on-nixos/35129/21

PKG_DIR=~/.julia/

patchelf_job() {
  ARTIFACT=$1
  ORIGINAL_PERMISSIONS=$(stat -c "%a" $ARTIFACT)
  chmod +w $ARTIFACT
  patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $ARTIFACT
  chmod $ORIGINAL_PERMISSIONS $ARTIFACT
}

export -f patchelf_job

echo "Patching..."
find ~/src/julia/usr/* $PKG_DIR/artifacts/*/bin $PKG_DIR/juliaup/*  /home/sjkelly/.platformio/packages/*/bin/ -type f | parallel patchelf_job {} > /dev/null 2>&1
