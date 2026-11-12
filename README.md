# Oh My Robot Devices

Oh My Robot 的器件库：DJI 电机、P1010B 电机、W25Q256JV SPI NOR 等具体器件实现。

## 边界

- 只依赖 `oh-my-robot-framework` 的公开头（驱动框架、kernel、sync）。
- 不依赖 `platform/`、BSP、芯片厂商 SDK；不持有板级数据；不创建线程或定时器。
- 板级/应用负责实例接线：把 `Device*`、`SpiBus*`、`GpioPinSpec` 与器件配置交给本库。

## 布局

```
include/devices/   公共头
src/               实现
docs/              器件文档
samples/           器件示例
tests/host/        host 仿真测试
```

## 构建

推荐由框架生成双仓工程壳：

```sh
xmake init_workspace --output=<工程壳目录> \
    --devices=<本仓库路径> \
    --entry_repo=devices \
    --entry=samples/motor/p1010b/main.c
```

独立构建时把 `OM_FRAMEWORK_ROOT` 指向框架 checkout，并在本仓库根放置
`om_preset.lua`（可从框架的 `om_preset.example.lua` 复制）：

```sh
export OM_FRAMEWORK_ROOT=<框架 checkout>
xmake f --board=rm-c-board --os=freertos --toolchain=gnu-rm -m release
xmake build tar_awdevices
xmake build device_sample_p1010b
```

host 仿真测试同样需要 `OM_FRAMEWORK_ROOT`：

```sh
xmake f -P tests/host/spi_nor_test -p mingw -m debug
xmake build -P tests/host/spi_nor_test
xmake run -P tests/host/spi_nor_test host_spi_nor_test
```

## 版本

本仓库独立使用 SemVer；与框架的兼容范围由后续 `compat.yaml` 声明。
