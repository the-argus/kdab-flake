{
  mkShell,
  qt6,
  # qt5,
  qtVersion ? 6,
  qtPackages ? (
    if qtVersion == 6
    then
      (with qt6; [
        qtdeclarative
        qt5compat
        qtbase
      ])
    else if qtVersion == 5
    # TODO: qt5 support
    then []
    else (builtins.abort "Qt version ${qtVersion} not valid, use either 5 or 6.")
  ),
  packages ? [],
  shellHook ? "",
  ...
}:
mkShell {
  packages = packages ++ qtPackages;

  shellHook =
    shellHook
    + (
      if qtVersion == 6
      then ''
        for pkg in ${builtins.concatStringsSep " " (map (pkg: "\"${pkg}\"") qtPackages)}; do
          local pluginDir="$pkg/lib/qt-6/plugins"
          if [ -d "$pluginDir" ]; then
            export QT_PLUGIN_PATH="$pluginDir:$QT_PLUGIN_PATH"
          fi

          local qmlDir="$pkg/lib/qt-6/qml"
          if [ -d "$qmlDir" ]; then
            export QML2_IMPORT_PATH="$qmlDir:$QML2_IMPORT_PATH"
          fi
        done
      ''
      else if qtVersion == 5
      then (builtins.abort "I haven't set up qt5 yet, sorry.")
      else (builtins.abort "How did you even make this happen? Open an issue or something I guess.")
    );
}
