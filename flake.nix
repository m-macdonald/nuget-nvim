{
    inputs = {
        flake-utils.url = "github:numtide/flake-utils";
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {
        self,
        flake-utils,
        nixpkgs,
        nixvim
    }: 
      flake-utils.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs {inherit system;};
        nixvim' = nixvim.legacyPackages.${system};
        nixvimModule = {
            inherit pkgs;
            module = {
                plugins.lazy = {
                    enable = true;
                    plugins = [
                        {
                            name = "nuget-nvim";
                            dev = true;
                            dir = "./";
                            # Not used but the module expects a package to be given
                            pkg = pkgs.cowsay;
                        }
                    ];
                };
            };
        };

        nvim = nixvim'.makeNixvimWithModule nixvimModule;

        in {
            devShells.default = pkgs.mkShell {
                packages = [ nvim pkgs.nuget ];
            };

            format = pkgs.alejandra;
        });
}
