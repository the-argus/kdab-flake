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
  libglvnd,
  ...
}: let
  whereami = fetchFromGitHub {
    repo = "whereami";
    owner = "gpakosz";
    rev = "e4b7ba1be0e9fd60728acbdd418bc7195cdd37e7";
    hash = "sha256-nXgkIbQnV7a/4RlahFNEHkGyy2BIfTny2GkJ1DKa2BA=";
  };

  mioTag = "8b6b7d878c89e81614d05edca7936de41ccdd2da";
  mio = fetchFromGitHub {
    repo = "mio";
    owner = "mandreyel";
    rev = mioTag;
    sha256 = "sha256-j/wbjyI2v/BsFz2RKi8ZxMKuT+7o5uI4I4yIkUran7I=";
  };
in
  stdenv.mkDerivation rec {
    name = "kdutils";
    src = fetchFromGitHub {
      repo = name;
      owner = "KDAB";
      rev = "4a6ceafe6c73362299fdf549718f071ecf82c582";
      sha256 = "1iw0pqwsnhx5fpvhgwvg8m3wdq5768wss71v1sd3ib5lwb6zd6km";
    };

    # sanity check to make sure wayland was found
    prePatch = lib.optionalString waylandSupport ''
      substituteInPlace src/KDGui/CMakeLists.txt \
          --replace "QUIET" "REQUIRED"
    '';

    postPatch = ''
      sed -i "/mio/d" cmake/dependencies.cmake || (exit 0)
      sed -i "/fetchcontent_declare\(/d" cmake/dependencies.cmake || (exit 0)
      sed -i "/${mioTag}/d" cmake/dependencies.cmake || (exit 0)
    '';

    buildInputs = [cmake];

    inherit debug;
    dontStrip = debug;

    cmakeFlags = [
      "-Dwhereami_SOURCE_DIR=${whereami}"
      "-Dmio_SOURCE_DIR=${mio}"
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

    patches = [./remove-fetchcontent.patch];
  }
