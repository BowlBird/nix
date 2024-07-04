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

			system = modules: nixpkgs.lib.nixosSystem { 
				specialArgs = {inherit inputs outputs;};
				inherit modules; 
			};

			home = modules: home-manager.lib.homeManagerConfiguration {
				pkgs = nixpkgs.legacyPackages.x86_64-linux;
				extraSpecialArgs = {inherit inputs outputs;};
				inherit modules;
			};
		in {		
			nixosConfigurations = {
				vm = system [./nixos/configuration.nix];
			};

			homeConfigurations = {
				"bowlbird@vm" = home [./home-manager/home.nix];
			};
		};
}
