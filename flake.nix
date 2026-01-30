{
  description = "Proxy server to use Antigravity's Claude models with Claude Code CLI";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/70801e06d9730c4f1704fbd3bbf5b8e11c03a2a7";
    systems.url = "github:nix-systems/default";
  };

  nixConfig = {
    extra-substituters = [
      "https://aarch64-darwin.cachix.org"
    ];
    extra-trusted-public-keys = [
      "aarch64-darwin.cachix.org-1:mEz8A1jcJveehs/ZbZUEjXZ65Aukk9bg2kmb0zL9XDA="
    ];
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (let
      systems = import inputs.systems;
      packageJson = builtins.fromJSON (builtins.readFile ./package.json);
    in {
      inherit systems;
      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs
            node-gyp
          ];
        };

        packages.default = pkgs.buildNpmPackage {
          pname = packageJson.name;
          inherit (packageJson) version;

          src = ./.;

          npmDepsHash = "sha256-uG54p0YSdLiNV8uuQXLzaBk7JDxjv9zFborlTqUIiKg=";

          # Required for better-sqlite3 native module compilation
          nativeBuildInputs = with pkgs; [
            python3
            node-gyp
          ];

          # Include devDependencies for tailwind CSS build during prepare
          npmFlags = ["--include=dev"];

          # Build CSS during npm install (via prepare script)
          dontNpmBuild = true;

          meta = with pkgs.lib; {
            description = "Proxy server to use Antigravity's Claude models with Claude Code CLI";
            homepage = "https://github.com/badri-s2001/antigravity-claude-proxy";
            license = licenses.mit;
            mainProgram = "antigravity-claude-proxy";
          };
        };
      };
    });
}
