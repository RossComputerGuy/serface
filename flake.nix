{
  description = "A simple tablet UI for my sister.";

  nixConfig = rec {
    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
    substituters = [ "https://cache.nixos.org" "https://cache.garnix.io" ];
    trusted-substituters = substituters;
    fallback = true;
    http2 = false;
  };

  inputs.expidus-sdk = {
    url = github:ExpidusOS/sdk;
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nixpkgs.url = github:ExpidusOS/nixpkgs;

  outputs = { self, expidus-sdk, nixpkgs }:
    with expidus-sdk.lib;
    flake-utils.eachSystem flake-utils.allSystems (system:
      let
        pkgs = expidus-sdk.legacyPackages.${system};
      in {
        packages.default = pkgs.flutter.buildFlutterApplication {
          pname = "serface";
          version = "1.0.0+git-${self.shortRev or "dirty"}";

          src = cleanSource self;

          depsListFile = ./deps.json;
          vendorHash = "sha256-IepOeCUzFbu+AVrov107vxmyNyGcOQhN6TJqIxJf6Bk=";

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          meta = {
            description = "A simple tablet UI for my sister.";
            license = licenses.gpl3;
            maintainers = with maintainers; [ RossComputerGuy ];
            platforms = [ "x86_64-linux" "aarch64-linux" ];
          };
        };

        legacyPackages = pkgs.appendOverlays [
          (_: _: {
            serface = self.packages.${system}.default;
          })
        ];

        devShells.default = pkgs.mkShell {
          name = "serface";

          packages = with pkgs; [
            flutter
          ];
        };
      });
}
