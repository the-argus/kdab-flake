# kdab-flake

Packaging and development environments for various pieces of KDAB software.

## Contents

What this flake includes.

### Software

- Charm
- Vulkan SDK
- Doxybook 2
- Inja
- KDBindings
- KDUtils
- Slint (Source distribution)
- Slint (Binary distribution)
- ``spdlog_setup``

### Development Environments

- KDGpu
- Firefly
- Project MECAPS
- Generic Qt6 QML Environment

## Known Issues

- the `slint` source package does not build.
- the `slint-bin` package builds but requires your `QT_PLUGIN_PATH` to
  include the directories with the `qtbase` and `qtsvg` plugins.
- `qt-env` only supports qt 6 at the moment.
- `qmllint-wrapper` is intended to fix a problem between qmllint and neovim
  lspconfig where qmllint can't find any of the imports. It does not work for me.
- KDABViewer fails at the linking stage.
