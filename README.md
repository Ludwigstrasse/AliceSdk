# AliceSdk

AliceSdk 发布 Alice 平台可复现构建和产品集成所需的固定开发包。仓库只保存 Alice 通用制品、依赖说明、许可证和完整性清单，不保存产品源码、产品资源或产品设计资料。

## 目录结构

制品按工具链、体系结构、MSVC 运行库和构建配置分层：

```text
msvc2022-x64-md/
  Debug/
    alice-platform/
    occt/
```

`alice-platform` 保存 Alice Windows 构建所需的最小第三方闭包。`occt` 保存相同工具链和配置的 OCCT 开发包。每个发布单元必须具有依赖版本说明、第三方许可说明和逐文件 SHA-256 清单。

## 使用合同

使用方必须固定 AliceSdk 的完整 Git 提交或不可变发布版本，先校验文件集合与 SHA-256，再把对应制品准备到构建目录。禁止使用浮动分支、按时间变化的下载地址或本机残留目录替代固定制品。

不同工具链、体系结构、MSVC 运行库和构建配置使用独立目录。Debug 与 Release 制品不得混用；新版本不得覆盖已发布文件。

## 来源与发布

AliceThirdParty 负责第三方源码来源、固定版本、构建与导出规则。AliceSdk 负责发布构建后的确定制品。Alice 和产品仓库只消费通过验证的 AliceSdk 提交，不向 AliceSdk 反向提供产品文件。

依赖变更必须同时更新版本说明、许可材料和完整性清单，并通过对应 Alice 提交的 Visual Studio 2022 编译与 CTest。批准后的提交保持不可变；大体积版本增长时，二进制制品迁移到 AliceSdk 的不可变 Release 资产，仓库继续保存同一制品合同和清单。
