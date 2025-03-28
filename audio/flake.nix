# Author: Jesse Gollub
{
    description = "Python development template";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        utils.url = "github:numtide/flake-utils";
    };

    outputs = {
        nixpkgs,
        utils,
        ...
    }:
        utils.lib.eachDefaultSystem (system: let
            pkgs = import nixpkgs {inherit system;};
            devDeps = with pkgs.python312Packages; [
                pytest
                black
                isort
                numpy
            ];
        in {
            devShells.default = pkgs.mkShell {
                buildInputs = devDeps;
            };

            checks.format =
                pkgs.runCommand "python-format" {
                    src = ./.;
                    buildInputs = devDeps;
                } ''
                    black --check $src
                    isort $src --check --diff --known-local-folder "src" --profile "black"
                    touch $out
                '';
        });
}
