{
  description = "Darkflake: + Repos Extras + Home Manager + NUR + MCP-NixOS + CachyOS Kernel + Garuda Dev Automation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    flake-parts.url = "github:hercules-ci/flake-parts";
    kartoza-plymouth-theme.url = "github:timlinux/kartoza-plymouth-theme";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    mcp-nixos.url = "github:utensils/mcp-nixos";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    guixpkgs.url = "github:fzakaria/guixpkgs";
    nixsecauditor.url = "github:unnamed-systems/nixsecauditor";
    lazyvim.url = "github:pfassina/lazyvim-nix";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen = {
      url = "github:InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    denix = {
      url = "github:yunfachi/denix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixowos.url = "github:yunfachi/nixowos";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nix-index-db.url = "github:nix-community/nix-index-database";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    preservation.url = "github:nix-community/preservation";
    nil.url = "github:oxalica/nil";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs@{ flake-parts, nixpkgs, nixpkgs-unstable, mcp-nixos, nix-cachyos-kernel, self, nixsecauditor, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      
      systems = [ "x86_64-linux" ];

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem = { system, pkgs, ... }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        _module.args.unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };       
        packages.pythowo = pkgs.callPackage ./pythowo.nix {};
        devShells.default = 
          let
            makeDevshell = import "${inputs.devshell}/modules" pkgs;
            mkShell = config: (makeDevshell {
              configuration = {
                inherit config;
                imports = [ ];
              };
            }).shell;
          in
          mkShell {
            devshell = {
              name = "Darkflake-DevShell";
              startup = {
                infra-nix-shell.text = ''
                  export LC_ALL="C.UTF-8"
                  export NIX_PATH=nixpkgs=${nixpkgs}
                '';
                pre-commit-hooks.text = self.checks.${system}.pre-commit-check.shellHook;
              };
            };
            commands = [
              { package = pkgs.deadnix; } 
              { package = pkgs.statix; }   
              { package = pkgs.ripsecrets; } 
              { package = self.packages.${system}.pythowo; }
            ];
            motd = ''
              {202}🔨 Bem-vindo ao Shell de Desenvolvimento Darkflake ❄️
            '';
          };

        checks.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          package = pkgs.pre-commit; 
          hooks = {
            check-json.enable = true;
            detect-private-keys.enable = true; 
            check-yaml.enable = true;
            ripsecrets.enable = true;          
          };
          src = ./.;
        };

        treefmt = {
          build.check = true;
          programs = {
            deadnix.enable = true;
            nixfmt-rfc-style.enable = true; 
            statix.enable = true;
          };
        };
      }; 

      flake = {
        nixosConfigurations."Darkflake" = nixpkgs.lib.nixosSystem {

          specialArgs = {
            inherit inputs;
            unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
            guixpkgs = inputs.guixpkgs.packages."x86_64-linux";
          };
          
          modules = [
            { 
              nixpkgs.hostPlatform = "x86_64-linux";
              nixpkgs.buildPlatform = "x86_64-linux";
            }
            ./configuration.nix
            
            inputs.chaotic.nixosModules.default
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.nixowos.nixosModules.default
            inputs.sops-nix.nixosModules.sops 
            inputs.nur.modules.nixos.default
            inputs.nixos-hardware.nixosModules.common-cpu-intel
            inputs.nix-index-db.nixosModules.nix-index
            inputs.nixsecauditor.nixosModules.default
            inputs.preservation.nixosModules.preservation
            inputs.disko.nixosModules.disko
            ./system/persistence.nix
            {
              nixpkgs.overlays = [ 
                mcp-nixos.overlays.default 
                nix-cachyos-kernel.overlays.pinned 
                inputs.affinity-nix.overlays.default
              ];
            }

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.backupFileExtension = "backup";
              home-manager.useUserPackages = true;
              
              home-manager.extraSpecialArgs = { 
                inherit inputs;
                unstable = import nixpkgs-unstable {
                  system = "x86_64-linux";
                  config.allowUnfree = true;
                };
                guixpkgs = inputs.guixpkgs.packages."x86_64-linux";
              };
              
              home-manager.users.davi = import ./applications/home/davi/home.nix;
              home-manager.users.guest = import ./applications/home/guest/home.nix;

              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
                inputs.chaotic.homeManagerModules.default
                inputs.lazyvim.homeManagerModules.default
              ];
            }
          ];
        };
      };
    };
}
