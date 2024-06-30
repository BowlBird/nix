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
	outputs = { self, nixpkgs, home-manager, plymouth-theme-bowlbird-logo, ... } @ inputs: 
		let
			inherit (self) outputs;
		in {		
			nixosConfigurations = {
				vm = nixpkgs.lib.nixosSystem {
					specialArgs = {inherit inputs outputs;};
					modules = [./nixos/configuration.nix];
				};
			};

			homeConfigurations = {
				"bowlbird@vm" = home-manager.lib.homeManagerConfiguration {
					pkgs = nixpkgs.legacyPackages.x86_64-linux;
					extraSpecialArgs = {inherit inputs outputs;};
					modules = [./home-manager/home.nix];
				};
			};
		};
}
