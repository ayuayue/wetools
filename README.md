# WeTools - 开发者工具箱

[![Flutter Version](https://img.shields.io/badge/Flutter-3.6.0-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

一个使用 Flutter 开发的轻量级开发者工具箱，提供常用的编码解码、格式化、加密等功能。

## 最近更新
查看完整的[更新日志](CHANGELOG.md)

- [v1.0.67] 优化更新日志显示,增加 CHANGELOG 文件 - 2024-03-14
- [v1.0.66] 优化 jwt 编码页面编辑器文本,增加代码高亮及错误提示 - 2024-03-14
- [v1.0.65] 优化剪贴板页面,优化 json http json编辑,增加json格式化及验证功能 - 2024-03-14


## 功能特性(持续更新中,请以实际为准)

- **JWT 工具**
  - JWT Token 编码/解码
  - 支持自定义密钥
  - 实时预览结果

- **URL 工具**
  - URL 编码/解码
  - 支持中文字符
  - 复制结果功能

- **Base64 工具**
  - 文本编码/解码
  - 支持 Unicode 字符
  - 错误提示功能

- **JSON 工具**
  - JSON 格式化
  - JSON 压缩
  - Unicode 转中文
  - 支持语法校验

- **Hash 工具**
  - MD5 计算
  - SHA1 计算
  - SHA256 计算
  - SM3 计算
  - 支持加盐处理
  - 支持大小写切换

- **文本工具**
  - 去除首尾空白
  - 大小写转换
  - 中英文标点转换
  - 字符统计（包含 UTF-8/GBK 编码长度）


## 开始使用
从 release 中下载对应平台的压缩包, 解压后即可运行.

### 环境要求

- Flutter 3.6.0 或更高版本
- Dart 3.0.0 或更高版本

### 安装
在 release 中下载对应平台的压缩包, 解压后即可运行.

注意: macos 如果打开提示恶意软件,是由于没有签名导致. 最低支持 macos 10.14.6 版本.

 1.右键点击应用 打开 

 2.在系统偏好设置 ->安全性与隐私 中允许打开

## 平台支持

- ✅ Windows
  - 支持 URL Launcher
  - 原生窗口支持
- ✅ macOS
  - 支持应用分类
  - URL Scheme 支持
- ✅ Linux
  - 基础功能支持
- ✅ Web
  - 响应式布局
  - CDN 资源支持

## 技术栈

- Flutter 3.6.0
- Dart 3.0.0
- Material Design 3
- Flutter Web


![alt text](./assets/images/长截图_20250131_212816.png)
![alt text](./assets/images/长截图_20250131_212236.png)
![alt text](./assets/images/wetools.exe_20250131_212044.png)
![alt text](./assets/images/长截图_20250131_212358.png)
![alt text](./assets/images/wetools.exe_20250131_212517.png)
![alt text](./assets/images/wetools.exe_20250131_212601.png)
![alt text](./assets/images/wetools.exe_20250131_212700.png)
![alt text](./assets/images/长截图_20250131_212733.png)


![alt text](./assets/gif/录屏_20250128_232717.gif)
![alt text](./assets/gif/录屏_20250128_233004.gif)

## macOS 使用说明

由于应用未经过 Apple 签名，首次运行时可能会提示"无法打开"，解决方法：

1. 在 Finder 中找到应用，右键点击 -> 打开
2. 在系统偏好设置 -> 安全性与隐私 中允许打开
3. 或使用终端命令：`xattr -cr /Applications/wetools.app`


## 支持作者

如果觉得这个工具对你有帮助，可以请作者喝杯咖啡，支持作者继续开发。

<img src="./assets/images/alipay.png" alt="支付宝" width="200">

<img src="./assets/images/wechat_pay.png" alt="微信" width="200">

