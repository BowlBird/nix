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

			args = {inherit inputs outputs;};

			utils = import ./utils.nix { inherit nixpkgs; inherit inputs; };

			system = modules: nixpkgs.lib.nixosSystem { 
				system = "x86_64-linux";
				specialArgs = args;
				inherit modules; 
			};
		in {		
			nixosConfigurations = {
				nest = system [./nixos/configuration.nix];
			};

			homeConfigurations = utils.buildHomes [ 
				{ system = "nest"; users = ["bowlbird"]; }
			] args;
		};
}
