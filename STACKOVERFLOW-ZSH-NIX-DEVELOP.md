# Stack Overflow draft: preserving a Nix dev shell PATH in zsh

## Post content

### Title

How can I preserve a Nix dev shell's `PATH` when launching zsh with `nix develop -c zsh`?

### Question

I have a flake dev shell containing Mercury and Bats:

```nix
devShells.${system}.default = pkgs.mkShell {
  packages = [
    mercury
    bats
  ];
};
```

This works from Bash:

```console
$ nix develop -c bash -c 'type -a bats'
bats is /nix/store/...-bats-1.12.0/bin/bats
bats is /home/me/.nix-profile/bin/bats
```

But when I enter zsh:

```console
$ nix develop -c zsh
$ which bats
/home/me/.nix-profile/bin/bats
```

My zsh startup files prepend personal paths, including `~/.nix-profile/bin`. I do
not want to change global zsh configuration just for one project. How can the
project ensure its Nix tools remain first in `PATH`?

## Answer to post and accept

Use a project-local `ZDOTDIR` wrapper. The dev shell saves its original `PATH`,
sources the user's normal zsh files, then prepends the saved dev-shell path again.

In the flake:

```nix
devShells.${system}.default = pkgs.mkShell {
  packages = [
    mercury
    bats
  ];

  shellHook = ''
    export PROJECT_DEV_PATH="$PATH"
    export PROJECT_USER_ZDOTDIR="$HOME"
    export ZDOTDIR="${./dev-shell/zsh}"
  '';
};
```

Create `dev-shell/zsh/.zshenv`:

```zsh
if [[ -f "$PROJECT_USER_ZDOTDIR/.zshenv" ]]; then
  source "$PROJECT_USER_ZDOTDIR/.zshenv"
fi
```

Create `dev-shell/zsh/.zshrc`:

```zsh
if [[ -f "$PROJECT_USER_ZDOTDIR/.zshrc" ]]; then
  source "$PROJECT_USER_ZDOTDIR/.zshrc"
fi

if [[ -n ${PROJECT_DEV_PATH-} ]]; then
  # User startup files may reorder PATH; restore project tools first.
  typeset +U path 2>/dev/null
  export PATH="${PROJECT_DEV_PATH}:${PATH}"
fi
```

Now:

```console
$ nix develop -c zsh
$ which mmc
/nix/store/...-mercury-22.01.8/bin/mmc

$ which bats
/nix/store/...-bats-1.12.0/bin/bats
```

This preserves the user's normal aliases, prompt, plugins, and base-system
commands. It changes only PATH precedence while inside this project's dev shell.

