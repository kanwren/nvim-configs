{
  description = "My Neovim configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: {
        default = self.packages.${pkgs.system}.neovim;

        neovim =
          (pkgs.neovim.override {
            viAlias = true;
            vimAlias = true;
          }).overrideAttrs (old: {
            installPhase = (old.installPhase or "") + ''
              wrapProgram $out/bin/nvim --prefix PATH : ${nixpkgs.lib.makeBinPath (with pkgs; [
                # core
                xxd
                git

                # for plugins
                gcc
                nodejs_latest
                yarn
                fzf

                # language servers (+ associated tools)
                ## go
                go-tools
                gomodifytags
                gopls
                gotools
                impl
                ## html/css/etc
                emmet-ls
                vscode-langservers-extracted
                ## lua
                lua-language-server
                ## nix
                nixd
                alejandra
                statix
                ## ruby
                solargraph
                ## rust
                rust-analyzer
                ## shell
                bash-language-server
                shellcheck
                shellharden
                ## terraform
                terraform-ls
                ## tex
                texlab
                ## typescript
                typescript-language-server
              ])}
            '';
          });
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.just
          ];
        };
      });
    };
}
