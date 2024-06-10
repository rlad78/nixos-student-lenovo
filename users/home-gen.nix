{ config, pkgs, home-manager, ... }:
let
  laptop-users = import ./const/users-list.nix;
in
homelib.attrsets.concatMapAttrs (username: values: {
  ${username} = {
    home.username = username;
    home.homeDirectory = "/home/${username}";

    home.packages = with pkgs; [
      firefox
      chromium
      kate
    ]

    home.stateVersion = "24.11";
    programs.home-manager.enable = true;
  };
}) laptop-users;
