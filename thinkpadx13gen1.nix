{ config, lib, pkgs, nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.lenovo-thinkpad-x13-amd
  ]; 
}