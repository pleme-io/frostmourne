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
    # blx: blackmatter shell extensions. Ships a multicall `blx` binary
    # with symlink targets `blx-ls` (POSIX-flag-translating eza wrapper),
    # `blx-preview`, `blx-urlencode`, etc. frostmourne aliases `ls` to
    # `blx-ls` so `ls -ltra` works the way muscle memory expects on top
    # of eza (which otherwise rejects `-ltra` because `-t` means --time).
    blx = {
      url = "github:pleme-io/blx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # seki: pleme-io's typed prompt renderer (replaces starship). Default
    # tier ships blzsh-parity (the exact Nord-snowflake prompt blzsh
    # operators are used to). Wired into the rc via lisp/11-prompt-seki.lisp,
    # which is generated at build time from `seki init frostmourne` so
    # the prompt definition tracks seki's typed renderer.
    seki = {
      url = "github:pleme-io/seki";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # wadachi: pleme-io's native directory frecency primitive (轍). Replaces
    # zoxide — frost records every cd at its chdir chokepoint and `cd <partial>`
    # smart-jumps to the most-worn match. Bundled so the `wadachi` binary is on
    # PATH for frost's native record/resolve. Drives lisp/60-tools-wadachi.
    wadachi = {
      url = "github:pleme-io/wadachi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, frost, skim-tab, blx, seki, wadachi, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      frostPkg = frost.packages.${system}.default;
      frostForgePkg = frost.packages.${system}.frost-complete-forge;
      skimTabPkg = skim-tab.packages.${system}.default;
      blxBase = blx.packages.${system}.default;
      sekiPkg = seki.packages.${system}.default;
      wadachiPkg = wadachi.packages.${system}.default;

      # blx is a multicall binary: argv[0] like `blx-ls` routes to the
      # ls command. The stock nixpkgs package only installs `blx`, so
      # we build a symlink farm that adds `blx-ls`, `blx-preview*`,
      # `blx-json`, `blx-urlencode`, `blx-urldecode` for the rc to
      # reference.
      blxMulticall = pkgs.runCommand "blx-multicall" {} ''
        mkdir -p $out/bin
        cp -r ${blxBase}/* $out/ 2>/dev/null || true
        # Re-link any existing bins + add the multicall aliases.
        for entry in ${blxBase}/bin/*; do
          name=$(basename "$entry")
          ln -sf "$entry" "$out/bin/$name"
        done
        for sub in ls preview preview-dir preview-proc preview-git \
                   backup json urlencode urldecode weather; do
          ln -sf ${blxBase}/bin/blx "$out/bin/blx-$sub"
        done
      '';

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
        # ── Core fuzzy + shell integrations ─────────────────────────
        skim         # fuzzy picker (binary: `sk`) — drives C-r/C-t/M-c/C-f
        skimTabPkg   # `skim-*` + skim-tab — rich fuzzy picker binaries
        blxMulticall   # `blx` + multicall symlinks (blx-ls, blx-preview, …)
        frostForgePkg  # `frost-complete-forge` — fish→(def*) Lisp emitter
        sekiPkg      # `seki` — typed prompt renderer (default prompt; supersedes starship)
        wadachiPkg   # directory frecency 轍 — drives 60-tools-wadachi
        direnvFixed  # .envrc auto-loader — drives 62-tools-direnv
        starship     # cross-shell prompt — kept as fallback via 63-tools-starship
        atuin        # synced shell history w/ search — drives 64-tools-atuin

        # ── Rust-native classic-unix replacements ───────────────────
        fd           # `find` replacement; drives file/cd pickers
        ripgrep      # `grep` replacement; drives content picker
        bat          # syntax-highlighting `cat`
        delta        # git diff pager
        eza          # modern `ls` replacement
        sd           # `sed` replacement — simpler regex swap
        procs        # `ps` replacement with colorized tree
        tokei        # `cloc` replacement — fast codebase stats
        bandwhich    # `iftop`-style per-process bandwidth monitor
        hyperfine    # statistical benchmarking (blzsh parity)
        tealdeer     # `tldr` client — simplified man pages
        grex         # regex generator from examples

        # ── Misc quality-of-life ────────────────────────────────────
        jq           # json query, referenced in aliases
        shfmt        # shell formatter (blzsh parity)
        git          # ensures git is reachable even on bare nix hosts
        tig          # terminal git UI — drives 71-tools-git `t` alias

        # ── Kubernetes / GitOps tier (70-tools-kubernetes) ──────────
        kubectl
        kubecolor    # colorized kubectl wrapper, bound to `k`/`kc`
        kubectx      # drives `kcx` + `kns` aliases (provides kubens too)
        kubernetes-helm
        fluxcd       # GitOps controller CLI (binary: flux)
        k9s          # TUI
        k3d          # local clusters
        kind         # local clusters (alt)
        stern        # multi-pod log tailing, bound to `kstern`

        # ── Cloud CLIs (72-tools-cloud) ─────────────────────────────
        awscli2
        google-cloud-sdk
        azure-cli
      ];

      # ─── Pre-generated completion specs from skim-tab YAMLs ──────
      # skim-tab curates 12 completion trees (kubectl/helm/flux/docker/
      # git/nix/cargo/npm/terraform/aws/gcloud/az). At build time we
      # run `frost-complete-forge yaml-dir` over that spec directory
      # and inline the emitted (def*) forms into our rc — so a fresh
      # frostmourne install offers rich subcommand completion out of
      # the box for 12 common tools with zero per-user configuration.
      generatedCompletions = pkgs.runCommand "frostmourne-generated-completions.lisp" {
        nativeBuildInputs = [ frostForgePkg ];
      } ''
        echo ";; frostmourne :: skim-tab-generated completions" > $out
        echo ";; Regenerate by bumping the skim-tab input — do not hand-edit." >> $out
        echo "" >> $out
        frost-complete-forge yaml-dir ${skim-tab}/specs >> $out
      '';

      # ─── Pre-generated completion specs from bundled fish files ───
      # For every bundled package, fish-completion files (if any) ship
      # under `$out/share/fish/{completions,vendor_completions.d}`.
      # Walk every bundled tool's store path and forge each `*.fish`
      # into (def*) forms. This complements the YAML-driven pass
      # above with flag-level completions (subcommand hierarchy comes
      # from YAMLs; per-flag details from the fish files).
      #
      # fish files are noisy — many reference dynamic `(command …)`
      # producers we can't evaluate. The forge drops those and keeps
      # the static flag + description entries; `|| true` guards the
      # per-file call so a single bad fish file doesn't abort the
      # whole pipeline.
      fishCompletions = pkgs.runCommand "frostmourne-fish-completions.lisp" {
        nativeBuildInputs = [ frostForgePkg ];
      } ''
        echo ";; frostmourne :: fish-derived flag completions" > $out
        echo ";; Auto-generated at build time from each bundled package's fish files." >> $out
        echo ";; Regenerate by bumping any of the source packages." >> $out
        echo "" >> $out
        for pkg_path in ${pkgs.lib.concatStringsSep " " (map (p: "${p}") bundledTools)}; do
          for fish_dir in "$pkg_path/share/fish/completions" "$pkg_path/share/fish/vendor_completions.d"; do
            [ -d "$fish_dir" ] || continue
            for f in "$fish_dir"/*.fish; do
              [ -f "$f" ] || continue
              frost-complete-forge fish "$f" >> $out 2>/dev/null || true
            done
          done
        done
      '';

      # ─── seki prompt form ─────────────────────────────────────────
      # Generated from `seki init frostmourne` so the `(defprompt …)`
      # form tracks seki's typed renderer. seki ships the default
      # tier as blzsh-parity (the exact Nord-snowflake prompt blzsh
      # operators are used to). This form is loaded AFTER the
      # hand-authored `lisp/11-prompt-seki.lisp` shim, so the last
      # defprompt wins and the seki prompt always supersedes the
      # legacy gray/cyan `lisp/10-prompt.lisp`.
      sekiPromptLisp = pkgs.runCommand "frostmourne-seki-prompt.lisp" {
        nativeBuildInputs = [ sekiPkg ];
      } ''
        echo ";; frostmourne :: seki prompt (auto-generated by build)" > $out
        echo ";; Regenerate by bumping the seki flake input." >> $out
        echo "" >> $out
        seki init frostmourne >> $out
      '';

      # ─── Concatenated rc ──────────────────────────────────────────
      # Every `lisp/*.lisp` in lexical order → one rc file that
      # frost-lisp's loader consumes. Numeric prefix NN-…lisp drives
      # load order (00-core first, tools last). The skim-tab-generated
      # completion forms land at the END so user-authored specs in
      # lisp/*.lisp can override them (later forms win in frost-lisp's
      # bind/completion registry for the same (path, name)).
      #
      # The seki-generated `(defprompt …)` form lands AFTER all the
      # hand-authored lisp/*.lisp files. Since frost-lisp's `defprompt`
      # is last-wins, this guarantees the seki prompt supersedes
      # `lisp/10-prompt.lisp` (the legacy gray/cyan two-liner).
      rc = pkgs.runCommand "frostmourne-rc.lisp" {} ''
        mkdir -p $out/share/frostmourne
        for f in ${self}/lisp/*.lisp; do
          cat "$f" >> $out/share/frostmourne/rc.lisp
          echo "" >> $out/share/frostmourne/rc.lisp
        done
        echo "" >> $out/share/frostmourne/rc.lisp
        cat ${sekiPromptLisp} >> $out/share/frostmourne/rc.lisp
        echo "" >> $out/share/frostmourne/rc.lisp
        cat ${generatedCompletions} >> $out/share/frostmourne/rc.lisp
        echo "" >> $out/share/frostmourne/rc.lisp
        cat ${fishCompletions} >> $out/share/frostmourne/rc.lisp
      '';

      # ─── Wrapper ──────────────────────────────────────────────────
      # Installs as `frostmourne`. Puts every bundled tool in front of
      # the system PATH so the rc's `command -v zoxide` etc. resolve
      # even on a minimal host. Sets FROSTRC to the bundled rc. Execs
      # frost; positional args pass through.
      # ── Why a COMPILED wrapper and not writeShellApplication ─────────
      #
      # This wrapper runs on every shell spawn — every mado pane, every
      # `SHELL=` consumer, every login. It used to be a bash script, and
      # bash costs ~9 ms to start on an M-series mac even with --norc.
      # Measured on ryn 2026-08-07 after the BASH_ENV refork was fixed
      # separately (same-batch hyperfine -N, n=30, identical rc):
      #
      #   wrapped in bash        60.7 ms
      #   frost binary direct    51.7 ms      <- the 9.0 ms this removes
      #
      # Stated plainly because it was mis-attributed once: the wrapper is
      # ~9 ms, NOT the ~87 ms first blamed on it. That 87 ms was
      # hm-session-vars re-forking `$(cat)` per secret on every bash
      # spawn, fixed in blackmatter's env component. Fixing the wrapper
      # without fixing that would have looked like a null result.
      #
      # makeBinaryWrapper emits a small C program instead of a shell
      # script, so the exec chain is wrapper -> frost with no interpreter
      # in between.
      #
      # ── What the wrapper MUST preserve ───────────────────────────────
      #
      # `--inherit-argv0` is load-bearing, not tidiness. login(1) signals
      # "this is a login shell" by prefixing argv[0] with a dash — it
      # invokes us as `-frostmourne` — and frost reads exactly that
      # convention (frost/crates/frost/src/boot_posture.rs:101,
      # `argv0.starts_with('-')`). A wrapper that rewrites argv[0] makes
      # `boot_posture.login` silently false forever, which is the bug the
      # previous bash wrapper's `exec -a` existed to fix. Same requirement,
      # expressed as a flag rather than as shell.
      #
      # SHELL must be an ABSOLUTE PATH, and must not be derived from
      # argv[0] — under login(1) argv[0] is the literal string
      # `-frostmourne`, which is not a path and not executable, so every
      # `getenv("SHELL")` consumer (mado, tear, an editor's `:!sh`) would
      # try to spawn it and fail. It is pinned to $out/bin/frostmourne.
      #
      # FROSTRC uses --set-default so an operator override still wins.
      #
      # FROSTMOURNE_TOOLS_PATH is GONE. It was set on one line and read on
      # the next and nowhere else — a grep across frostmourne, frost, nix
      # and blackmatter-shell finds exactly those two lines. The bundled
      # tools are prefixed onto PATH directly, which is what those two
      # lines amounted to. Kept out rather than carried forward as a
      # variable nothing consumes.
      #
      # ── Nix profile dirs on PATH ─────────────────────────────────────
      # frostmourne sources none of nix-darwin's /etc/zshrc / path_helper
      # chain, so on a GUI-launched spawn (mado → frostmourne) it inherits
      # a PATH with no nix profile dirs at all. The two STATIC dirs are
      # prefixed here so `nix`, `darwin-rebuild` and the system profile
      # resolve on any nix host regardless of what spawned us.
      #
      # The per-user dir (/etc/profiles/per-user/$USER/bin — where ~140 HM
      # tools live) is NOT here on purpose: makeBinaryWrapper embeds its
      # --prefix value literally and cannot resolve $USER at runtime, and
      # this package is fleet-generic (no user baked in). That dir is
      # supplied two other ways — the nix-darwin launchd user-path guard,
      # and frost's own boot-time nix detection (resolves $USER live) —
      # either of which makes this wrapper's static list retire-able.
      frostmourne = (pkgs.runCommand "frostmourne" {
        nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
      } ''
        mkdir -p $out/bin
        makeBinaryWrapper ${frostPkg}/bin/frost $out/bin/frostmourne \
          --inherit-argv0 \
          --set-default FROSTRC ${rc}/share/frostmourne/rc.lisp \
          --set SHELL $out/bin/frostmourne \
          --prefix PATH : ${pkgs.lib.makeBinPath bundledTools}:/run/wrappers/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin
      '').overrideAttrs (old: {
        # ── shellPath: what makes this usable as a LOGIN shell at all ────
        # nix-darwin and NixOS accept `users.users.<n>.shell` as either a
        # string or a PACKAGE. Given a package they read `pkg.shellPath` and
        # append it to the store path. With no `shellPath` the option renders
        # the bare store DIRECTORY — `/nix/store/…-frostmourne` — which is
        # not executable, so the account gets a broken login shell and the
        # failure appears at login time, not at build time.
        #
        # Measured 2026-08-06: org-wide, the ONLY pleme-io package carrying
        # shellPath was blzsh (blackmatter-shell/package.nix:347). That is
        # why `kindling-profiles/profiles/macos-developer/default.nix:199`
        # could say `shell = blzsh;` and why the same line could not simply
        # be pointed at frostmourne. Fixing it here fixes every consumer at
        # once, rather than each call site spelling out
        # "${frostmourne}/bin/frostmourne" and drifting.
        passthru = (old.passthru or { }) // {
          shellPath = "/bin/frostmourne";
        };
      });
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

      # ── Regression tests: BEHAVIOUR of the assembled shell ────────────────
      #
      # These run the real frostmourne binary against the real rc, because the
      # thing worth protecting is not "is the option listed in a lisp file" —
      # it is "does the shell actually split". `setopt shwordsplit` was defined
      # and parsed by frost and read by NOTHING for its whole existence: the
      # option reported success and changed no behaviour. A test that asserted
      # the CONFIG would have passed the entire time.
      checks = {
        shwordsplit = pkgs.runCommand "frostmourne-shwordsplit" { } ''
          fm=${frostmourne}/bin/frostmourne

          # 1. an unquoted parameter SPLITS into separate words
          got=$(printf 'x="a b c"\nset -- $x\necho $#\n' | "$fm" 2>/dev/null | tail -1)
          if [ "$got" != "3" ]; then
            echo "unquoted \$x must split into 3 words, got: '$got'"
            echo "This is the bug that made 'ssh \$OPTS host' pass one giant argument."
            exit 1
          fi

          # 2. QUOTING still wins — the whole point of quoting, and the thing
          #    enabling shwordsplit must not break.
          got=$(printf 'x="a b c"\nset -- "$x"\necho $#\n' | "$fm" 2>/dev/null | tail -1)
          if [ "$got" != "1" ]; then
            echo "\"\$x\" must stay ONE word, got: '$got'"
            exit 1
          fi

          # 3. a scalar assignment is unaffected — field splitting is a
          #    property of the CONTEXT, not of the expansion.
          got=$(printf 'x="a b c"\ny=$x\necho "[$y]"\n' | "$fm" 2>/dev/null | tail -1)
          if [ "$got" != "[a b c]" ]; then
            echo "assignment must keep the spaces, got: '$got'"
            exit 1
          fi

          echo "shwordsplit: splits unquoted, respects quotes, leaves assignment alone"
          touch $out
        '';

        # A continuation line drawn with PS1 made an unclosed quote invisible
        # (frost#4). The rc must hand frost a PS2 that names the open construct.
        ps2 = pkgs.runCommand "frostmourne-ps2" { } ''
          got=$(printf 'echo "$PS2"\n' | ${frostmourne}/bin/frostmourne 2>/dev/null | tail -1)
          case "$got" in
            *%_*) echo "ps2: $got"; touch $out ;;
            *) echo "PS2 must contain %_, got: '$got'"; exit 1 ;;
          esac
        '';
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
      nixosModules.default = import ./module/nixos.nix;
      darwinModules.default = import ./module/darwin.nix;
      overlays.default = final: prev: {
        frostmourne = self.packages.${prev.stdenv.hostPlatform.system}.default;
      };
    };
}
