{
  config,
  pkgs,
  lib,
}: let
  # Merge/Concat 2 dotfiles
  mergeDotfile = {
    sharedFile, # Dotfile shared across hosts
    hostFile, # host specific Dotfile
  }: let
    ifExists = file: whatToDo: elseToDo:
      if builtins.pathExists file
      then whatToDo file
      else elseToDo;

    # Nix-Store filename
    filename =
      ifExists hostFile builtins.baseNameOf (ifExists sharedFile builtins.baseNameOf (throw "One of sharedFile or hostFile MUST exist!"));

    fileIsJson = (lib.hasSuffix ".json" filename) || (lib.hasSuffix ".jsonc" filename);
  in
    if fileIsJson
    then let
      shared = builtins.fromJSON (ifExists sharedFile builtins.readFile "{}");
      host = builtins.fromJSON (ifExists hostFile builtins.readFile "{}");
      merged = shared // host;
    in
      pkgs.writeText filename (builtins.toJSON merged)
    else
      pkgs.writeText filename (
        builtins.concatStringsSep "\n\n" (
          builtins.filter (str: str != "") [
            (ifExists sharedFile builtins.readFile "")
            (ifExists hostFile builtins.readFile "")
          ]
        )
      );

  getFiles = dir:
    if ! builtins.pathExists dir
    then []
    else let
      entries = builtins.attrNames (builtins.readDir dir);
    in
      lib.concatMap (
        entry: let
          path = "${dir}/${entry}";
          isDir = path: builtins.pathExists (path + "/.");
        in
          if isDir path
          then
            # recurse and prepend entry as directory prefix
            builtins.map (f: "${entry}/${f}") (getFiles path)
          else [entry]
      )
      entries;
in {
  # Generates a shell script that creates directories and user-owned symlinks
  generateDotfileLinks = {
    sharedDir,
    hostDir,
  }: let
    # Gather all files
    sharedFiles = getFiles sharedDir;
    hostFiles = getFiles hostDir;

    allFiles = lib.unique (sharedFiles ++ hostFiles);

    # Directory list
    dirList = lib.unique (
      builtins.map (
        relPath: let
          dir = builtins.dirOf relPath;
        in
          if dir == "."
          then ""
          else "home/${config.user.username}/${dir}"
      )
      allFiles
    );

    # mkdir commands
    mkdirCmds = lib.filter (dir: dir != "") (builtins.map (dir: "runuser -u ${config.user.username} -- mkdir -p \"${dir}\"") dirList);

    # symlink commands
    symlinkCmds =
      builtins.map (
        relPath: let
          sharedFile = "${sharedDir}/${relPath}";
          hostFile = "${hostDir}/${relPath}";
          merged = mergeDotfile {inherit sharedFile hostFile;};
        in
          # symlink as user
          "runuser -u ${config.user.username} -- ln -sfnT \"${merged}\" \"/home/${config.user.username}/${relPath}\""
      )
      allFiles;

    # Full script text
    scriptText = builtins.concatStringsSep "\n" [
      "set -e"
      (builtins.concatStringsSep "\n" mkdirCmds)
      (builtins.concatStringsSep "\n" symlinkCmds)
    ];
  in
    pkgs.writeShellScript "dotfiles-links" scriptText;
}
