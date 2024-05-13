{
  waylandSupport ? true,
  debug ? false,
  lib,
  stdenv,
  cmake,
  pkg-config,
  fetchFromGitHub,
  spdlog,
  KDAB,
  spdlog_setup ? KDAB.software.spdlog_setup,
  kdbindings ? KDAB.software.kdbindings,
  mio ? KDAB.software.mio,
  libxkbcommon,
  xorg,
  wayland-scanner,
  wayland-protocols,
  wayland,
  libffi,
  libglvnd,
  ...
}: let
  whereami = fetchFromGitHub {
    repo = "whereami";
    owner = "gpakosz";
    rev = "e4b7ba1be0e9fd60728acbdd418bc7195cdd37e7";
    hash = "sha256-nXgkIbQnV7a/4RlahFNEHkGyy2BIfTny2GkJ1DKa2BA=";
  };
in
  stdenv.mkDerivation rec {
    name = "kdutils";
    src = fetchFromGitHub {
      repo = name;
      owner = "KDAB";
      rev = "88daab190762040da8927fe1cd8d72176ad278b6";
      hash = "sha256-U8xmhhjGIZ3DtNfs1OmQwY8+1q+2fGVCasyf2hdMunA=";
    };

    buildInputs = [
      cmake
      mio
    ];

    inherit debug;
    dontStrip = debug;

    cmakeFlags = [
      "-Dwhereami_SOURCE_DIR=${whereami}"
      "-DKDUTILS_BUILD_TESTS=OFF"
      (lib.optionalString debug "-DCMAKE_BUILD_TYPE=Debug")
    ];

    nativeBuildInputs =
      propagatedBuildInputs
      ++ [
        spdlog_setup
        libffi
        libglvnd
      ]
      ++ (lib.lists.optionals waylandSupport [
        pkg-config
      ]);

    propagatedBuildInputs =
      [
        spdlog
        kdbindings
        libxkbcommon
        xorg.libxcb
        xorg.libXau
        xorg.libXdmcp
      ]
      ++ (lib.lists.optionals waylandSupport [
        wayland-scanner
        wayland-protocols
        wayland
      ]);

    patches = [./remove-whereami-fetchcontent.patch];
  }
