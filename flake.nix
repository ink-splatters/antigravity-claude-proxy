{
  description = "Proxy server to use Antigravity's Claude models with Claude Code CLI";

  inputs = {
    bun2nix = {
      url = "github:nix-community/bun2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # we pinned nixpkgs before recent breakage which is not fixed yet
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  nixConfig = {
    extra-substituters = [
      "https://aarch64-darwin.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "aarch64-darwin.cachix.org-1:mEz8A1jcJveehs/ZbZUEjXZ65Aukk9bg2kmb0zL9XDA="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} ({lib, ...}: let
      systems = import inputs.systems;
      flakeModules.default = import ./nix/flake-module.nix;
    in {
      imports = [
        flakeModules.default
        flake-parts.flakeModules.partitions
      ];

      inherit systems;

      partitionedAttrs = {
        apps = "dev";
        checks = "dev";
        devShells = "dev";
        formatter = "dev";
      };
      partitions.dev = {
        # directory containing inputs-only flake.nix
        extraInputsFlake = ./nix/dev;
        module = {
          imports = [./nix/dev];
        };
      };
      # this won't be exported
      perSystem = {
        config,
        pkgs,
        ...
      }: {
        options.src = lib.mkOption {
          default = builtins.path {
            path = ./.;
            name = "antigravity-claude-proxy";
          };
        };
        config = {
          packages.default = config.packages.antigravity-claude-proxy;
          formatter = pkgs.alejandra;
        };
      };

      flake = {
        inherit flakeModules;
      };
    });
}
