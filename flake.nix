{
	description = "BowlBirdOS";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		plymouth-theme-bowlbird-logo.url = "github:bowlbird/plymouth-theme-bowlbird-logo";

		niri.url = "github:sodiboo/niri-flake";
	};
	outputs = { self, nixpkgs, home-manager, ... } @ inputs:
		let
			inherit (self) outputs;
			sysUtils = import ./utils.nix { inherit nixpkgs home-manager;};
		in sysUtils.build { inherit inputs sysUtils outputs; };
}
