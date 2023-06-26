{
  stdenv,
  fetchFromGitHub,
  cmake,
  ...
}:
stdenv.mkDerivation rec {
  pname = "kdbindings";
  version = "1.0.3";
  src = fetchFromGitHub {
    repo = pname;
    owner = "KDAB";
    rev = "v${version}";
    hash = "sha256-soyQ44x6qlme0xowb2L27gdQyYWImErMpeKQsaiJsXA=";
  };

  buildInputs = [cmake];
}
