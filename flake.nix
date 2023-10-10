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

        arch = with pkgs; if targetPlatform.isx86_64 then "x64"
          else "${targetPlatform.parsed.cpu.family}${toString targetPlatform.parsed.cpu.bits}";

        mimalloc = pkgs.fetchurl {
          url = "https://github.com/microsoft/mimalloc/archive/refs/tags/v2.1.2.tar.gz";
          hash = "sha256-Kxv/b3F/lyXHC/jXnkeG2hPeiicAWeS6C90mKue+Rus=";
        };

        westonConfig = pkgs.writers.writeText "weston.ini" (generators.toINI {} {
          shell = {
            type = "kiosk-shell.so";
          };

          launcher = [
            {
              displayname = "Terminal";
              path = "${pkgs.weston}/bin/weston-terminal";
            }
            {
              displayname = "Network Manager";
              path = "${pkgs.weston}/bin/weston-terminal --shell=${pkgs.networkmanager}/bin/nmtui";
            }
            {
              displayname = "Bluetooth Manager";
              path = "${pkgs.blueman}/bin/blueman-manager";
            }
            {
              displayname = "Serface";
              path = "${self.packages.${system}.default}/bin/serface";
            }
          ];

          input-method = {
            path = "${pkgs.weston}/libexec/weston-keyboard";
          };
        });
      in rec {
        packages.default = pkgs.flutter.buildFlutterApplication {
          pname = "serface";
          version = "1.0.0+git-${self.shortRev or "dirty"}";

          src = cleanSource self;

          depsListFile = ./deps.json;
          vendorHash = "sha256-B5eKWy3eF3ewrTuK0nmOwDo3GnFm4e1oPW6RRPL1l+4=";

          nativeBuildInputs = with pkgs; [
            pkg-config
            gnumake
          ];

          buildInputs = with pkgs; [
            mpv
            libdvdnav
            libdvdread
            libass
            ffmpeg
            libglvnd
            wayland
          ];

          preBuild = ''
            mkdir -p $NIX_BUILD_TOP/source/build/linux/${arch}/release
            cp ${mimalloc} $NIX_BUILD_TOP/source/build/linux/${arch}/release/mimalloc-2.1.2.tar.gz
          '';

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

        expidusConfigurations.default = expidus-sdk.lib.expidusSystem {
          inherit pkgs;

          modules = [
            {
              disabledModules = [
                "${expidus-sdk}/variants/mainline/modules/system/config.nix"
              ];

              fileSystems = {
                "/" = {
                  device = "/dev/disk/by-label/EXPIDUS_ROOT";
                };
                "/data" = {
                  device = "/dev/disk/by-label/EXPIDUS_DATA";
                  neededForBoot = true;
                };
              };

              system.rootfs.options = [ "-L EXPIDUS_ROOT" ];
              system.datafs.options = [ "-L EXPIDUS_DATA" ];

              environment.systemPackages = [
                packages.default
              ];

              fonts = {
                fontDir.enable = true;
                enableDefaultPackages = true;
              };

              boot = {
                initrd = rec {
                  availableKernelModules = [ "virtio_pci" "virtio_blk" "virtio_scsi" "nvme" "ahci" ];
                  kernelModules = availableKernelModules;
                };
                plymouth.enable = true;
                kernelParams = [ "root=/dev/vdb" "console=ttyS0,9600" ];
              };

              users.users.serface = {
                password = "serface";
                isNormalUser = true;
                home = "/home/expidus";
                description = "Serface Tablet";
                group = "wheel";
                extraGroups = [ "video" "input" "tty" "users" "systemd-journal" ];
              };

              hardware.opengl.enable = true;

              xdg = {
                autostart.enable = true;
                portal = {
                  enable = true;
                  xdgOpenUsePortal = true;
                  wlr.enable = true;
                };
              };

              networking = {
                networkmanager.enable = true;
                useDHCP = false;
                useNetworkd = false;
              };

              services.acpid.enable = true;
              services.xserver.enable = true;
              services.accounts-daemon.enable = true;
              services.upower.enable = true;
              security.polkit.enable = true;

              security.apparmor.enable = true;
              services.dbus.apparmor = "enabled";
              services.getty.autologinUser = "serface";

              services.xserver.displayManager.job.execCmd = ''
                export PATH=${pkgs.weston}/bin:$PATH
                exec weston --config ${westonConfig}
              '';

              systemd.services.display-manager = {
                enable = true;

                onFailure = [
                  "getty@tty1.service"
                ];

                conflicts = [
                  "getty@tty1.service"
                ];

                before = [
                  "graphical.target"
                ];

                after = [
                  "getty@tty1.service"
                  "rc-local.service"
                  "plymouth-quit-wait.service"
                  "systemd-user-sessions.service"
                ];

                wants = [
                  "upower.service"
                  "accounts-daemon.service"
                ];

                unitConfig = {
                  ConditionPathExists = "/dev/tty0";
                };

                serviceConfig = {
                  User = "serface";
                  PAMName = "login";

                  TTYPath = "/dev/tty1";
                  TTYReset = "yes";
                  TTYVHangup = "yes";
                  TTYVTDisallocate = "yes";

                  UtmpIdentifier = "tty1";
                  UtmpMode = "user";
                };
              };
            }
          ];
        };

        devShells.default = pkgs.mkShell {
          name = "serface";

          packages = with pkgs; [
            flutter
            pkg-config
          ] ++ packages.default.buildInputs;
        };
      });
}
