{ config, lib, pkgs, ... }:
{ 
    users.allowNoPasswordLogin = true;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    networking.hostName = "nixos";
    system.stateVersion = "25.05";
}