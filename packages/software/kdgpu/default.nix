{
  debug ? false,
  docs ? false,
  stdenv,
  lib,
  cmake,
  pkg-config,
  fetchFromGitHub,
  KDAB,
  kdutils ? KDAB.software.kdutils,
  doxybook2 ? KDAB.software.doxybook2,
  vulkan-sdk ? KDAB.software.vulkan-sdk,
  vulkan-memory-allocator ? KDAB.software.vulkan-memory-allocator,
  openxr-loader,
  spdlog,
  #debug only
  vulkan-validation-layers,
  # docs only
  doxygen,
  python311Packages,
  ...
}:
stdenv.mkDerivation rec {
  name = "kdgpu";
  src = fetchFromGitHub {
    repo = name;
    owner = "KDAB";
    rev = "a0d75a4b8233c00f9f658af3f433fe9783db9752";
    sha256 = "sha256-FMdmky6cPTX8IpIwby5+i0Sr5+oA9YM3FOZaipbo1tQ=";
  };

  buildInputs = [
    cmake
    pkg-config
  ];

  inherit debug;
  dontStrip = debug;

  cmakeFlags = [
    "-DKDGPU_BUILD_EXAMPLES=OFF"
    "-DKDGPU_BUILD_KDGPUEXAMPLE=OFF"
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

  propagatedBuildInputs = [
    vulkan-sdk
    vulkan-memory-allocator
    spdlog
    openxr-loader
  ];

  nativeBuildInputs =
    [
      kdutils
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
