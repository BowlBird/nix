{ nixpkgs, home-manager, rootPath, ... }: {

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
              value = home-manager.lib.homeManagerConfiguration {
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


  buildHost = hostName: { imports, timeZone, locale }:
    let
      getUsers = path: builtins.listToAttrs
        (map
          (user: {
            name = user;
            value = let
                settings = import path + "/${user}/user.nix";
              in {
                isNormalUser = true;
                extraGroups = settings.groups;
              };
          })
          (nixpkgs.lib.mapAttrsToList
            (name: value: name)
            (builtins.readDir path)
          )
        );
    in {
      imports = imports ++ [
        (rootPath + "/common/host-programs/.home-manager.nix")
        (rootPath + "/host/${hostName}/hardware-configuration.nix")
      ];
      users.users = getUsers path;
      networking.hostName = hostName;
      time.timeZone = timeZone;
      i18n.defaultLocale = locale;
      system.stateVersion = "24.05";
    };

  buildHome = username: { imports }: {
    imports = imports ++ [
      (rootPath + "/common/home/.home-manager.nix")
    ];
    home = {
      username = username;
      homeDirectory = "/home/" + username;
      stateVersion = "24.05";
    };
  };

  dirName = path: with nixpkgs.lib;
      (builtins.elemAt
        (lists.reverseList
          (strings.splitString "/" (toString path))
        )
        0
      );
}
