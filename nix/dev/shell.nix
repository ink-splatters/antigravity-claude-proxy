{
  perSystem = {
    config,
    inputs',
    pkgs,
    ...
  }: let
    inherit (config) pre-commit;
    inherit (inputs'.bun2nix.packages) bun2nix;
  in {
    devShells.default = pkgs.mkShell {
      packages =
        pre-commit.settings.enabledPackages
        ++ [
          pkgs.bun
          bun2nix
        ];

      shellHook = ''
        ${pre-commit.installationScript}
      '';
    };
  };
}
