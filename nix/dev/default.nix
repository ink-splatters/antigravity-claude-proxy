{inputs, ...}: {
  imports = [
    inputs.git-hooks.flakeModule
    ./pre-commit.nix
    ./shell.nix
  ];
}
