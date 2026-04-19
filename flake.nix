{
  description = "frostmourne — curated, Lisp-authored frost distribution";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    frost = {
      url = "github:pleme-io/frost";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, frost, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      frostPkg = frost.packages.${system}.default;

      # Concatenate every `lisp/*.lisp` in lexical order into one rc
      # file that frost-lisp's loader consumes. The numeric prefixes
      # in lisp/NN-…lisp drive the load order.
      rc = pkgs.runCommand "frostmourne-rc.lisp" {} ''
        mkdir -p $out/share/frostmourne
        for f in ${self}/lisp/*.lisp; do
          cat "$f" >> $out/share/frostmourne/rc.lisp
          echo "" >> $out/share/frostmourne/rc.lisp
        done
      '';

      # Thin wrapper: sets FROSTRC to the bundled rc and execs frost.
      # Installed as `frostmourne`. Using `--` so positional args pass
      # through to frost unchanged.
      frostmourne = pkgs.writeShellScriptBin "frostmourne" ''
        export FROSTRC="''${FROSTRC:-${rc}/share/frostmourne/rc.lisp}"
        exec ${frostPkg}/bin/frost "$@"
      '';
    in {
      packages = {
        default = frostmourne;
        inherit frostmourne;
        rc = rc;
      };

      apps.default = {
        type = "app";
        program = "${frostmourne}/bin/frostmourne";
      };

      devShells.default = pkgs.mkShell {
        packages = [ frostPkg ];
        shellHook = ''
          export FROSTRC=${self}/lisp/rc-dev.lisp
          echo "frostmourne dev shell — frost = ${frostPkg}/bin/frost"
          echo "Run 'frost' to launch the shell with the dev rc."
        '';
      };
    }) // {
      homeManagerModules.default = import ./module;
      overlays.default = final: prev: {
        frostmourne = self.packages.${prev.stdenv.hostPlatform.system}.default;
      };
    };
}
