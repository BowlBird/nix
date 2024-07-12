{ nixpkgs, rootPath, ... }: {

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
          (builtins.readDir (./host + "/${host}/home"))
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
                modules = [(./host + "/${system}/home/${user}")];
              };
            })
            systemDefinitions
          );
    in {
      nixosConfigurations = buildSystems hosts args;
      homeConfigurations = buildHomes users args;
    };

  buildImports = imports: with nixpkgs.lib; flatten
    (nixpkgs.lib.mapAttrsToList
      (name: value: (map
        (module: rootPath + "/common/${name}/${module}.nix")
        (value)
      ))
      (imports)
    );

  buildHost = { imports, users, hostName, timeZone, locale }: {
    imports = imports ++ [
      (rootPath + "/common/host-programs/.home-manager.nix")
      (rootPath + "/host/${hostName}/hardware-configuration.nix")
    ];
    users.users = users;
    networking.hostName = hostName;
    time.timeZone = timeZone;
    i18n.defaultLocale = locale;
    system.stateVersion = "24.05";
  };

  buildHome = { imports, username, packages }: {
    imports = imports ++ [
      (rootPath + "/common/home/.home-manager.nix")
    ];
    home = {
      username = username;
      homeDirectory = "/home/" + username;
      stateVersion = "24.05";
      packages = packages;
    };
  };
}
