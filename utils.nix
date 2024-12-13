{ nixpkgs, home-manager, ... }: rec {
  #home-manager.backupFileExtension = "backup";

  helpers = rec {
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

    homeDir = host: home: hostDir host + "/home/${home}";

    moduleDir = module: ./common + "/${module}";
  };

  build = args: with helpers; let
    hosts = childrenNameList ./host;
    hostHomeList =
      (map
        (host: {
          inherit host;
          homes = childrenNameList (hostDir host + "/home");
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
            (home: {inherit (host) host; inherit home;})
            host.homes
          ))
          hosts
        );
      in
        builtins.listToAttrs
          (map
            (definition: let
              inherit (definition) home host;
            in {
              name = "${home}@${host}";
              value = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.x86_64-linux;
                extraSpecialArgs = args;
                modules = [(homeDir host home)];
              };
            })
            hostDefinitions
          );
    in {
      nixosConfigurations = buildHosts hosts args;
      homeConfigurations = buildHomes hostHomeList args;
    };

  buildImports = imports: with nixpkgs.lib; with helpers; flatten
    (mapAttrsToList
      (name: value: (map
        (module: moduleDir name + "/${module}.nix")
        (value)
      ))
      (imports)
    );


  buildHost = hostPath: { imports, ... }@inputs: with helpers;
    let
      host = dirName hostPath;
      users = builtins.listToAttrs
        (map
          (user: {
            name = user;
            value = let
                settings = import (homeDir host user + "/user.nix") { };
              in {
                isNormalUser = true;
                extraGroups = settings.groups;
              };
          })
          (childrenNameList (hostDir host + "/home"))
        );
    in {
      imports = inputs.imports ++ [
        (moduleDir "host" + "/.home-manager.nix")
        (moduleDir "host" + "/.nix-system.nix")
        (hostDir host + "/hardware-configuration.nix")
      ];
      users = {inherit users;};
      networking.hostName = host;
      i18n.defaultLocale = "en_US.UTF-8";
      system.stateVersion = "24.05";
    };

  buildHome = usernamePath: { imports }: with helpers;
    let
      username = dirName usernamePath;
    in {
      imports = imports ++ [
        (moduleDir "home" + "/.home-manager.nix")
      ];
      home = {
        inherit username;
        homeDirectory = "/home/" + username;
        stateVersion = "24.05";
      };
    };
}
