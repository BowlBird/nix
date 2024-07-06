{ nixpkgs, inputs }: {

  build = args: let 
    hosts = (nixpkgs.lib.mapAttrsToList 
      (name: value: name)
      (builtins.readDir ./host)
    );

    users = 
    (map 
      (host: {
        system = host;
        users = (nixpkgs.lib.mapAttrsToList
          (name: value: name)
          (builtins.readDir (./home + "/${host}/home"))
        );
      })
      hosts
    );

    buildSystems = systems: args: builtins.listToAttrs 
      (map
        (system: {
          name = system;
          value = nixpkgs.lib.nixosSystem { 
            system = "x86_64-linux";
            specialArgs = args;
            modules = [(./host + "/${system}")]; 
          };
        })
        systems
      );

    buildHomes = systems: args: with nixpkgs.lib; let 
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
              value = inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.x86_64-linux;
                extraSpecialArgs = args; 
                modules = [(./home + "/${user}/${system}")];
              };
            }) 
            systemDefinitions
          );
    in {
      nixosConfigurations = buildSystems hosts args;
      homeConfigurations = buildHomes users args;
    };
}