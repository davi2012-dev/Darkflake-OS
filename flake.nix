{
  description = "Darkflake: + Repos Extras + Home Manager + NUR + MCP-NixOS + CachyOS Kernel";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    flake-parts.url = "github:hercules-ci/flake-parts";

    # Adicionando o MCP-NixOS nos inputs
    mcp-nixos.url = "github:utensils/mcp-nixos";

    # --- NOVO INPUT: CachyOS Kernel ---
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    # ----------------------------------

    home-manager = {
      url = "github:nix-community/home-manager";
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
    impermanence.url = "github:nix-community/impermanence";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nil.url = "github:oxalica/nil";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs@{ flake-parts, nixpkgs, nixpkgs-unstable, mcp-nixos, nix-cachyos-kernel, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      
      systems = [ "x86_64-linux" ];

      perSystem = { system, ... }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        _module.args.unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };       
      }; 

      flake = {
        nixosConfigurations."Darkflake" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          
          specialArgs = {
            inherit inputs;
            unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
          
          modules = [
            ./configuration.nix
            
            inputs.chaotic.nixosModules.default
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.nixowos.nixosModules.default
            inputs.sops-nix.nixosModules.sops 
            inputs.nur.modules.nixos.default
            inputs.impermanence.nixosModules.impermanence
            inputs.nixos-hardware.nixosModules.common-cpu-intel
            inputs.nix-index-db.nixosModules.nix-index
            
            # Modificado para incluir o overlay do CachyOS junto com o do MCP-NixOS
            {
              nixpkgs.overlays = [ 
                mcp-nixos.overlays.default 
                nix-cachyos-kernel.overlays.pinned 
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
              };
              
              home-manager.users.davi = import ./applications/home/home.nix;

              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
              ];
            }
          ];
        };
      };
    };
}
