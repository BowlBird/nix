ret
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;

  # Define the function
  convert = systems: lib.flatten
					(map 
						(system: (map
							(user: {inherit (system) system; inherit user;}) 
							system.users
						)) 
						systems
					); 

  # Example input list
  inputList = [ { system = "nest"; users = ["bowlbird" "test"]; } ];

  # Apply the function
  outputList = convert inputList;
in
  outputList
