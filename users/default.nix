{ config, pkgs, lib, home-manager, ... }:
let
  laptop-users = import ./const/users-list.nix;
in
{
  imports = [ 
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users = import ./home-gen.nix { inherit config pkgs lib home-manager; };
    }
  ];
  users.mutableUsers = false;

  users.users = lib.attrsets.concatMapAttrs
    (name: value: { 
      ${name} = {
        isNormalUser = true;
        description = value.fullName;
        extraGroups = [ "networkmanager" "wheel" ];
        hashedPassword = value.passphraseHash;
        # remove this once home-manager module is written
        # packages = with pkgs; [
          # firefox
          # kate
        # ];
      };
    })
    laptop-users;
}
