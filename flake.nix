{
  description = "My Neovim configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        defaultPackage = self.packages.${system}.neovim;

        packages.neovim =
          let
            nvim = pkgs.neovim.override {
              # Can't set customRC here, since it will assume a .vim extension
              # It's fine that these are created before nvim is wrapped
              viAlias = true;
              vimAlias = true;
            };
          in
          nvim.overrideAttrs (old: {
            buildCommand = (old.buildCommand or "") + ''
              # Wrap neovim to add an environment variable that will tell
              # init.lua where the copy of the configs are in the nix store;
              # this will be added to &runtimepath
              wrapProgram $out/bin/nvim \
                --set NVIM_NIX_STDPATH_config ${./.} \
                --add-flags "-u ${./init.lua}"
            '';
          });
      }
    );
}
