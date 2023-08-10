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
      rev = "df850430513fe868712b0308180b52ab45879e89";
      sha256 = "0i8jianfz3nkawz4lr6dk2hrm5w1zvp8736mnqbm0i9nkd917m0q";
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
