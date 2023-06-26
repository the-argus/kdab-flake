{
  stdenv,
  fetchFromGitHub,
  nlohmann_json,
  cmake,
  ...
}:
stdenv.mkDerivation rec {
  name = "inja";
  version = "3.3.0";
  src = fetchFromGitHub {
    owner = "pantor";
    repo = name;
    rev = "v${version}";
    sha256 = "sha256-h+Fcl4bRpcDiIVu97/jGZIDynRJHTC/SLWP0uk/sRqw=";
  };
  nativeBuildInputs = [cmake];
  buildInputs = [nlohmann_json];
  cmakeFlags = [
    "-DBUILD_BENCHMARK=OFF"
    "-DINJA_BUILD_TESTS=OFF"
    "-DBUILD_TESTING=OFF"
    "-DINJA_EXPORT=OFF"
    "-DINJA_INSTALL=ON"
    "-DINJA_USE_EMBEDDED_JSON=OFF"
  ];
}
