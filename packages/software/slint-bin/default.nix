{
  lib,
  stdenv,
  patchelf,
  fontconfig,
  qt5,
  libcxx,
  ...
}:
stdenv.mkDerivation {
  pname = "slint";
  version = "v1.0.2";
  src = fetchTarball {
    url = "https://github.com/slint-ui/slint/releases/download/v1.0.2/Slint-cpp-1.0.2-Linux-x86_64.tar.gz";
    sha256 = "sha256:1ns2m7yd0y5bnydw9nvw5a8bs3f2hy6y4anb040v69a6nfm2jxbk";
  };

  dontBuild = true;
  installPhase = ''
    mkdir $out -p
    mv * $out
  '';

  postFixup = let
    libpath = lib.makeLibraryPath (
      (with qt5; [qtbase qtsvg])
      ++ [fontconfig.lib libcxx]
    );
  in ''
    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 \
        --add-rpath ${libpath} \
        $out/bin/slint-compiler
    patchelf --set-rpath ${libpath} \
        $out/lib/libslint_cpp.so
  '';

  dontWrapQtApps = true;

  buildInputs = [
    patchelf
  ];

  nativeBuildInputs = [
    qt5.qtbase
    qt5.qtsvg
  ];
}
