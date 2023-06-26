{
  pkgs,
  KDAB,
  kdutils ? KDAB.software.kdutils,
  mkShell,
  ...
}:
mkShell
{
  packages = with pkgs; [
    # build tools
    gnumake
    cmake
    pkg-config

    # utils
    gdb
    valgrind

    # deps
    fontconfig

    # mecaps deps
    curl
    (kdutils.override {debug = true;})
    rustc
    corrosion
    libxkbcommon
    xorg.libxcb

    # slint
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    libGLU
    vulkan-loader
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.fontconfig.lib}/lib:$LD_LIBRARY_PATH

    # only works for qtbase??
    export QT_PLUGIN_PATH=${pkgs.qt5.qtbase}/lib/qt-5.15.9/plugins:$QT_PLUGIN_PATH
    # qtsvg is different...
    export QT_PLUGIN_PATH=${pkgs.qt5.qtsvg}/lib:$QT_PLUGIN_PATH

    # need qt for the binary distribution to be happy, but I don't want to use it
    export SLINT_NO_QT=1
  '';
}
