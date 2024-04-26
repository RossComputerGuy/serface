{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    flake-utils,
    ...
  }@inputs:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) lib;

        nodejs = pkgs.nodejs_21;

        overlay = f: s: {
          serface = s.buildNpmPackage {
            pname = "serface";
            version = "0-git+${self.shortRev or "dirty"}";

            src = lib.cleanSource self;

            inherit (s) nodejs_21;

            npmDepsHash = "sha256-PjgSthDLvI+By46rPNBT4gsXFP+l1z9SS2zZH8/WGD4=";

            meta = {
              mainProgram = "serve";
            };
          };
        };
      in {
        packages.default = self.legacyPackages.${system}.serface;

        legacyPackages = pkgs.appendOverlays [
          overlay
        ];

        devShells.default = pkgs.mkShell {
          inherit (self.packages.${system}.default) pname version name;
          packages = [ nodejs ];
        };
      })) // {
        nixosConfigurations = let
          mkQemu = system:
            let
              pkgs = self.legacyPackages.${system};
              inherit (nixpkgs) lib;
            in lib.nixosSystem {
              inherit system lib pkgs;

              modules = [
                "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
                ./nix/module.nix
                {
                  config = {
                    system.name = "qemu-${pkgs.targetPlatform.qemuArch}";
                    boot.kernelParams = lib.mkAfter [ "console=ttyS0" ];
                  };
                }
              ];
            };
        in {
          qemu-aarch64 = mkQemu "aarch64-linux";
          qemu-x86_64 = mkQemu "x86_64-linux";
        };
      };
}
