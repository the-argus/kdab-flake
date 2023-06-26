{
  stdenvNoCC,
  buildPackages,
  qtPackages,
  qt6,
  qtdeclarative ? qt6.qtdeclarative,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "qmllint-wrapper";
  src = qtdeclarative;

  nativeBuildInputs = [buildPackages.makeWrapper];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    ln -sf ${qtdeclarative}/bin/qmllint $out/bin/

    wrapperArgs=()

    for pkg in ${builtins.concatStringsSep " " (map (pkg: "\"${pkg}\"") qtPackages)}; do
      qmlDir="$pkg/lib/qt-6/qml"
      if [ ! -d $qmlDir ]; then
        continue
      fi
      wrapperArgs+=("--add-flags")
      wrapperArgs+=("-I $qmlDir")
      for qmlPlugin in $qmlDir/*; do
        qmldir="$qmlPlugin/qmldir"
        if [ ! -e $qmldir ]; then
          continue
        fi
        wrapperArgs+=("--add-flags")
        wrapperArgs+=("-i $qmldir")
      done
    done

    wrapProgram $out/bin/qmllint "${"$\{wrapperArgs[@]}"}"
  '';
}
