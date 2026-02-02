{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    pre-commit = {
      check.enable = true;

      settings.hooks = {
        # TODO: prettier

        # Markdown
        # TODO: needs proper tuning
        # markdownlint = {
        #   enable = true;
        #   settings.configuration = {
        #     MD013 = false; # Disable line length
        #     MD033 = false; # Allow inline HTML
        #     MD040 = false; # Don't require language for code blocks
        #   };
        # };

        # Spell checking
        # too many false positives
        # typos.enable = true;

        # Nix hooks
        deadnix = {
          enable = true;
          # TODO: make it actually work
          # settings = {
          #   exclude = ["bun.nix"];
          # };
        };

        nil.enable = true;
        alejandra.enable = true;
        statix.enable = true;
      };
    };

    apps.install-hooks = {
      type = "app";
      program = toString (pkgs.writeShellScript "install-hooks" ''
        ${config.pre-commit.installationScript}
        echo "Pre-commit hooks installed!"
      '');
      meta.description = "install pre-commit hooks";
    };
  };
}
