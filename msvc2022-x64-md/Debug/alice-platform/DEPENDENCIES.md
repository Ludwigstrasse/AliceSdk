# Alice 平台 Windows Debug 构建依赖

| 属性 | 内容 |
| --- | --- |
| 制品名称 | `alice-platform` |
| 工具链 | Visual Studio 2022，MSVC 19.41.34120，x64，动态 MSVC 运行库 |
| 构建配置 | Debug；ICU 使用同工具链的发布库名称与 Alice 现有链接合同一致 |
| AliceSdk 基线 | `27aa89bc9e03e768f817d19c8584a2d35120cfa5` |
| 首次迁移来源 | `Ludwigstrasse/SolidDesigner@995a7e77755877a6d683c34ab3845f754f5339dc` |
| 第三方构建定义 | `Ludwigstrasse/AliceThirdParty@2539f2d1ebf3a34cfb9598ec4ad21d03b285c171` |
| vcpkg 基线 | `15e5f3820f0370f1ba7150853762cec0688cd396` |
| 可复现构建输入 | `build-inputs/vcpkg.json`、`build-inputs/triplets/x64-windows-alice.cmake` |
| 目标使用方 | Alice 独立 Windows 持续集成与固定版本产品构建 |
| 完整性清单 | `SHA256SUMS` |

## 制品范围

| 依赖 | 固定版本 | 文件范围 | Alice 用途 | 许可证文件 |
| --- | --- | --- | --- | --- |
| pugixml | 1.13 | `pugixml/` | XML 配置、插件与产品信息读取 | `licenses/pugixml/LICENSE.md` |
| spdlog | 1.15.3 | `spdlog/CMakeLists.txt`、`spdlog/include/`、`spdlog/src/`、`spdlog/cmake/`、`spdlog/LICENSE` | 平台诊断日志；只保存 Alice 编译所需源码闭包 | `licenses/spdlog/LICENSE` |
| RapidJSON | 1.1.0 | `3rdParty/include/rapidjson/include/rapidjson/` | 测试协议和工作台设置 | `licenses/rapidjson/license.txt` |
| ICU | 74.2，vcpkg port revision 6 | `3rdParty/include/unicode/`、`3rdParty/lib/icu*.lib`、`3rdParty/bin/icu*74.dll` | Unicode 转换、区域设置和测试运行 | `licenses/icu/LICENSE` |
| brotli | 1.2.0 | `3rdParty/runtime/msvc2022-x64-md/Debug/occt/brotli*.dll` | OCCT 传递运行依赖 | `licenses/brotli/LICENSE` |
| bzip2 | 1.0.8，vcpkg port revision 6 | `3rdParty/runtime/msvc2022-x64-md/Debug/occt/bz2d.dll` | OCCT 传递运行依赖 | `licenses/bzip2/LICENSE` |
| FreeType | 2.13.3 | `3rdParty/runtime/msvc2022-x64-md/Debug/occt/freetyped.dll` | OCCT 字体运行依赖 | `licenses/freetype/LICENSE.TXT` |
| hwloc | 2.11.2 | `3rdParty/runtime/msvc2022-x64-md/Debug/occt/hwloc-15.dll` | OCCT 传递运行依赖 | `licenses/hwloc/COPYING` |
| libpng | 1.6.54 | `3rdParty/runtime/msvc2022-x64-md/Debug/occt/libpng16d.dll` | OCCT 图像运行依赖 | `licenses/libpng/LICENSE` |
| oneTBB | 2022.3.0 | `3rdParty/runtime/msvc2022-x64-md/Debug/occt/tbb*_debug.dll` | OCCT 并行运行依赖 | `licenses/tbb/LICENSE.txt` |
| zlib | 1.3.1 | `3rdParty/runtime/msvc2022-x64-md/Debug/occt/zlibd1.dll` | OCCT 压缩运行依赖 | `licenses/zlib/LICENSE` |
| OCCT | 8.0.0 rc3，开发标识 `c47d9c06b5` | 同级目录 `../occt/` | 几何内核、三维显示和 Alice OCCT 适配层 | `licenses/occt/LICENSE_LGPL_21.txt`、`licenses/occt/OCCT_LGPL_EXCEPTION.txt` |

## 来源链

首次迁移从 `SolidDesigner@995a7e77755877a6d683c34ab3845f754f5339dc` 取得已经通过产品构建的依赖集合。迁移只建立 Alice 独立构建所需的最小集合，不使 SolidDesigner 成为 Alice 或 AliceSdk 的持续构建输入。

