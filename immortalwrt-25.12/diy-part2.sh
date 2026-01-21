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

# 合并配置
sed -i '/exit 0$/d' ./package/emortal/default-settings/files/99-default-settings
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/immortalwrt-25.12/default-settings -O ./my-default-settings
cat ./my-default-settings >> ./package/emortal/default-settings/files/99-default-settings

# luci: remove ASU dependency (25.12)
cd feeds/luci
mkdir -p diy-patches
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/patches/luci_2512_remove_asu_dependency.patch -O ./diy-patches/luci_2512_remove_asu_dependency.patch
patch -p1 < diy-patches/luci_2512_remove_asu_dependency.patch
cd -

# 删除自带软件包
rm -rf ./feeds/packages/net/{chinadns-ng,dns2socks,geoview,hysteria,ipt2socks,microsocks,naiveproxy,shadow-tls,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,sing-box,tcping,trojan-plus,tuic-client,v2ray-geodata,v2ray-plugin,xray-core,xray-plugin}
# 删除自带插件
rm -rf ./feeds/luci/applications/{luci-app-passwall,luci-app-passwall2}

# 添加 Passwall
git clone https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git -b main ./package/passwall_packages
git clone https://github.com/Openwrt-Passwall/openwrt-passwall.git -b main ./package/passwall_luci
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/passwall/direct_host -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/rules/direct_host
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/passwall/proxy_host -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/rules/proxy_host
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/passwall/block_host -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/rules/block_host
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/passwall/chnlist -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/rules/chnlist
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/passwall/gfwlist -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/rules/gfwlist
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/passwall/0_default_config -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/0_default_config

cd package/passwall_luci
git checkout 97921a9178f10be41e31bdabcef69c0ca444adb4
cd -

# Passwall 补丁
cd package/passwall_luci
mkdir -p diy-patches
wget https://github.com/Openwrt-Passwall/openwrt-passwall/compare/main...yk271:openwrt-passwall:diy.patch -O ./diy-patches/optimize.patch
patch -p1 < diy-patches/optimize.patch
cd -

rm -rf feeds/packages/lang/golang
git clone --depth=1 https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang
