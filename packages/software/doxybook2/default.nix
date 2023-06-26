{
  stdenv,
  fetchFromGitHub,
  cmake,
  fmt,
  catch2,
  nlohmann_json,
  spdlog,
  cxxopts,
  KDAB,
  inja ? KDAB.software.inja,
  ...
}:
stdenv.mkDerivation rec {
  name = "doxybook2";
  src = fetchFromGitHub {
    repo = name;
    owner = "matusnovak";
    rev = "5fa2d091efd1e1e9a6bc84317772ab22a7a5b9b1";
    sha256 = "1dsgsffy8dkkfwvj95hcqj79vwvyvpwfcr297fkn77s6iy963dqc";
  };
  nativeBuildInputs = [cmake];
  buildInputs = [
    fmt
    catch2
    nlohmann_json
    spdlog
    cxxopts
    inja
  ];
}
