--- @file oh-my-robot-devices/xmake.lua
--- @brief 器件库构建入口
--- @details 独立构建时通过 OM_FRAMEWORK_ROOT 指向框架 checkout；由工程壳 include
---          时框架已先行加载，此处不再重复引入。
set_xmakever("3.0.7")
add_rules("mode.debug", "mode.release")

local framework_root = os.getenv("OM_FRAMEWORK_ROOT")
if framework_root and framework_root ~= "" then
    includes(path.absolute(framework_root))
end

--- @target tar_awapi_devices
--- @brief 器件库公共头目标
target("tar_awapi_devices")
    add_rules("oh_my_robot.project_cfg")
    set_kind("headeronly")
    add_deps("tar_awapi_driver", {public = true})
    add_includedirs("include", {public = true})
target_end()

--- @target tar_awdevices
--- @brief 器件库静态库
target("tar_awdevices")
    add_rules("oh_my_robot.project_cfg")
    set_kind("static")
    add_rules("oh_my_robot.context")
    add_deps("tar_awapi_devices", {public = true})
    add_files("src/**.c")
target_end()

--- 器件示例：默认不参与 xmake build，显式指定目标名时构建
--- @param name string 目标名
--- @param source string 示例入口
local function device_sample(name, source)
    target(name)
        set_kind("binary")
        set_default(false)
        add_deps("tar_oh_my_robot", "tar_awdevices")
        add_rules(
            "oh_my_robot.context",
            "oh_my_robot.board_assets",
            "oh_my_robot.image_convert",
            "oh_my_robot.project_cfg",
            "oh_my_robot.selfreg"
        )
        add_files(source)
    target_end()
end

device_sample("device_sample_p1010b", "samples/motor/p1010b/main.c")
device_sample("device_sample_dji_motor", "samples/motor/dji_motor/main.c")
device_sample("device_sample_spi_nor", "samples/spi_nor/main.c")
