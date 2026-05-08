{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs { inherit system; };
      package = pkgs.callPackage ./lumora.nix { };
    in
    {
      packages."${system}" = {
        default = package;
        LumoraVR = package;
      };
      apps."${system}".default = {
        type = "app";
        program = "${package}/bin/LumoraVR";
      };
    };
}
