# Linux x64 Release OCCT SDK

- OCCT version: 8.0.0
- OCCT source commit: c47d9c06b54d8119a308e0fca2507d0a5f26ebcd
- AliceThirdParty build-rule commit: 2539f2d1ebf3a34cfb9598ec4ad21d03b285c171
- Original GitHub Actions cache: occt-sdk-Linux-X64-release-2539f2d1ebf3a34cfb9598ec4ad21d03b285c171
- Platform and configuration: Linux x86-64, Release, shared libraries
- Enabled OCCT integrations: OpenGL, oneTBB, FreeType and zlib
- Export contract: AliceThirdParty/scripts/export-occt-sdk.sh
- Relocation rule: exported helper scripts contain no build-host paths; dependency library directories are supplied by the consumer environment

This release unit originates from the existing SolidDesigner PR #388 cache. Before publication, `bin/env.sh` and `bin/custom_gcc_64.sh` were normalized to remove build-host absolute paths and leave dependency directories consumer-controlled; all other cached files remain unchanged. Consumers must pin the AliceSdk commit and validate SHA256SUMS before configuring CMake.
