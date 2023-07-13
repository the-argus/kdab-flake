{
  mkShell,
  pkgs,
  doxybook2 ? pkgs.KDAB.software.doxybook2,
  vulkan-sdk ? pkgs.KDAB.software.vulkan-sdk,
  kdutils ? pkgs.KDAB.software.kdutils,
  ...
}:
mkShell {
  packages = with pkgs; [
    gnumake
    cmake
    pkg-config
    gdb
    vulkan-sdk
    vulkan-validation-layers
    doxybook2
    doxygen
    python311Packages.mkdocs
    python311Packages.mkdocs-material
    python311Packages.mkdocs-material-extensions
    wayland
    wayland-protocols
    wayland-scanner
    kdutils
    glfw
    glm
    libxkbcommon
    xorg.libxcb
    xorg.libXau
    xorg.libXdmcp
    libffi
  ];
  shellHook = ''
    export VULKAN_SDK="${vulkan-sdk}"
  '';
}
