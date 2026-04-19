# frostmourne

> frost + the runeblade. A curated, Lisp-authored distribution of the
> [frost](https://github.com/pleme-io/frost) shell.

frostmourne is to frost what
[blackmatter-shell (`blzsh`)](https://github.com/pleme-io/blackmatter-shell)
is to zsh: an opinionated, ready-to-use shell experience bundled as a
Nix flake. The entire configuration is written in tatara-lisp via
frost's [`frost-lisp`](https://github.com/pleme-io/frost/tree/main/crates/frost-lisp)
bridge.

## Try it

```bash
nix run github:pleme-io/frostmourne
```

## Use as your login shell (Home-Manager)

```nix
{
  inputs.frostmourne.url = "github:pleme-io/frostmourne";

  home-manager.users.you = { pkgs, ... }: {
    imports = [ inputs.frostmourne.homeManagerModules.default ];
    programs.frostmourne.enable = true;
  };
}
```

## See also

- [frost](https://github.com/pleme-io/frost) — the Rust shell
- [tatara](https://github.com/pleme-io/tatara) — the Lisp authoring layer
- [CLAUDE.md](./CLAUDE.md) — per-file breakdown
