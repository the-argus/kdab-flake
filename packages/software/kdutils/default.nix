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
  libxkbcommon,
  xorg,
  wayland-scanner,
  wayland-protocols,
  wayland,
  libffi,
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
      rev = "f906c58f6e44f4eb5932a677e613397f393e67a7";
      hash = "sha256-pca/+ddPqU8QCIvY9hmfrwk240Y+x2Qjn6G3N6G+rJo=";
    };

    # sanity check to make sure wayland was found
    prePatch = lib.optionalString waylandSupport ''
      substituteInPlace src/KDGui/CMakeLists.txt \
          --replace "QUIET" "REQUIRED"
    '';

    buildInputs = [cmake];

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

    patches = [./remove-fetchcontent.patch];
  }
