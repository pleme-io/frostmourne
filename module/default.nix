# frostmourne :: home-manager module
#
# Install frostmourne, the curated Lisp-authored frost distribution.
# When `enable` is true, this module:
#
#   * adds the `frostmourne` binary to `home.packages`
#   * points `$FROSTRC` at the bundled rc so every frost invocation
#     picks up the curated config
#   * optionally sets frostmourne as the user's default interactive
#     shell (opt-in; requires `chsh` on Darwin, which the user must
#     do once outside Nix)
{ config, lib, pkgs, ... }:

let
  cfg = config.programs.frostmourne;
in {
  options.programs.frostmourne = {
    enable = lib.mkEnableOption "frostmourne — curated frost distribution";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.frostmourne;
      defaultText = lib.literalExpression "pkgs.frostmourne";
      description = "The frostmourne package to install.";
    };

    setAsInteractiveShell = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Export `SHELL` pointing at the frostmourne wrapper so child
        processes and terminals that respect `$SHELL` will pick it
        up. Does NOT run `chsh` — setting the login shell on macOS
        requires adding `/etc/profiles/per-user/.../bin/frostmourne`
        to `/etc/shells` and calling `chsh -s`, which is outside
        Nix's purview.
      '';
    };

    localLisp = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = lib.literalExpression ''
        '''
          (defalias :name "ssh-rio" :value "ssh me@rio.internal")
          (defalias :name "ssh-edge" :value "ssh 10.0.0.5")
        '''
      '';
      description = ''
        Per-machine, PRIVATE frost-lisp config materialized at
        `$XDG_CONFIG_HOME/frostmourne/local.lisp` and `(defsource
        :optional)`d LAST by the bundled rc (so it overrides defaults on
        collision). This is where user-specific data lives — ssh-host
        aliases (per-host users / internal hostnames), machine-local
        shortcuts — that must NOT ship in the public frostmourne tree.
        Typically generated from the fleet registry in the private nix
        repo. When empty, no file is written and the rc's optional
        defsource simply skips it.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # Materialize the private per-machine overlay the bundled rc
    # optionally sources (lisp/90-local.lisp → `$XDG_CONFIG_HOME/
    # frostmourne/local.lisp`). Only written when non-empty; on hosts
    # that don't set it, the rc's `defsource :optional` skips the file.
    xdg.configFile = lib.mkIf (cfg.localLisp != "") {
      "frostmourne/local.lisp".text = cfg.localLisp;
    };

    # Ensure `$FROSTRC` is resolvable for every interactive shell,
    # including when other shells exec into frost. The wrapper sets it
    # too, but having it in the user environment keeps it consistent
    # when frost is invoked directly (`frost` rather than `frostmourne`).
    home.sessionVariables = {
      FROSTRC = "${cfg.package}/share/frostmourne/rc.lisp";
    } // lib.optionalAttrs cfg.setAsInteractiveShell {
      SHELL = "${cfg.package}/bin/frostmourne";
    };
  };
}
