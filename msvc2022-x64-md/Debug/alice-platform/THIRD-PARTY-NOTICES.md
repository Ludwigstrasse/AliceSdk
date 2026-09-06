# Alice 平台第三方软件许可说明

本目录分发 Alice Windows Debug 构建所需的第三方源码、头文件、导入库和动态库。各项目仍由其原作者拥有，并按照下表对应许可证使用和再分发。

| 项目 | 版本 | 许可证 | 本目录许可正文 | 上游项目 |
| --- | --- | --- | --- | --- |
| pugixml | 1.13 | MIT | `licenses/pugixml/LICENSE.md` | <https://github.com/zeux/pugixml/tree/v1.13> |
| spdlog | 1.15.3 | MIT；目录内 fmt 头文件适用 MIT | `licenses/spdlog/LICENSE` | <https://github.com/gabime/spdlog/tree/v1.15.3> |
| RapidJSON | 1.1.0 | MIT；`msinttypes/inttypes.h` 与 `msinttypes/stdint.h` 适用 BSD-3-Clause；所选公共头文件不包含 JSON_checker | `licenses/rapidjson/license.txt` | <https://github.com/Tencent/rapidjson/tree/v1.1.0> |
| ICU | 74.2 | ICU | `licenses/icu/LICENSE` | <https://github.com/unicode-org/icu/tree/release-74-2> |
| brotli | 1.2.0 | MIT | `licenses/brotli/LICENSE` | <https://github.com/google/brotli/tree/v1.2.0> |
| bzip2 | 1.0.8 | bzip2-1.0.6 | `licenses/bzip2/LICENSE` | <https://sourceware.org/bzip2/> |
| FreeType | 2.13.3 | FreeType Project License 或 GPL-2.0-or-later | `licenses/freetype/LICENSE.TXT` | <https://gitlab.freedesktop.org/freetype/freetype/-/tree/VER-2-13-3> |
| hwloc | 2.11.2 | BSD-3-Clause | `licenses/hwloc/COPYING` | <https://github.com/open-mpi/hwloc/tree/hwloc-2.11.2> |
| libpng | 1.6.54 | libpng-2.0 | `licenses/libpng/LICENSE` | <https://github.com/pnggroup/libpng/tree/v1.6.54> |
| oneTBB | 2022.3.0 | Apache-2.0 | `licenses/tbb/LICENSE.txt` | <https://github.com/uxlfoundation/oneTBB/tree/v2022.3.0> |
| zlib | 1.3.1 | Zlib | `licenses/zlib/LICENSE` | <https://github.com/madler/zlib/tree/v1.3.1> |
| Open CASCADE Technology | 8.0.0 rc3，开发标识 `c47d9c06b5` | LGPL-2.1-only 与 OCCT 例外条款 | `licenses/occt/LICENSE_LGPL_21.txt`、`licenses/occt/OCCT_LGPL_EXCEPTION.txt` | <https://github.com/Open-Cascade-SAS/OCCT> |

## 分发要求

复制或发布本制品时必须连同本文件和 `licenses` 目录一起分发，不得删除版权、许可证和免责声明。修改第三方源码时，应按照对应许可证保留修改说明并履行适用的源码提供要求。

OCCT 动态库按照 LGPL 2.1 与 OCCT 例外条款分发。使用方必须保留两份 OCCT 许可文件，并保证最终发布方式满足用户替换适用动态库的权利。FreeType 按项目提供的双重许可条件选择并履行相应要求。

本制品不包含任何公司产品源码、资源和设计资料。产品发布负责人仍需根据最终产品实际装配的全部组件复核发布许可清单。
