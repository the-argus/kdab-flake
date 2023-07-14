{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  wayland,
  elfutils,
  libbfd,
}:
stdenv.mkDerivation rec {
  pname = "gammaray";
  version = "2.11.3";
  src = fetchFromGitHub {
    owner = "KDAB";
    repo = pname;
    rev = "8f2dfd4eb2aa58885f59405c5a247de100c2a41c";
    hash = "sha256-qhhtbNjX/sPMqiTPRW+joUtXL9FF0KjX00XtS+ujDmQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs =
    [
      wayland
      elfutils
      libbfd
    ]
    ++ (with qt6; [
      qtbase
      qt5compat
      qtdeclarative
    ]);

  cmakeFlags = [
    "-DQT_VERSION_MAJOR=6"
    "-DGAMMARAY_USE_PCH=OFF"
  ];

  meta = with lib; {
    description = "A software introspection tool for Qt applications developed by KDAB";
    homepage = "https://github.com/KDAB/GammaRay";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [rewine];
  };
}
