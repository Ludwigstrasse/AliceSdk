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

AliceThirdParty 提交固定 OCCT 源码、vcpkg 源码和导出规则。本目录的 `build-inputs/vcpkg.json` 固定实际重建的依赖版本；`x64-windows-alice.cmake` 固定 x64、动态运行库、动态链接、确定性编译、C 盘工具链路径映射、`/Brepro` 和 `/PDBALTPATH:%_PDB%`，并明确允许 vcpkg 将 `_CL_` 传入隔离的端口构建环境。`build.ps1` 固定提交核对、隔离目录与 vcpkg 调用，通过 `_CL_` 注入 MSVC 的 `/d1trimfile`，裁剪 D 盘隔离构建目录；脚本同时固定 `LINK` 为 `/Brepro /PDBALTPATH:%_PDB%`，覆盖 ICU `pkgdata` 直接调用链接器的路径。`VCPKG_KEEP_ENV_VARS` 只允许 `_CL_` 和 `LINK` 进入净化后的端口构建环境。MSVC 不同时对 D 盘隔离目录应用 `/pathmap`，确保 Autotools 端口写入 `__FILE__` 的路径能够被完整裁剪。生成的动态库具有可复现链接记录，CodeView 只保存 PDB 文件名，普通字符串和宽字符串均不得包含构建机盘符、工作区、产品路径或 vcpkg 构建目录。

## 受控重建方法

重建必须从干净的 AliceThirdParty 固定提交运行 `build-inputs/build.ps1`。脚本同时核对 vcpkg 固定提交；默认使用该检出中已经生成的 `vcpkg.exe`，也可接收由同一 vcpkg 提交生成的可执行文件，该可执行文件所在的 vcpkg 检出同样必须处于固定提交且没有本地改动。vcpkg 始终通过 `--vcpkg-root` 读取 AliceThirdParty 固定提交中的端口和构建规则。AliceThirdParty、构建根目录、可选下载缓存和可选 vcpkg 可执行文件均使用绝对路径；源码、构建输入、构建目录、下载缓存和 vcpkg 可执行文件不得位于系统盘，构建目录与下载缓存不得包含源码或构建输入目录。构建根目录与下载缓存不构成制品身份。脚本关闭旧二进制缓存复用，并在退出时恢复调用进程原有的 MSVC 与 vcpkg 环境变量。

```powershell
<alice-platform>/build-inputs/build.ps1 `
  -AliceThirdPartyRoot <alice-third-party-2539f2d1> `
  -BuildRoot <isolated-work> `
  -DownloadsRoot <optional-download-cache> `
  -VcpkgExecutablePath <optional-vcpkg-executable-from-15e5f382>
```

发布时只从 `installed/x64-windows-alice/` 取得下表列出的文件。ICU 取 `bin/` 与 `lib/` 中的发布名文件，以保持 Alice 现有链接名称；OCCT 传递动态库取 `debug/bin/`。不得把整个 vcpkg 安装树复制进 AliceSdk。

## 二进制来源记录

下表中的重建输出路径相对于隔离的 vcpkg 安装根目录 `installed/x64-windows-alice/`。大小和摘要对应本发布单元实际分发的文件。

