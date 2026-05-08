### Usage
Add the flake as an input
```nix
lumoravr = {
  url = "github:Spaceey1/lumoravr-flake";
  inputs.nixpkgs.follows = "nixpkgs"; #optional
};
```
Then add it as a NixOS package in your packages list.
```nix
environment.systemPackages = [
  inputs.lumoravr.LumoraVR
];
```
Or in home manager
```nix
home.packages = [
  inputs.lumoravr.LumoraVR
];
```
Remember to pass in inputs or the lumoravr flake as params to your modules

If you don't feel like changing your configuration you can also try the game out with just
```
nix run github:Spaceey1/lumoravr-flake
```
