{callPackage, ...}: rec {
  qtkeychain = callPackage ./qtkeychain {};
  charm = callPackage ./charm {inherit qtkeychain;};
  doxybook2 = callPackage ./doxybook2 {};
  inja = callPackage ./inja {};
  vulkan-sdk = callPackage ./vulkan-sdk {};
  qt-env = callPackage ./qt-env {};
  kdbindings = callPackage ./kdbindings {};
  kdutils = callPackage ./kdutils {};
  slint = callPackage ./slint {};
  slint-bin = callPackage ./slint-bin {};
  spdlog_setup = callPackage ./spdlog_setup {};
}
