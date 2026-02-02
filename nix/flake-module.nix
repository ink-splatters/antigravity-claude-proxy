{lib, ...}: {
  perSystem = {
    config,
    inputs',
    ...
  }: let
    inherit (inputs'.bun2nix.packages) bun2nix;

    inherit (config) src;
    packageJson = builtins.fromJSON (builtins.readFile "${src}/package.json");
  in {
    packages.antigravity-claude-proxy = bun2nix.mkDerivation {
      pname = packageJson.name;
      inherit (packageJson) version;

      inherit src;

      bunDeps = bun2nix.fetchBunDeps {
        bunNix = "${src}/bun.nix";
      };

      module = "${src}/bin/cli.js";

      meta = with lib; {
        description = "Proxy server to use Antigravity's Claude models with Claude Code CLI";
        homepage = "https://github.com/badri-s2001/antigravity-claude-proxy";
        license = licenses.mit;
        mainProgram = "antigravity-claude-proxy";
      };
    };
  };
}
