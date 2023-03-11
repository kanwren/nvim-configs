{
  description = "My Neovim configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # TODO(wrenn): https://github.com/NixOS/nixpkgs/pull/178737
    nixpkgs-emmet-ls.url = "github:NixOS/nixpkgs?rev=177e8d2647a8eba1e03f4d50ee73597671145180";
  };

  outputs = { self, nixpkgs, flake-utils, nixpkgs-emmet-ls }:
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
            buildCommand = (old.buildCommand or "") + ''
              # Wrap neovim to add an environment variable that will tell
              # init.lua where the copy of the configs are in the nix store;
              # this will be added to &runtimepath
              wrapProgram $out/bin/nvim --prefix PATH : ${lib.makeBinPath deps}
            '';
          });

        emmet-ls = nixpkgs-emmet-ls.legacyPackages.${system}.nodePackages.emmet-ls;

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

          # LSP
          rnix-lsp
          texlab
          clang-tools
          rust-analyzer
          lua-language-server
          gopls
          terraform-ls
          emmet-ls
          nodePackages.vscode-langservers-extracted
          python310Packages.python-lsp-server
          python310Packages.python-lsp-black
          python310Packages.pylsp-mypy
        ];
      in
      {
        defaultPackage = self.packages.${system}.neovim;
        packages.neovim = neovim;
      }
    );
}
