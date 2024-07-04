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

			system = modules: nixpkgs.lib.nixosSystem { 
				system = "x86_64-linux";
				specialArgs = args;
				inherit modules; 
			};

			homes = systems: with nixpkgs.lib; let 
				systems = flatten forEach systems (system: forEach system.users (user: {inherit system; inherit user;}));	
			in
				builtins.listToAttrs forEach systems (system: {
					name = "${user}@${system}";
					value = home-manager.lib.homeManagerConfiguration {
						pkgs = nixpkgs.legacyPackages.x86_64-linux;
						extraSpecialArgs = args; 
						module = (./home + "/${user}/${system}");
				};
			});
		in {		
			nixosConfigurations = {
				nest = system [./nixos/configuration.nix];
			};

			homeConfigurations = homes [ 
				{ system = "nest"; users = ["bowlbird"]; }
			];
		};
}