| 发布路径 | 重建输出相对路径 | 字节数 | SHA-256 |
| --- | --- | ---: | --- |
| `3rdParty/bin/icudt74.dll` | `bin/icudt74.dll` | 30786048 | `3d11c0dcb08c743f63ebbcb50f891ae696b5eb98679c213abc39ce0cc45d5e55` |
| `3rdParty/bin/icuin74.dll` | `bin/icuin74.dll` | 2644480 | `cd0fba4e51e090d404fa860e4bc93d2298a9e37371e8b666840f9c9c2621899f` |
| `3rdParty/bin/icuio74.dll` | `bin/icuio74.dll` | 53248 | `08d7ee5c77b71f3416a6e83fd66ef4a8d6eff67bfbe5539cd58c9e26f9164d80` |
| `3rdParty/bin/icuuc74.dll` | `bin/icuuc74.dll` | 1784832 | `a8251712a1e39182e682f9f5cd9971ab7e316a076430dfd2279ca7943c6b7324` |
| `3rdParty/lib/icudt.lib` | `lib/icudt.lib` | 1686 | `b9a9e4dc4b31858866faca819d405fd4555ec6638f29fc5f59b3d9c15c9967b1` |
| `3rdParty/lib/icuin.lib` | `lib/icuin.lib` | 2922452 | `30083e97cd90afa9a4b9fcd40a584a84bb67996e9bee15a5ecbd09d87373b724` |
| `3rdParty/lib/icuio.lib` | `lib/icuio.lib` | 12584 | `20ffbee2d4576077227372c9d505243345df65912b866a0f66ce64bc138e2542` |
| `3rdParty/lib/icuuc.lib` | `lib/icuuc.lib` | 1082678 | `16e370d589fc7f992229cd0090dad939a7e198473e9eaa3d52aa638360a03c83` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/brotlicommon.dll` | `debug/bin/brotlicommon.dll` | 208384 | `bc81b939938b81a66170f1097aeec9e56ed74e5ba5c24088c1a92c920954ec6c` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/brotlidec.dll` | `debug/bin/brotlidec.dll` | 132608 | `7606078a931c60d27df88f1d708150630a7f314bffccedc83fbbe9a5fe6a2533` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/brotlienc.dll` | `debug/bin/brotlienc.dll` | 947200 | `d63927f3f9fc6b71e2b74500b3e4248290bb10cc197a411ee0f595182f956fa1` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/bz2d.dll` | `debug/bin/bz2d.dll` | 190464 | `eb3bc058da6f78dc1993c82b7e8a56bbbe39d34d4634def58a438bbce5960001` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/freetyped.dll` | `debug/bin/freetyped.dll` | 1539072 | `66569199a0d0d50590a2e2c368f2aef8c4e433549b3cd686f27747ef98c82277` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/hwloc-15.dll` | `debug/bin/hwloc-15.dll` | 577536 | `e10ee3e20d4a97e6b5c8d562a9daeca4fd866c4312a80b379f08fe1d0109b8e7` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/libpng16d.dll` | `debug/bin/libpng16d.dll` | 425984 | `2c4f87954366a1a9132cf9477aaea82cd5650cdaf974c4afd6e44734feb1f858` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/tbb12_debug.dll` | `debug/bin/tbb12_debug.dll` | 1152000 | `9863da3d6af0f08a2c241fb2edb61e8ccc42ced64b17a4c9c2e4fb633d96d529` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/tbbmalloc_debug.dll` | `debug/bin/tbbmalloc_debug.dll` | 326656 | `3e1331ad4eb8febab3cb82d152d5f19814ed030183d2f72255cc2c58b9b5f7e9` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/tbbmalloc_proxy_debug.dll` | `debug/bin/tbbmalloc_proxy_debug.dll` | 109056 | `018619b029ee395fbb4ef42ca54b6b4d985e55596f5bcfaa6ba9a3aa1821d5d5` |
| `3rdParty/runtime/msvc2022-x64-md/Debug/occt/zlibd1.dll` | `debug/bin/zlibd1.dll` | 210432 | `6320c6376f52c71b9513aa2e3794c55abeb1f97ab8d5345a873b62706c2bca7b` |

导出名称核对覆盖 ICU 的三个代码动态库和十一项 OCCT 传递动态库。OCCT 传递动态库的新旧导出名称集合完全一致；所有新动态库的导入依赖集合与迁移版本一致。ICU 同版本重建改变了少量由 MSVC 产生的装饰 C++ 导出，因此不能只依据版本号声明二进制兼容；ICU 74.2 port revision 6 与配套头文件、导入库、动态库作为同一个发布单元使用，兼容性必须由消费当前 AliceSdk 候选提交的 Alice Visual Studio 2022 完整编译和 CTest 门禁确认。

## 目录合同

Alice 持续集成把固定 AliceSdk 提交直接稀疏检出到 `Externals/3rdParty/sdk`，校验 `alice-platform/SHA256SUMS` 后，把 `pugixml` 与 `spdlog` 分别复制到 Alice 工作区 `Externals`，并把 `alice-platform/3rdParty` 下的 `include`、`lib`、`bin`、`runtime` 分别复制到 `Externals/3rdParty`。`occt` 自检出开始即位于 `Externals/3rdParty/sdk/msvc2022-x64-md/Debug/occt`，不再执行第二次复制。

制品只对应 Visual Studio 2022、x64、动态 MSVC 运行库和 Debug 配置。其他体系结构、运行库或 Release 配置必须使用独立目录和独立完整性清单，不能覆盖本目录文件。

## 更新规则

依赖更新先固定 AliceThirdParty 源码和 vcpkg 基线，再更新本发布单元的构建输入，生成新的 AliceSdk 候选提交。候选必须更新版本、来源、许可证、二进制路径、大小和逐文件摘要；逐个动态库检查可复现链接记录，并扫描普通字符串、UTF-16LE 字符串和 CodeView，确认没有构建机绝对路径。Alice 必须消费该候选提交完成 Visual Studio 2022 编译与完整 CTest，AliceSdk 才能发布；AliceSdk 发布后，Alice 再固定实际发布提交并重复同一门禁。已发布提交保持不可变，用于复现历史构建和回退。
