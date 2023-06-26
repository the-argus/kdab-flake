{
  callPackage,
  KDAB,
  ...
}: {
  kdgpu = callPackage ./kdgpu {};
  firefly = callPackage ./firefly {};
  mecaps = callPackage ./mecaps {};
  qt6 = KDAB.software.qt-env;
}
