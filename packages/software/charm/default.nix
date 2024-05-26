{
  stdenv,
  qt6,
  extra-cmake-modules,
  libsodium,
  KDAB,
  kdcmake ? KDAB.software.kdcmake,
  kdab-qtkeychain ? KDAB.software.qtkeychain,
  extraPackages ? [],
  ...
}:
stdenv.mkDerivation {
  name = "charm";
  src = builtins.fetchGit {
    url = "ssh://codereview.kdab.com:29418/Charm.git";
    rev = "d81896861c837fc5e9bd927e2b2a0fa596e63fb1";
  };

  cmakeFlags = [
    "-DBUILD_INTERNAL_QTKEYCHAIN=OFF"
  ];

  patches = [
    ./remove-fetchcontent.patch
    ./remove-changelog.patch
  ];

  buildInputs = [kdcmake qt6.wrapQtAppsHook];

  nativeBuildInputs = with qt6;
    [
      qtbase
      qt5compat
      qttools
      qtscxml
      qtsvg
      qtconnectivity
      kdab-qtkeychain
      qtwayland
      libsodium
      extra-cmake-modules
    ]
    ++ extraPackages;
}