| 制品内容 | 迁移来源中的原始相对路径 | 当前处理 |
| --- | --- | --- |
| pugixml | `Externals/pugixml/` | 保持 1.13 源文件集合 |
| spdlog | `Externals/spdlog/` | 固定 1.15.3 后裁剪为 CMake 构建闭包 |
| RapidJSON | `Externals/3rdParty/include/rapidjson/include/rapidjson/` | 保持 1.1.0 公共头文件集合 |
| ICU | `Externals/3rdParty/include/unicode/`、`Externals/3rdParty/lib/icu*.lib`、`Externals/3rdParty/bin/icu*74.dll` | 头文件逐字节一致；库与动态库由本发布单元的固定构建输入重新产生 |
| OCCT 传递动态库 | `Externals/3rdParty/runtime/msvc2022-x64-md/Debug/occt/` | 由本发布单元的固定构建输入重新产生 |
| OCCT 开发包 | AliceSdk `main@27aa89bc9e03e768f817d19c8584a2d35120cfa5` 的 `msvc2022-x64-md/Debug/occt/` | 本发布单元不修改 |

AliceThirdParty 提交固定 OCCT 源码、vcpkg 源码和导出规则。本目录的 `build-inputs/vcpkg.json` 固定实际重建的依赖版本；`x64-windows-alice.cmake` 固定 x64、动态运行库、动态链接和 `/PDBALTPATH:%_PDB%`。该链接选项只在 CodeView 中保存 PDB 文件名，避免把构建机盘符、工作区或产品路径写入可复用动态库。

## 受控重建方法

重建必须使用 AliceThirdParty 固定提交中的 `extern/vcpkg/vcpkg.exe`，并把本发布单元的 `build-inputs` 目录作为清单与 overlay triplet 输入。安装根目录、构建目录、包目录和下载目录可以位于任意隔离工作目录；它们不构成制品身份。必须关闭旧二进制缓存复用，使 PDB 路径策略参与本次链接。

```powershell
extern/vcpkg/vcpkg.exe install `
  --triplet x64-windows-alice `
  --overlay-triplets=<alice-platform>/build-inputs/triplets `
  --x-manifest-root=<alice-platform>/build-inputs `
  --x-install-root=<isolated-work>/installed `
  --x-buildtrees-root=<isolated-work>/buildtrees `
  --x-packages-root=<isolated-work>/packages `
  --downloads-root=<isolated-work>/downloads `
  --binarysource=clear
```

发布时只从 `installed/x64-windows-alice/` 取得下表列出的文件。ICU 取 `bin/` 与 `lib/` 中的发布名文件，以保持 Alice 现有链接名称；OCCT 传递动态库取 `debug/bin/`。不得把整个 vcpkg 安装树复制进 AliceSdk。

## 二进制来源记录

下表中的重建输出路径相对于隔离的 vcpkg 安装根目录 `installed/x64-windows-alice/`。大小和摘要对应本发布单元实际分发的文件。

