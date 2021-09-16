#!/usr/bin/env nix-shell
#! nix-shell -i bash -p patchelf

# Based on scripts by cstich, et. al.
# Fixes up Julia Artifacts on NixOS
# Discussion: https://discourse.julialang.org/t/build-julia-on-nixos/35129/21

PKG_DIR=~/.julia/

for ARTIFACT in $(find $PKG_DIR/artifacts/*/bin) 
do
  chmod +w $ARTIFACT
  patchelf \
    $ARTIFACT \
    --set-interpreter \
    "$(cat $NIX_CC/nix-support/dynamic-linker)"
  chmod -w $ARTIFACT
done
