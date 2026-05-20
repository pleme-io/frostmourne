# frostmourne :: NixOS module
#
# System-wide install + thin wrapper that delegates per-user config
# to the home-manager module via `home-manager.sharedModules`. Same
# operator surface as the HM module — operators who use the NixOS
# module get the binary on PATH for every user without needing to
# wire `programs.frostmourne.enable = true` in each HM config.
{ config, lib, pkgs, ... }:

let
  cfg = config.programs.frostmourne;
  hmModule = import ./default.nix;
in
{
  options.programs.frostmourne = {
    enable = lib.mkEnableOption "frostmourne — curated frost distribution (system-wide)";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.frostmourne;
      defaultText = lib.literalExpression "pkgs.frostmourne";
      description = "The frostmourne package to install system-wide.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    # Forward into every user's HM via the standard shared-modules
    # slot so per-user FROSTRC + interactive-shell wiring still
    # work. Consumers who use this module typically combine with
    # `programs.frostmourne.enable = true` in their HM block.
    home-manager.sharedModules = lib.mkAfter [ hmModule ];
  };
}
