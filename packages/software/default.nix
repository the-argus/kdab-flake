{callPackage, ...}: rec {
  qtkeychain = callPackage ./qtkeychain {};
  charm = callPackage ./charm {};
  kdab-viewer = callPackage ./kdab-viewer {};
  doxybook2 = callPackage ./doxybook2 {};
  inja = callPackage ./inja {};
  vulkan-sdk = callPackage ./vulkan-sdk {};
  qt-env = callPackage ./qt-env {};
  kdbindings = callPackage ./kdbindings {};
  kdutils = callPackage ./kdutils {};
  kdgpu = callPackage ./kdgpu {};
  vulkan-memory-allocator = callPackage ./vulkan-memory-allocator {};
  slint = callPackage ./slint {};
  slint-bin = callPackage ./slint-bin {};
  spdlog_setup = callPackage ./spdlog_setup {};
  gammaray-qt6 = callPackage ./gammaray-qt6 {};
  mio = callPackage ./mio {};
}
