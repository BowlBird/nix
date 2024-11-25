{
	description = "BowlBirdOS";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

        hyprland.url = "github:hyprwm/Hyprland?ref=0.45.1-b";
        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins?ref=95fee7d0a7fa48828f5e9da1af6dc1fd7adb360d";
            inputs.hyprland.follows = "hyprland";
        };
        hyprland-easymotion = {
            url = "github:zakk4223/hyprland-easymotion?ref=3388351d2af672f89b907404668c6076336270e9";
            inputs.hyprland.follows = "hyprland";
        };
        hyprsplit = {
          url = "github:shezdy/hyprsplit?ref=09a1f2b89f61b32b3d7a58e8d1eae93653009859";
          inputs.hyprland.follows = "hyprland";
        };
        hyprspace = {
          url = "github:KZDKM/Hyprspace?ref=260f386075c7f6818033b05466a368d8821cde2d";
          inputs.hyprland.follows = "hyprland";
        };

         matugen.url = "github:/InioX/Matugen";

		plymouth-theme-bowlbird-logo.url = "github:bowlbird/plymouth-theme-bowlbird-logo";
	};
	outputs = { self, nixpkgs, home-manager, hyprland, ... } @ inputs:
		let
			inherit (self) outputs;
			sysUtils = import ./utils.nix { inherit nixpkgs home-manager;};
		in sysUtils.build { inherit inputs sysUtils outputs; };
}
