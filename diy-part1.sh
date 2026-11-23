#!/bin/bash
# DIY脚本
# https://github.com/P3TERX/Actions-OpenWrt
# 文件名: diy-part1.sh
# 功能说明: OpenWrt DIY脚本第1部分（更新feeds之前）
# 版权: (c) 2019-2024 P3TERX <https://p3terx.com>
# 基于 MIT 开源协议，详见 /LICENSE

# 取消注释一个源
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# 锁定 packages feed 到 libffi 移除之前的提交（修复 glib2 编译失败）
# 背景： immortalwrt/packages 于 2026-10-19 (70ac3a84406c "libffi: move to core repo")
#        把 libffi 从 feed 移入官方主仓库，而本仓库锁定的 lkiuyu 源码树（2026-05）
#        并没有 package/libs/libffi，拉最新 feed 会导致 glib2 2.88.1 报错：
#        "Package glib2-gobject is missing dependencies for the following libraries: libffi.so.8"
# 方案： feed 锁定到 70ac3a84406c 的父提交 3b7cdf03（glib2 2.88.1 与 libffi 并存、可正常编译）
sed -i 's|^src-git packages https://github.com/immortalwrt/packages.git$|src-git packages https://github.com/immortalwrt/packages.git^3b7cdf03a6f22e91ae485e1ffdda1062da7a3431|' feeds.conf.default
grep -n '^src-git packages' feeds.conf.default

# 添加第三方 feed 源（small-package 包含 openclash/passwall/ssr-plus 等常用插件）
echo 'src-git smpackage https://github.com/kenzok8/small-package' >> feeds.conf.default
# 添加第三方源，iStore 应用商店，编译时包名输入 luci-app-store
echo 'src-git store https://github.com/linkease/istore.git;main' >> feeds.conf.default


# OpenClash代理
# git clone --depth 1 https://github.com/vernesong/OpenClash.git OpenClash

# turboacc网络加速（需要用户在页面选择 luci-app-turboacc 后，由编译脚本自动执行，此处不再无条件运行）
# curl -sSL https://raw.githubusercontent.com/mufeng05/turboacc/main/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

# 调试
# sed -i 's|src-git-full openstick https://github.com/lkiuyu/openstick-feeds.git|src-git-full openstick https://github.com/xuxin1955/openstick-feeds|g' feeds.conf.default



