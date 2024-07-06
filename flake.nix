{
	description = "BowlBirdOS";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		plymouth-theme-bowlbird-logo.url = "github:bowlbird/plymouth-theme-bowlbird-logo";
	};
	outputs = { self, nixpkgs, home-manager, ... } @ inputs: 
		let
			inherit (self) outputs;

			utils = import ./utils.nix { inherit nixpkgs; inherit inputs; };
			
		in utils.build {inherit inputs outputs;};
}
