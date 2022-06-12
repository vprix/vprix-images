#!/usr/bin/env bash
set -ex
#chromium 浏览器启动参数
CHROME_ARGS="--password-store=basic --no-sandbox  --disable-gpu --user-data-dir --no-first-run --window-position=0,0 --simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'"
# 判断当前的发行版平台
ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/amd64/g')

# centos直接安装chromium
if [[ "${DISTRO}" == @(centos|oracle7) ]]; then
    yum install -y chromium
    yum clean all
else
  # ubuntu执行复杂逻辑
  apt-get update
  apt-get install -y software-properties-common
  # 移除默认安装的版本
  apt-get remove -y chromium-browser-l10n chromium-codecs-ffmpeg chromium-browser

  # Ubuntu 19.10或更新版本的Chromium使用snap来安装
  # 为了兼容目前的docker容器。新的安装将会从archive.ubuntu.com下载拉Deb文件安装ubuntu 18.04支持版本。
  # 在18.04可以工作之前都会使用该方式
  if [[ ${ARCH} == "amd64" ]] ;
  then
    chrome_url="http://mirrors.aliyun.com/ubuntu/pool/universe/c/chromium-browser/"
  else
    chrome_url="http://ports.ubuntu.com/pool/universe/c/chromium-browser/"
  fi

  # 获取codecs版本
  chromium_codecs_data=$(curl ${chrome_url})
  chromium_codecs_data=$(grep "chromium-codecs-ffmpeg-extra_" <<< "${chromium_codecs_data}")
  chromium_codecs_data=$(grep "18\.04" <<< "${chromium_codecs_data}")
  chromium_codecs_data=$(grep "${ARCH}" <<< "${chromium_codecs_data}")
  chromium_codecs_data=$(sed -n 's/.*<a href="//p' <<< "${chromium_codecs_data}")
  chromium_codecs_data=$(sed -n 's/">.*//p' <<< "${chromium_codecs_data}")
  echo "将要下载使用的Chromium codec deb包: ${chromium_codecs_data}"

  # 获取chromium浏览器的版本
  chromium_data=$(curl ${chrome_url})
  chromium_data=$(grep "chromium-browser_" <<< "${chromium_data}")
  chromium_data=$(grep "18\.04" <<< "${chromium_data}")
  chromium_data=$(grep "${ARCH}" <<< "${chromium_data}")
  chromium_data=$(sed -n 's/.*<a href="//p' <<< "${chromium_data}")
  chromium_data=$(sed -n 's/">.*//p' <<< "${chromium_data}")
  echo "将要下载使用的Chromium browser deb包: ${chromium_data}"

  echo "准备下载:"
  echo "${chrome_url}${chromium_codecs_data}"
  echo "${chrome_url}${chromium_data}"

  # 下载安装包
  wget "${chrome_url}${chromium_codecs_data}"
  wget "${chrome_url}${chromium_data}"

  #安装
  apt-get install -y ./"${chromium_codecs_data}"
  apt-get install -y ./"${chromium_data}"

  #删除安装包
  rm "${chromium_codecs_data}"
  rm "${chromium_data}"
fi

# 修改快捷方式内容
sed -i 's/-stable//g' /usr/share/applications/chromium-browser.desktop

# 创建桌面方式
cp /usr/share/applications/chromium-browser.desktop $HOME/Desktop/
chown 1000:1000 $HOME/Desktop/chromium-browser.desktop


mv /usr/bin/chromium-browser /usr/bin/chromium-browser-orig
cat >/usr/bin/chromium-browser <<EOL
#!/usr/bin/env bash
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"None"/' ~/.config/chromium/Default/Preferences
echo "Starting Chrome"
/usr/bin/chromium-browser-orig ${CHROME_ARGS} "\$@"
EOL

chmod +x /usr/bin/chromium-browser
cp /usr/bin/chromium-browser /usr/bin/chromium

# 设置指定文件格式的默认应用
if [[ "${DISTRO}" == @(centos|oracle7) ]]; then
  cat >> $HOME/.config/mimeapps.list <<EOF
    [Default Applications]
    x-scheme-handler/http=chromium-browser.desktop
    x-scheme-handler/https=chromium-browser.desktop
    x-scheme-handler/ftp=chromium-browser.desktop
    x-scheme-handler/chrome=chromium-browser.desktop
    text/html=chromium-browser.desktop
    application/x-extension-htm=chromium-browser.desktop
    application/x-extension-html=chromium-browser.desktop
    application/x-extension-shtml=chromium-browser.desktop
    application/xhtml+xml=chromium-browser.desktop
    application/x-extension-xhtml=chromium-browser.desktop
    application/x-extension-xht=chromium-browser.desktop
EOF
else
  # 设置指定文件格式的默认应用，ubuntu系统
  sed -i 's@exec -a "$0" "$HERE/chromium" "$\@"@@g' /usr/bin/x-www-browser
  cat >>/usr/bin/x-www-browser <<EOL
  exec -a "\$0" "\$HERE/chromium" "${CHROME_ARGS}"  "\$@"
EOL
fi

# setting chromium start flag
mkdir -p /etc/chromium/policies/managed/
cat >>/etc/chromium/policies/managed/default_managed_policy.json <<EOL
{"CommandLineFlagSecurityWarningsEnabled": false, "DefaultBrowserSettingEnabled": false}
EOL

