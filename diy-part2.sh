#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# x86 主页型号只显示 CPU 信息
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' ./package/lean/autocore/files/x86/autocore

# 修改版本号
revision=$(date +'%y.%-m.%-d')
sed -i "s/DISTRIB_REVISION='R[0-9.]*'/DISTRIB_REVISION='R${revision}'/" ./package/lean/default-settings/files/zzz-default-settings

# 删除默认密码
sed -i '/\/etc\/shadow/{/root/d;}' ./package/lean/default-settings/files/zzz-default-settings

# 合并配置
sed -i '/REDIRECT --to-ports 53/d' ./package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0$/d' ./package/lean/default-settings/files/zzz-default-settings
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/main/ExtraFiles/default-settings -O ./my-default-settings
cat ./my-default-settings >> ./package/lean/default-settings/files/zzz-default-settings

# 删除自带软件包
rm -rf ./feeds/packages/net/{pdnsd-alt,v2ray-geodata}

# 添加 Passwall
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git -b main ./package/passwall_packages
git clone https://github.com/xiaorouji/openwrt-passwall.git -b main ./package/passwall_luci
wget https://raw.githubusercontent.com/yk271/proxy-rule/main/direct_host.txt -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/rules/direct_host
wget https://raw.githubusercontent.com/yk271/proxy-rule/main/proxy_host.txt -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/rules/proxy_host
wget https://raw.githubusercontent.com/yk271/proxy-rule/main/block_host.txt -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/rules/block_host
wget https://raw.githubusercontent.com/yk271/proxy-rule/main/0_default_config -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/0_default_config

# 删除自带的 Argon 主题
rm -rf ./feeds/luci/themes/{luci-theme-argon,luci-theme-argon-mod}

# 添加主题
git clone https://github.com/jerrykuku/luci-theme-argon.git -b 18.06 ./package/luci-theme-argon
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/main/ExtraFiles/rideshare_feature_compress.jpg -O ./package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
