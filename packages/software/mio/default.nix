{
  stdenv,
  fetchFromGitHub,
  cmake,
  ...
}:
stdenv.mkDerivation {
  pname = "mio";
  version = "2023-08-10";

  src = fetchFromGitHub {
    repo = "mio";
    owner = "mandreyel";
    rev = "8b6b7d878c89e81614d05edca7936de41ccdd2da";
    sha256 = "sha256-j/wbjyI2v/BsFz2RKi8ZxMKuT+7o5uI4I4yIkUran7I=";
  };

  buildInputs = [cmake];
}
