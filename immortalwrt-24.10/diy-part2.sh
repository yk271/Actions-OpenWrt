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
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/immortalwrt-24.10/default-settings -O ./my-default-settings
cat ./my-default-settings >> ./package/emortal/default-settings/files/99-default-settings

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

rm -rf ./package/passwall_packages/microsocks
git clone https://github.com/yk271/my-packages.git -b main ./package/my-packages

# Passwall 补丁
cd package/passwall_luci
mkdir -p patches
wget https://github.com/Openwrt-Passwall/openwrt-passwall/compare/main...yk271:openwrt-passwall:patch.patch -O ./patches/optimize.patch
patch -p1 < patches/optimize.patch
cd -

# unzip
rm -rf feeds/packages/utils/unzip
git clone https://github.com/sbwml/feeds_packages_utils_unzip feeds/packages/utils/unzip

# golang 1.25
rm -rf feeds/packages/lang/golang
git clone --depth=1 https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang

# curl
rm -rf feeds/packages/net/curl
git clone https://github.com/sbwml/feeds_packages_net_curl feeds/packages/net/curl
