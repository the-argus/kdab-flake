{
  stdenv,
  fetchFromGitHub,
  cmake,
  KDAB,
  vulkan-sdk ? KDAB.software.vulkan-sdk,
  ...
}: let
  offDefines = [
    "VMA_RECORDING_ENABLED"
    "VMA_USE_STL_CONTAINERS"
    "VMA_STATIC_VULKAN_FUNCTIONS"
    "VMA_DYNAMIC_VULKAN_FUNCTIONS"
    "VMA_DEBUG_ALWAYS_DEDICATED_MEMORY"
    "VMA_DEBUG_INITIALIZE_ALLOCATIONS"
    "VMA_DEBUG_GLOBAL_MUTEX"
    "VMA_DEBUG_DONT_EXCEED_MAX_MEMORY_ALLOCATION_COUNT"
  ];
in
  stdenv.mkDerivation
  {
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

    cmakeFlags =
      (builtins.map (flag: "-D${flag}=OFF") offDefines)
      ++ [
        "-DPOSITION_INDEPENDENT_CODE=ON"
      ];
  }
