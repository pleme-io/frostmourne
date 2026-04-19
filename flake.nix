{
  description = "frostmourne — curated, Lisp-authored frost distribution";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    frost = {
      url = "github:pleme-io/frost";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # skim-tab: pleme-io's Rust fuzzy tab-completion bridge. Used by
    # blackmatter-shell's `skim-tab-complete` plugin to turn zsh's compadd
    # into a skim picker; we absorb the same binary so frost-complete can
    # call it out for rich candidate descriptions. Exposed as `sk-tab`.
    skim-tab = {
      url = "github:pleme-io/skim-tab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, frost, skim-tab, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      frostPkg = frost.packages.${system}.default;
      skimTabPkg = skim-tab.packages.${system}.default;

      # ─── Bundled tools ────────────────────────────────────────────
      # Mirrors `blackmatter-shell` — the Rust tool stack that blzsh
      # relies on (skim + skim-tab + zoxide + atuin + starship + direnv
      # + fd + rg + bat + delta + eza + jq) is bundled here too so the
      # `defbind` + `defhook` forms in `lisp/60-tools-*.lisp` have
      # working binaries to drive on any host.
      #
      # direnv's nixpkgs test suite flakes on Darwin (CGO integration
      # test spawns subprocesses that touch dtrace). Disable its tests —
      # we trust upstream's direnv-unit-tests and we only need the
      # binary. blackmatter-direnv does the same thing for the whole
      # fleet; we inline the fix here so frostmourne stays a single
      # self-contained flake.
      direnvFixed = pkgs.direnv.overrideAttrs (_: { doCheck = false; });

      bundledTools = with pkgs; [
        skim         # fuzzy picker (binary: `sk`) — drives C-r/C-t/M-c/C-f
        skimTabPkg   # `sk-tab` — rich fuzzy completion backend
        zoxide       # smarter cd — drives 60-tools-zoxide
        direnvFixed  # .envrc auto-loader — drives 62-tools-direnv
        starship     # cross-shell prompt — optional via 63-tools-starship
        atuin        # synced shell history w/ search — drives 64-tools-atuin
        fd           # faster find, drives file/cd pickers + FZF/SKIM_DEFAULT_COMMAND
        ripgrep      # fast grep, drives the content picker
        bat          # syntax-highlighting cat
        delta        # git diff pager
        eza          # modern ls replacement
        jq           # json query, referenced in aliases
        git          # ensures git is reachable even on bare nix hosts
      ];

      # ─── Concatenated rc ──────────────────────────────────────────
      # Every `lisp/*.lisp` in lexical order → one rc file that
      # frost-lisp's loader consumes. Numeric prefix NN-…lisp drives
      # load order (00-core first, tools last).
      rc = pkgs.runCommand "frostmourne-rc.lisp" {} ''
        mkdir -p $out/share/frostmourne
        for f in ${self}/lisp/*.lisp; do
          cat "$f" >> $out/share/frostmourne/rc.lisp
          echo "" >> $out/share/frostmourne/rc.lisp
        done
      '';

      # ─── Wrapper ──────────────────────────────────────────────────
      # Installs as `frostmourne`. Puts every bundled tool in front of
      # the system PATH so the rc's `command -v zoxide` etc. resolve
      # even on a minimal host. Sets FROSTRC to the bundled rc. Execs
      # frost; positional args pass through.
      frostmourne = pkgs.writeShellApplication {
        name = "frostmourne";
        runtimeInputs = bundledTools;
        text = ''
          export FROSTRC="''${FROSTRC:-${rc}/share/frostmourne/rc.lisp}"
          export FROSTMOURNE_TOOLS_PATH="''${FROSTMOURNE_TOOLS_PATH:-${pkgs.lib.makeBinPath bundledTools}}"
          export PATH="$FROSTMOURNE_TOOLS_PATH:$PATH"
          exec ${frostPkg}/bin/frost "$@"
        '';
      };
    in {
      packages = {
        default = frostmourne;
        inherit frostmourne;
        rc = rc;
        tools = pkgs.symlinkJoin {
          name = "frostmourne-tools";
          paths = bundledTools;
        };
      };

      apps.default = {
        type = "app";
        program = "${frostmourne}/bin/frostmourne";
      };

      devShells.default = pkgs.mkShell {
        packages = [ frostPkg ] ++ bundledTools;
        shellHook = ''
          export FROSTRC=${self}/lisp/rc-dev.lisp
          echo "frostmourne dev shell — frost = ${frostPkg}/bin/frost"
          echo "Tools on PATH: fzf zoxide direnv starship atuin fd ripgrep bat delta eza jq"
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