| 发布路径 | 重建输出相对路径 | 字节数 | SHA-256 |
| --- | --- | ---: | --- |
| `3rdParty/bin/icudt74.dll` | `bin/icudt74.dll` | 30786048 | `e44f146c0542e158a47cebbacf83ce2c37c9ed306b598e6e65bce720e6915bdd` |
| `3rdParty/bin/icuin74.dll` | `bin/icuin74.dll` | 2644480 | `a06c0d1901c7cf971aaaffe0c1480e045328286e50cd413bc3b5a1642597d5a8` |
| `3rdParty/bin/icuio74.dll` | `bin/icuio74.dll` | 53248 | `88338c9c6acb159a0ff3da71cfb6e7b4fa059c15dd9c2cdc2b4dcd6062e86fd1` |
| `3rdParty/bin/icuuc74.dll` | `bin/icuuc74.dll` | 1784832 | `cd87ed6759424d1f34e11dbf9c10282118db4edcb6fe547324bf5f1df2c9b775` |
| `3rdParty/lib/icudt.lib` | `lib/icudt.lib` | 1686 | `b9a9e4dc4b31858866faca819d405fd4555ec6638f29fc5f59b3d9c15c9967b1` |
| `3rdParty/lib/icuin.lib` | `lib/icuin.lib` | 2922452 | `30083e97cd90afa9a4b9fcd40a584a84bb67996e9bee15a5ecbd09d87373b724` |
| `3rdParty/lib/icuio.lib` | `lib/icuio.lib` | 12584 | `20ffbee2d4576077227372c9d505243345df65912b866a0f66ce64bc138e2542` |
| `3rdParty/lib/icuuc.lib` | `lib/icuuc.lib` | 1082678 | `16e370d589fc7f992229cd0090dad939a7e198473e9eaa3d52aa638360a03c83` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/brotlicommon.dll` | `debug/bin/brotlicommon.dll` | 208384 | `cf55002ef39975e5d9f00f2bf3b345a5c92d297ddba275dbe3158b74c7dc97db` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/brotlidec.dll` | `debug/bin/brotlidec.dll` | 132096 | `47536467c1c7c7dfcfdefa56c677e6c5a8a7a2627da50be8543781b27202bfc4` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/brotlienc.dll` | `debug/bin/brotlienc.dll` | 947200 | `0e45d1c1545565c21a317907fe611eaa9c5348962e0b4d59969b11925a8f9968` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/bz2d.dll` | `debug/bin/bz2d.dll` | 190464 | `2b2c7ece3e9934c028245bdf48f49c28327121c6b20926cd473f5221578c7d6a` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/freetyped.dll` | `debug/bin/freetyped.dll` | 1539072 | `5cad02046615c06212186c5b312948f3db7002d83e5dbd9d002afcbe7bc8243c` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/hwloc-15.dll` | `debug/bin/hwloc-15.dll` | 579072 | `3eeb9b0c657fa4fefeda0a8545cfba787861dd063adceb98d36f4e87bdba23a3` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/libpng16d.dll` | `debug/bin/libpng16d.dll` | 425984 | `1a15240d8957070b9a66bc9644d513f15aca3c314fcb59e06d1c3e5a663b4f41` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/tbb12_debug.dll` | `debug/bin/tbb12_debug.dll` | 1152000 | `419c228d95ad049b4f68c67616e1716fc85fe9ff6b4b0ee090fcd21152c595d0` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/tbbmalloc_debug.dll` | `debug/bin/tbbmalloc_debug.dll` | 326656 | `b3e1401588242b59c6f1b758af2162c402fc3e589e5e26b458e29fac40dd68d4` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/tbbmalloc_proxy_debug.dll` | `debug/bin/tbbmalloc_proxy_debug.dll` | 109056 | `60a48d02cf5adffd4079a9483e81961296b8edd93067e06dac8eadf9cd4b1780` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/zlibd1.dll` | `debug/bin/zlibd1.dll` | 210432 | `2af7fd1aa9fdac94a518af7110d9b235d4f646f9a90b4f68a637f527c49d5a2e` |

导出名称核对覆盖 ICU 的三个代码动态库和十一项 OCCT 传递动态库。OCCT 传递动态库的新旧导出名称集合完全一致；所有新动态库的导入依赖集合与迁移版本一致。ICU 74.2 port revision 6 与配套头文件、导入库、动态库作为同一个发布单元使用，兼容性由 Alice 的 Visual Studio 2022 完整编译和 CTest 门禁确认。

## 目录合同

Alice 持续集成把固定 AliceSdk 提交直接稀疏检出到 `Externals/3rdParty/sdk`，校验 `alice-platform/SHA256SUMS` 后，把 `pugixml` 与 `spdlog` 分别复制到 Alice 工作区 `Externals`，并把 `alice-platform/3rdParty` 下的 `include`、`lib`、`bin`、`runtime` 分别复制到 `Externals/3rdParty`。`occt` 自检出开始即位于 `Externals/3rdParty/sdk/msvc2022-x64-md/Debug/occt`，不再执行第二次复制。

制品只对应 Visual Studio 2022、x64、动态 MSVC 运行库和 Debug 配置。其他体系结构、运行库或 Release 配置必须使用独立目录和独立完整性清单，不能覆盖本目录文件。

## 更新规则

依赖更新先固定 AliceThirdParty 源码和 vcpkg 基线，再更新本发布单元的构建输入，生成新的 AliceSdk 候选提交。候选必须更新版本、来源、许可证、二进制路径、大小和逐文件摘要，并扫描动态库中是否存在构建机绝对路径。Alice 使用新候选完成 Visual Studio 2022 编译与完整 CTest 后才能升级固定引用。已发布提交保持不可变，用于复现历史构建和回退。
