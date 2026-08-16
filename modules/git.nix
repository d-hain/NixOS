{
  programs.git = {
    enable = true;
    config = {
      user = {
        email = "d.hain@gmx.at";
        name = "David Hain";
      };
      init.defaultBranch = "master";
      pull.ff = "only";
    };
  };
}
