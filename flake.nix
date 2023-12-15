{
  description = "My Neovim configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (nixpkgs) lib;
        pkgs = nixpkgs.legacyPackages.${system};

        neovim =
          let
            nvim = pkgs.neovim.override {
              # Can't set customRC here, since it will assume a .vim extension
              # It's fine that these are created before nvim is wrapped
              viAlias = true;
              vimAlias = true;
            };
          in
          nvim.overrideAttrs (old: {
            buildCommand = (old.buildCommand or "") + "wrapProgram $out/bin/nvim --prefix PATH : ${lib.makeBinPath deps}";
          });

        deps = with pkgs; [
          # core
          xxd
          git

          # for plugins
          gcc
          nodejs_latest
          yarn
          fzf
          code-minimap

          # language servers (+ associated tools)
          nixd
          texlab
          rust-analyzer
          lua-language-server
          gopls
          terraform-ls
          emmet-ls
          nodePackages.vscode-langservers-extracted
          nodePackages.bash-language-server

          # formatters
          nodePackages.prettier

          # linters
          shellcheck
        ];
      in
      {
        defaultPackage = self.packages.${system}.neovim;
        packages.neovim = neovim;
      }
    );
}
