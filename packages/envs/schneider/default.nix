{
  pkgs,
  KDAB,
  vulkan-sdk ? KDAB.software.vulkan-sdk,
  qt-env ? KDAB.software.qt-env,
  extraPackages ? [],
  ...
}:
qt-env.override rec {
  qtPackages = with pkgs.qt6; [
    qtbase
    qtdeclarative
    qt5compat
  ];

  packages = with pkgs;
    [
      # build tools
      gnumake
      cmake
      wayland
      wayland-protocols
      wayland-scanner
      pkg-config
      vulkan-validation-layers
      vulkan-sdk
    ]
    ++ qtPackages
    ++ extraPackages;

  shellHook = ''
    export VULKAN_SDK="${vulkan-sdk}"
  '';
}
