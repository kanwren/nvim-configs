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
              ])}
            '';
          });
      });
    };
}
