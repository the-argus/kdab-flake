{
  debug ? false,
  buildTests ? false,
  buildForWayland ? false, # use wayland instead of x11 for presentation
  includeXCB ? true, # if x11 is enabled, optionally enable building with xcb
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libffi,
  wayland-protocols,
  libGL,
  xorg,
  libxcb ? xorg.libxcb,
  libx11 ? xorg.libX11,
  libXxf86vm ? xorg.libXxf86vm,
  libXrandr ? xorg.libXrandr,
  wayland,
  python3Minimal,
  shaderc,
  ...
}: let
  presentationBackend =
    if buildForWayland
    then "wayland"
    else
      (
        if includeXCB
        then "xcb"
        else "xlib"
      );
  presentationDependencies =
    if buildForWayland
    then [wayland]
    else
      ([
          libx11
          libXxf86vm
          libXrandr
        ]
        ++ (lib.lists.optionals includeXCB [libxcb]));
in
  stdenv.mkDerivation rec {
    name = "openxr";
    src = fetchFromGitHub {
      repo = "OpenXR-SDK-Source";
      owner = "KhronosGroup";
      rev = "2e2c7d530bf65f7746f8cf4c1339e16b42aec245";
      hash = "sha256-4p0e4rVxI3/x8AAY/ajG2/o/qWDnxj9ZMH2U7NTTxqo=";
    };

    patches = [
      ./do-not-use-cmake-LIBDIR-in-pcfile.patch
    ];

    cmakeFlags = [
      "-DPRESENTATION_BACKEND=${presentationBackend}"
      (lib.optionalString debug "-DCMAKE_BUILD_TYPE=Debug")
      (lib.optionalString (!buildTests) "-DBUILD_TESTS=OFF")
      (lib.optionalString (!buildTests) "-DBUILD_CONFORMANCE_TESTS=OFF")
    ];

    buildInputs = [
      python3Minimal
      cmake
      pkg-config # their scripts use pkg_search_module
      shaderc
    ];

    propagatedBuildInputs =
      presentationDependencies
      ++ [
        libffi
        wayland-protocols
        libGL
      ];
  }
