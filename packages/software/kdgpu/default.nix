{
  debug ? false,
  docs ? false,
  stdenv,
  lib,
  cmake,
  pkg-config,
  # fetchFromGitHub,
  KDAB,
  kdutils ? KDAB.software.kdutils,
  doxybook2 ? KDAB.software.doxybook2,
  vulkan-sdk ? KDAB.software.vulkan-sdk,
  vulkan-memory-allocator ? KDAB.software.vulkan-memory-allocator,
  #debug only
  vulkan-validation-layers,
  # docs only
  doxygen,
  python311Packages,
  ...
}:
stdenv.mkDerivation rec {
  name = "kdgpu";
  # src = fetchFromGitHub {
  #   repo = name;
  #   owner = "KDAB";
  #   rev = "5af107204da6868e53519f2fa0b5b080d1197da7";
  #   sha256 = "sha256-BiMkkKIkFGHeQloqy4/IBs650BC5yA/GYH9fAQEsx50=";
  # };

  # NOTE: changes that are needed for this to build are not yet on github mirror
  src = builtins.fetchGit {
    url = "ssh://codereview.kdab.com:29418/kdab/toy-renderer";
    rev = "5a3710ac5c2a4cd1ccd2ce57eb800239bd685303";
  };

  buildInputs = [
    cmake
    pkg-config
  ];

  inherit debug;
  dontStrip = debug;

  cmakeFlags = [
    "-DKDGPU_BUILD_EXAMPLES=OFF"
    "-DKDGPU_BUILD_EXTRAS=OFF"
    "-DKDGPU_BUILD_TESTS=OFF"
    (lib.optionalString debug "-DCMAKE_BUILD_TYPE=Debug")
    (lib.optionalString docs "-DKDGPU_DOCS=ON")
  ];

  # kdgpu has different naming conventions? the name must be changed inside the
  # lunarg vulkan sdk or something
  postPatch = ''
    sed -i "s/vulkan-memory-allocator/VulkanMemoryAllocator/g" cmake/dependencies/vulkan_memory_allocator.cmake
    sed -i "s/vulkan-memory-allocator/VulkanMemoryAllocator/g" src/KDGpu/CMakeLists.txt
  '';

  VULKAN_SDK = "${vulkan-sdk}";

  nativeBuildInputs =
    [
      kdutils
      vulkan-sdk
      vulkan-memory-allocator
    ]
    ++ (lib.lists.optionals docs [
      doxybook2
      doxygen
      python311Packages.mkdocs
      python311Packages.mkdocs-material
      python311Packages.mkdocs-material-extensions
    ])
    ++ (lib.lists.optionals debug [
      vulkan-validation-layers
    ]);
}
