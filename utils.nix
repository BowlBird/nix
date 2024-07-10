{ ... }: {

  build = pkgs: args: let 
    hosts = (pkgs.lib.mapAttrsToList 
      (name: value: name)
      (builtins.readDir ./host)
    );

    users = 
    (map 
      (host: {
        system = host;
        users = (pkgs.lib.mapAttrsToList
          (name: value: name)
          (builtins.readDir (./host + "/${host}/home"))
        );
      })
      hosts
    );

    buildSystems = systems: args: builtins.listToAttrs 
      (map
        (system: {
          name = system;
          value = pkgs.lib.nixosSystem { 
            system = "x86_64-linux";
            specialArgs = args;
            modules = [(./host + "/${system}")]; 
          };
        })
        systems
      );

    buildHomes = systems: args: with pkgs.lib; let 
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
                modules = [(./host + "/${system}/home/${user}")];
              };
            }) 
            systemDefinitions
          );
    in {
      nixosConfigurations = buildSystems hosts args;
      homeConfigurations = buildHomes users args;
    };

  hostImports = system: let
    dir = ./host + "/${system}/modules";
  in
    (map
      (file: dir + "/${file}")
      (builtins.attrNames 
        (builtins.readDir dir)
      )
    );
}