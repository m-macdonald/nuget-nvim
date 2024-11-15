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
                    extraConfigLua = ''
                        function P(v)
                            print(vim.inspect(v))
                            return v
                        end;

                        function RELOAD(...)
                            require("lazy").reload(...)
                        end

                        function R(name)
                            RELOAD(name)
                            return require(name)
                        end
                    '';
                    plugins.lazy = {
                        enable = true;
                        plugins = [
                            pkgs.vimPlugins.plenary-nvim
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
                packages = [ 
                    pkgs.nuget
                    # Future me: DO NOT TOUCH THIS
                    # It took ages to figure out how to allow two binaries with the same name to be on the path in the nix develop shell
                    # This takes the nvim derivation that we build above and changes the binary name to 'devvim' so that my fully configured nvim isn't overridden by this derivation which is only used for testing.
                    (pkgs.runCommand "devvim" { nativeBuildInputs = [ pkgs.makeWrapper ];} ''
                        mkdir -p $out/bin
                        makeWrapper ${nvim}/bin/nvim $out/bin/devvim --argv0 nvim
                        '')
                ];
            };
        });
}
