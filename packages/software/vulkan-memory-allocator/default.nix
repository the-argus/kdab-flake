{
  stdenv,
  fetchFromGitHub,
  cmake,
  KDAB,
  vulkan-sdk ? KDAB.software.vulkan-sdk,
  ...
}:
stdenv.mkDerivation {
  pname = "vulkan-memory-allocator";
  version = "unstable";

  src = fetchFromGitHub {
    repo = "VulkanMemoryAllocator";
    owner = "GPUOpen-LibrariesAndSDKs";
    rev = "29d492b60c84ca784ea0943efc7d2e6e0f3bdaac";
    hash = "sha256-1YOZ3kZBoxvDjPsJ2PiyR0l5zfkugtcPC6Wg3TuUnCQ=";
  };

  buildInputs = [
    cmake
  ];

  nativeBuildInputs = [
    vulkan-sdk
  ];

  VULKAN_SDK = "${vulkan-sdk}";

  cmakeFlags = [
    "-DVMA_RECORDING_ENABLED=OFF"
    "-DVMA_USE_STL_CONTAINERS=OFF"
    "-DVMA_STATIC_VULKAN_FUNCTIONS=OFF"
    "-DVMA_DYNAMIC_VULKAN_FUNCTIONS=OFF"
    "-DVMA_DEBUG_ALWAYS_DEDICATED_MEMORY=OFF"
    "-DVMA_DEBUG_INITIALIZE_ALLOCATIONS=OFF"
    "-DVMA_DEBUG_GLOBAL_MUTEX=OFF"
    "-DVMA_DEBUG_DONT_EXCEED_MAX_MEMORY_ALLOCATION_COUNT=OFF"
  ];
}
