{
  stdenv,
  lib,
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
      rev = "eaf8fc27eeadf6f21b11183651b829e897f01957";
      hash = "sha256-6BmK8jcvynygkWKWK6sqWhDhVyd4xR37oCVfodNyphw=";
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
  # also do environment variable definitions of 0 for all flags
  // (lib.attrsets.genAttrs offDefines (_: 0))
