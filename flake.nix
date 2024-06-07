{
  outputs = { self, nixpkgs, flake-utils, home-manager }: with flake-utils.lib; (
    eachSystem [ system.x86_64-linux system.aarch64-linux ] (system: {

      nixosConfigurations = let
        hostnames = [ "ASG-NTSST1-L13" "ASG-NTSST2-L13" "student-test-vm" ];
        forEach = nixpkgs.lib.lists.forEach;

        standard-config = host: ({
          specialArgs = rec {
            pkgs = import nixpkgs {
              system = system;
              config.allowUnfree = true;
            };
          };
          modules = [ "./hosts/${host}" ];
        });
      in 
        builtins.listToAttrs (forEach hostnames (host:
          { 
            name = host;
            value = nixpkgs.lib.nixosSystem (standard-config host);
          }
        ));
    })
  );
}
