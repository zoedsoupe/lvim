# lvim

An opiniated neovim config, written almost is Lua but set up with Nix!

## Executing

You can run with the sane default with `nix-flake`:

```sh
nix run github:zoedsoupe/lvim#apps.<system>.lvim
```

Where `<system>` is your system architecture.

## Add to Nix Flake project

You can use this config in your personal nix config using the overlay provieded, as:

```nix
{
    inputs = {
        # ...
        lvim.url = "github:zoedsoupe/lvim";
    };

    outputs = { lvim, ... }:
        let
            overlays = [ lvim.overlays."${system}".default ];
        in
        {
            # ...
        };
}
```
