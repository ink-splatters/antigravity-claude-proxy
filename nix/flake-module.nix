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
    packages.antigravity-claude-proxy = bun2nix.writeBunApplication {
      pname = packageJson.name;
      inherit (packageJson) version;

      inherit src;

      bunDeps = bun2nix.fetchBunDeps {
        bunNix = "${src}/bun.nix";
      };

      dontUseBunBuild = true;

      startScript = ''
        bun run bin/cli.js "$@"
      '';

      meta = with lib; {
        description = "Proxy server to use Antigravity's Claude models with Claude Code CLI";
        homepage = "https://github.com/badri-s2001/antigravity-claude-proxy";
        license = licenses.mit;
        mainProgram = "antigravity-claude-proxy";
      };
    };
  };
}
