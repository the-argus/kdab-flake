{
  pkgs,
  KDAB,
  vulkan-sdk ? KDAB.software.vulkan-sdk,
  qt-env ? KDAB.software.qt-env,
  kdutils ? KDAB.software.kdutils,
  glm,
  # tends to cause problems, make overridable
  extraPackages ? [],
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
      kdutils
    ]
    ++ [glm]
    ++ qtPackages
    ++ extraPackages;

  shellHook = ''
    export VULKAN_SDK="${vulkan-sdk}"
  '';
}
