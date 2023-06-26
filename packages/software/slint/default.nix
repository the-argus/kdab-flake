{
  fetchFromGitHub,
  rustPlatform,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "slint";
  version = "1.0.2";
  src = fetchFromGitHub {
    repo = pname;
    rev = "v${version}";
    owner = "slint-ui";
    hash = "sha256-WlFc3CjzhlNvVPkV9f809IXatSAkG00W8bUc6BlM9I8=";
  };
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ft5336-0.1.0" = "sha256-XLRhbkVnZrPGeO86nA4rUttKRfu/zWzjL7hDG53Lraw=";
    };
  };

  buildNoDefaultFeatures = true;

  buildInputs = [];

  patches = [
    ./no-fetchcontent.patch
    ./no-screenshot-test.patch
  ];
}
