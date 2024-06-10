{
  outputs = { self, nixpkgs, home-manager }:
  let
    laptop-hostnames = [ "ASG-NTSST1-L13" "ASG-NTSST2-L13" ];
    forEach = nixpkgs.lib.lists.forEach;

    laptop-config = host: ({
      specialArgs = {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        inherit home-manager;
      };
      modules = [ ( ./. + "/hosts/${host}" ) ];
    });
  in
  {
    nixosConfigurations = {
      "student-test-vm" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          pkgs = import nixpkgs {
            system = "aarch64-linux";
            config.allowUnfree = true;
          };
          inherit home-manager;
        };
        modules = [ ( ./. + "/hosts/student-test-vm" ) ];
      };
    } // builtins.listToAttrs (forEach laptop-hostnames (host:
      {
        name = host;
        value = nixpkgs.lib.nixosSystem (laptop-config host);
      }
    ));
  };
}
