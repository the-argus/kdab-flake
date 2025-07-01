# This is just cmake wrapped to have a flag telling the build to look for modules inside KDAB's extra-cmake-modules fork. can be overridden by just adding a -DCMAKE_MODULE_PATH= flag when invoking cmake
{
  stdenvNoCC,
  buildPackages,
  cmake,
  emptyDirectory,
  ...
}: let
  kdextra-cmake-modules = builtins.fetchGit {
    url = "ssh://codereview.kdab.com:29418/kdab/extra-cmake-modules";
    rev = "890af7af29afbdf838039d9053956f2db70c4c55";
  };
in
  stdenvNoCC.mkDerivation {
    name = "kdcmake";
    src = emptyDirectory;
    nativeBuildInputs = [buildPackages.makeWrapper];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      ln -sf ${cmake}/bin/cmake $out/bin/
      ln -sf ${cmake}/share $out/share
      ln -sf ${cmake}/nix-support $out/nix-support
      wrapProgram $out/bin/cmake --add-flags "-DCMAKE_MODULE_PATH=${kdextra-cmake-modules}/modules"
    '';
  }
