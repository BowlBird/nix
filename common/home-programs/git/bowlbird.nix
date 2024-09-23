{ ... }: {
  programs.git = {
  	enable = true;
  	userName = "bowlbird";
    userEmail = "bowlbirdcontact@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
