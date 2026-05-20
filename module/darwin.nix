# frostmourne :: nix-darwin module
#
# Darwin-side equivalent of the NixOS module — installs the
# frostmourne binary system-wide via `environment.systemPackages`
# + delegates per-user FROSTRC + shell wiring to the HM module via
# `home-manager.sharedModules`.
#
# Same operator surface as nixos.nix; the two are functionally
# identical (nix-darwin's `environment.systemPackages` provides
# /run/current-system/sw/bin install on Darwin same way NixOS does
# on Linux).
{ config, lib, pkgs, ... }:

let
  cfg = config.programs.frostmourne;
  hmModule = import ./default.nix;
in
{
  options.programs.frostmourne = {
    enable = lib.mkEnableOption "frostmourne — curated frost distribution (Darwin system-wide)";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.frostmourne;
      defaultText = lib.literalExpression "pkgs.frostmourne";
      description = "The frostmourne package to install on Darwin.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    home-manager.sharedModules = lib.mkAfter [ hmModule ];
  };
}
