{
  stdenv,
  fetchFromGitHub,
  cmake,
  fmt,
  ...
}:
stdenv.mkDerivation rec {
  name = "spdlog_setup";
  src = fetchFromGitHub {
    repo = name;
    owner = "jjcasmar";
    rev = "bf46b966ef4b2f4aca67e7b69c64c2d2def65d94";
    hash = "sha256-M17+EzjE/r9ZbIR9Qt6J7vu/BjWvFlmz2QEJy43ryvA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    fmt
  ];

  buildInputs = [cmake];
}
