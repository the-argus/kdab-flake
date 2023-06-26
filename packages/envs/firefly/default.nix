{
  pkgs,
  KDAB,
  vulkan-sdk ? KDAB.software.vulkan-sdk,
  qt-env ? KDAB.software.qt-env,
  ...
}:
qt-env.override rec {
  qtPackages = with pkgs.qt6; [
    qtbase
    qtdeclarative
    qt5compat
    qt3d
  ];

  packages = with pkgs;
    [
      # build tools
      qt6.qmake
      gnumake
      cmake
      wayland
      wayland-protocols
      wayland-scanner
      pkg-config
      vulkan-validation-layers
      vulkan-sdk
      glfw
      glm
    ]
    ++ qtPackages;

  shellHook = ''
    export VULKAN_SDK="${vulkan-sdk}"
  '';
}
