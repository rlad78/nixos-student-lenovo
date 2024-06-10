{ config, pkgs, lib, home-manager, ... }:
let
  laptop-users = import ./users-list.nix;
in
lib.attrsets.concatMapAttrs (username: values: {
  ${username} = {
    home.username = username;
    home.homeDirectory = "/home/${username}";

    home.packages = with pkgs; [
      firefox
      chromium
      kate
    ];

    home.stateVersion = "24.11";
    programs.home-manager.enable = true;
  };
}) laptop-users
