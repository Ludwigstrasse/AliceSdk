# Alice 平台 Windows Debug 构建依赖

| 属性 | 内容 |
| --- | --- |
| 制品名称 | `alice-platform` |
| 工具链 | Visual Studio 2022，x64，动态 MSVC 运行库 |
| 构建配置 | Debug |
| AliceSdk 基线 | `27aa89bc9e03e768f817d19c8584a2d35120cfa5` |
| 来源定义 | `Ludwigstrasse/AliceThirdParty@2539f2d1ebf3a34cfb9598ec4ad21d03b285c171` |
| vcpkg 基线 | `15e5f3820f0370f1ba7150853762cec0688cd396` |
| 目标使用方 | Alice 独立 Windows 持续集成与固定版本产品构建 |
| 完整性清单 | `SHA256SUMS` |

## 制品范围

| 依赖 | 固定版本 | 文件范围 | Alice 用途 | 许可证文件 |
| --- | --- | --- | --- | --- |
| pugixml | 1.13 | `pugixml/` | XML 配置、插件与产品信息读取 | `licenses/pugixml/LICENSE.md` |
| spdlog | 1.15.3 | `spdlog/` | 平台诊断日志；目录包含其头文件依赖 | `licenses/spdlog/LICENSE` |
| RapidJSON | 1.1.0 | `3rdParty/include/rapidjson/include/rapidjson/` | 测试协议和工作台设置 | `licenses/rapidjson/license.txt` |
| ICU | 74.2 | `3rdParty/include/unicode/`、`3rdParty/lib/icu*.lib`、`3rdParty/bin/icu*74.dll` | Unicode 转换、区域设置和测试运行 | `licenses/icu/LICENSE` |
| brotli | 1.2.0 | `3rdParty/runtime/msvc2022-x64-md/Debug/occt/brotli*.dll` | OCCT 传递运行依赖 | `licenses/brotli/LICENSE` |
| bzip2 | 1.0.8，vcpkg port revision 6 | `3rdParty/runtime/msvc2022-x64-md/Debug/occt/bz2d.dll` | OCCT 传递运行依赖 | `licenses/bzip2/LICENSE` |
| FreeType | 2.13.3 | `3rdParty/runtime/msvc2022-x64-md/Debug/occt/freetyped.dll` | OCCT 字体运行依赖 | `licenses/freetype/LICENSE.TXT` |
| hwloc | 2.11.2 | `3rdParty/runtime/msvc2022-x64-md/Debug/occt/hwloc-15.dll` | OCCT 传递运行依赖 | `licenses/hwloc/COPYING` |
| libpng | 1.6.54 | `3rdParty/runtime/msvc2022-x64-md/Debug/occt/libpng16d.dll` | OCCT 图像运行依赖 | `licenses/libpng/LICENSE` |
| oneTBB | 2022.3.0 | `3rdParty/runtime/msvc2022-x64-md/Debug/occt/tbb*_debug.dll` | OCCT 并行运行依赖 | `licenses/tbb/LICENSE.txt` |
| zlib | 1.3.1 | `3rdParty/runtime/msvc2022-x64-md/Debug/occt/zlibd1.dll` | OCCT 压缩运行依赖 | `licenses/zlib/LICENSE` |
| OCCT | 8.0.0 rc3，开发标识 `c47d9c06b5` | 同级目录 `../occt/` | 几何内核、三维显示和 Alice OCCT 适配层 | `licenses/occt/LICENSE_LGPL_21.txt`、`licenses/occt/OCCT_LGPL_EXCEPTION.txt` |

## 来源确认

pugixml 版本来自 `pugixml.hpp` 的 `PUGIXML_VERSION 1130`；spdlog 版本来自 `include/spdlog/version.h`；RapidJSON 版本来自其 1.1.0 公共头文件；ICU 版本来自 `unicode/uvernum.h` 的 `U_ICU_VERSION "74.2"`；OCCT 版本来自同级开发包 `Standard_Version.hxx` 的 `8.0.0.rc3-c47d9c06b5`。

OCCT 传递动态库的版本由 AliceThirdParty 固定 vcpkg 基线及对应构建来源确认。首个 `alice-platform` 发布单元保持当前已验证版本，不升级依赖，也不重新链接现有二进制文件。

## 目录合同

Alice 持续集成校验 `SHA256SUMS` 后，把 `pugixml`、`spdlog` 和 `3rdParty` 复制到 Alice 工作区 `Externals`。同一 AliceSdk 固定提交中的 `msvc2022-x64-md/Debug/occt` 复制到 `Externals/3rdParty/sdk/msvc2022-x64-md/Debug/occt`。

制品只对应 Visual Studio 2022、x64、动态 MSVC 运行库和 Debug 配置。其他体系结构、运行库或 Release 配置必须使用独立目录和独立完整性清单，不能覆盖本目录文件。

## 更新规则

依赖更新先在 AliceThirdParty 固定来源和构建规则，再生成新的 AliceSdk 候选提交，更新版本、许可证和逐文件摘要。Alice 使用新候选完成 Visual Studio 2022 编译与非零 CTest 后才能升级固定引用。已发布提交保持不可变，用于复现历史构建和回退。
