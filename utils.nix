{ lib }: {

  buildHomes = systems: args: with lib; let 
    systemDefinitions = flatten
      (map 
        (system: (map
          (user: {inherit (system) system; inherit user;}) 
          system.users
        )) 
        systems
      );	
    in
      builtins.listToAttrs 
				(map 
					(definition: let 
						inherit (definition) user system;
					in {
						name = "${user}@${system}";
						value = home-manager.lib.homeManagerConfiguration {
							pkgs = nixpkgs.legacyPackages.x86_64-linux;
							extraSpecialArgs = args; 
							modules = [(./home + "/${user}/${system}")];
						};
					}) 
					systemDefinitions
				); 
}