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

# 修改内核版本
#sed -i 's/KERNEL_PATCHVER:=.*/KERNEL_PATCHVER:=5.15/g' ./target/linux/x86/Makefile

# x86 主页型号只显示 CPU 信息
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' ./package/lean/autocore/files/x86/autocore

# 修改版本号
revision=$(date +'%y.%-m.%-d')
sed -i "s/DISTRIB_REVISION='R[0-9.]*'/DISTRIB_REVISION='R${revision}'/" ./package/lean/default-settings/files/zzz-default-settings

# 删除默认密码
sed -i '/\/etc\/shadow/{/root/d;}' ./package/lean/default-settings/files/zzz-default-settings

# 合并配置
#sed -i '/REDIRECT --to-ports 53/d' ./package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0$/d' ./package/lean/default-settings/files/zzz-default-settings
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/lede/default-settings -O ./my-default-settings
cat ./my-default-settings >> ./package/lean/default-settings/files/zzz-default-settings

# 删除自带软件包
rm -rf ./feeds/packages/net/{chinadns-ng,dns2socks,geoview,hysteria,ipt2socks,microsocks,naiveproxy,shadow-tls,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,sing-box,tcping,trojan-plus,tuic-client,v2ray-geodata,v2ray-plugin,xray-core,xray-plugin}
# 删除自带插件
rm -rf ./feeds/luci/applications/{luci-app-passwall,luci-app-passwall2}

# 添加 Passwall
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git -b main ./package/passwall_packages
git clone https://github.com/xiaorouji/openwrt-passwall.git -b main ./package/passwall_luci
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/passwall/direct_host -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/rules/direct_host
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/passwall/proxy_host -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/rules/proxy_host
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/passwall/block_host -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/rules/block_host
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/passwall/chnlist -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/rules/chnlist
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/passwall/gfwlist -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/rules/gfwlist
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/passwall/0_default_config -O ./package/passwall_luci/luci-app-passwall/root/usr/share/passwall/0_default_config

# Passwall Sing-Box 版本临时回退
# cd package/passwall_packages/sing-box
# git checkout 2ba440cdd7799ce554b355988eda974b94d2f6d7
# cd -

# 补丁
cd package/passwall_luci
mkdir -p patches
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/passwall/patches/add_rule.patch -O ./patches/add_rule.patch
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/passwall/patches/delete_some_excluded_domains.patch -O ./patches/delete_some_excluded_domains.patch
patch -p1 < patches/add_rule.patch
patch -p1 < patches/delete_some_excluded_domains.patch
cd -

# 删除自带的 Argon 主题
rm -rf ./feeds/luci/themes/{luci-theme-argon,luci-theme-argon-mod}

# 添加主题
git clone https://github.com/jerrykuku/luci-theme-argon.git -b 18.06 ./package/luci-theme-argon
wget https://raw.githubusercontent.com/yk271/Actions-OpenWrt/refs/heads/main/package-diy/theme-argon/rideshare_feature_compress.jpg -O ./package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
