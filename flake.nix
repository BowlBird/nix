{
	description = "BowlBirdOS";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

        hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
        hyprland-easymotion = {
            url = "github:bowlbird/hyprland-easymotion";
            inputs.hyprland.follows = "hyprland";
        };
        split-monitor-workspaces = {
          url = "github:Duckonaut/split-monitor-workspaces";
          inputs.hyprland.follows = "hyprland";
        };

		plymouth-theme-bowlbird-logo.url = "github:bowlbird/plymouth-theme-bowlbird-logo";
	};
	outputs = { self, nixpkgs, home-manager, hyprland, ... } @ inputs:
		let
			inherit (self) outputs;
			sysUtils = import ./utils.nix { inherit nixpkgs home-manager;};
		in sysUtils.build { inherit inputs sysUtils outputs; };
}
