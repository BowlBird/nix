{ nixpkgs, home-manager, rootPath, ... }: rec {

  helpers = {
    childrenNameList = path:
      (nixpkgs.lib.mapAttrsToList
        (name: value: name)
        (builtins.readDir path)
      );

    dirName = path: with nixpkgs.lib;
      (builtins.elemAt
        (lists.reverseList
          (strings.splitString "/" (toString path))
        )
        0
      );

    hostDir = host: ./host + "/${host}";

    homeDir = host: home: ./host + "/${host}/${home}";

    moduleDir = module: ./common + "/${module}";
  };

  build = args: with helpers; let
    hosts = childrenNameList ./host;
    users =
      (map
        (host: {
          system = host;
          users = childrenNameList (hostDir host + "/home");
        })
        hosts
      );

    buildHosts = hosts: args: builtins.listToAttrs
      (map
        (host: {
          name = host;
          value = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = args;
            modules = [(hostDir host)];
          };
        })
        hosts
      );

    buildHomes = hosts: args: with nixpkgs.lib; let
      hostDefinitions = flatten
        (map
          (host: (map
            (user: {inherit (host) host; inherit user;})
            host.users
          ))
          hosts
        );
      in
        builtins.listToAttrs
          (map
            (definition: let
              inherit (definition) user host;
            in {
              name = "${user}@${host}";
              value = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.x86_64-linux;
                extraSpecialArgs = args;
                modules = [(userDir host user)];
              };
            })
            hostDefinitions
          );
    in {
      nixosConfigurations = buildHosts hosts args;
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


  buildHost = hostPath: { imports, timeZone, locale }: with helpers;
    let
      hostName = dirName hostPath;
      getUsers = { }: builtins.listToAttrs
        (map
          (user: {
            name = user;
            value = let
                settings = import (rootPath + "/host/${hostName}/home/${user}/user.nix") { };
              in {
                isNormalUser = true;
                extraGroups = settings.groups;
              };
          })
          (nixpkgs.lib.mapAttrsToList
            (name: value: name)
            (builtins.readDir (rootPath + "/host/${hostName}/home"))
          )
        );
    in {
      imports = imports ++ [
        (rootPath + "/common/host-programs/.home-manager.nix")
        (rootPath + "/host/${hostName}/hardware-configuration.nix")
      ];
      users.users = getUsers { };
      networking.hostName = hostName;
      time.timeZone = timeZone;
      i18n.defaultLocale = locale;
      system.stateVersion = "24.05";
    };

  buildHome = usernamePath: { imports }: with helpers;
    let
      username = dirName usernamePath;
    in {
      imports = imports ++ [
        (rootPath + "/common/home/.home-manager.nix")
      ];
      home = {
        username = username;
        homeDirectory = "/home/" + username;
        stateVersion = "24.05";
      };
    };

}
