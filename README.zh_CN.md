[English](/README.md) | [فارسی](/README.fa_IR.md) | [العربية](/README.ar_EG.md) | [中文](/README.zh_CN.md) | [Español](/README.es_ES.md) | [Русский](/README.ru_RU.md) | [Türkçe](/README.tr_TR.md)

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./media/3x-ui-dark.png">
    <img alt="3x-ui" src="./media/3x-ui-light.png">
  </picture>
</p>

<p align="center">
  <a href="https://github.com/MHSanaei/3x-ui/releases"><img src="https://img.shields.io/github/v/release/mhsanaei/3x-ui" alt="Release"></a>
  <a href="https://github.com/MHSanaei/3x-ui/actions"><img src="https://img.shields.io/github/actions/workflow/status/mhsanaei/3x-ui/release.yml.svg" alt="Build"></a>
  <a href="#"><img src="https://img.shields.io/github/go-mod/go-version/mhsanaei/3x-ui.svg" alt="GO Version"></a>
  <a href="https://github.com/MHSanaei/3x-ui/releases/latest"><img src="https://img.shields.io/github/downloads/mhsanaei/3x-ui/total.svg" alt="Downloads"></a>
  <a href="https://www.gnu.org/licenses/gpl-3.0.en.html"><img src="https://img.shields.io/badge/license-GPL%20V3-blue.svg?longCache=true" alt="License"></a>
  <a href="https://pkg.go.dev/github.com/mhsanaei/3x-ui/v3"><img src="https://pkg.go.dev/badge/github.com/mhsanaei/3x-ui/v3.svg" alt="Go Reference"></a>
  <a href="https://docs.sanaei.dev"><img src="https://img.shields.io/badge/docs-docs.sanaei.dev-22d3ee" alt="Documentation"></a>
</p>

**3x-ui-lw** 是 [3X-UI](https://github.com/MHSanaei/3x-ui) 的轻量分支，面向低配 Alpine、Debian 和 Ubuntu NAT VPS。它保留面板、SQLite、流量统计、订阅和 Xray 管理能力，目标是在约 120 MB 内存、1 GB 磁盘的机器上运行。

轻量版首期只保留三种核心 VLESS 组合：适合 CDN/反代的 XHTTP + TLS、WebSocket + TLS，以及直连抗封锁的 TCP + REALITY。其他协议和大型旁路组件暂不打包。

> [!IMPORTANT]
> 本项目仅供个人使用。请勿将其用于非法目的，也请勿在生产环境中使用。

## 功能特性

- **低资源占用** — 轻量运行时，仅使用 SQLite，不包含 PostgreSQL、Fail2ban、地理库和协议旁路组件。
- **支持的入站** — VLESS XHTTP + TLS、VLESS WebSocket + TLS、VLESS TCP + REALITY。
- **客户端管理** — 流量配额、到期时间、IP 限制、在线状态、分享链接、二维码和订阅。
- **流量统计** — 入站和客户端流量统计，支持定时重置。
- **一键部署** — 自动识别 Alpine、Debian 和 Ubuntu，带 SHA256 校验，并分别注册 OpenRC 或 systemd 服务。
- **Docker 部署** — 已发布镜像，默认限制 120 MB 内存并持久化数据库和日志。

## 截图

<details>
<summary>点击展开</summary>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/01-overview-dark.png">
  <img alt="Overview" src="./media/01-overview-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/02-add-inbound-dark.png">
  <img alt="Inbounds" src="./media/02-add-inbound-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/03-add-client-dark.png">
  <img alt="Add client" src="./media/03-add-client-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/05-add-nodes-dark.png">
  <img alt="Configs" src="./media/05-add-nodes-light.png">
</picture>

</details>

## 快速开始

```bash
curl -fsSL https://raw.githubusercontent.com/csy6666/3x-ui-lw/lw/mvp-protocol-whitelist/install-lw.sh | sh
```

固定当前轻量版版本：

```bash
curl -fsSL https://raw.githubusercontent.com/csy6666/3x-ui-lw/lw/mvp-protocol-whitelist/install-lw.sh | XUI_LW_VERSION=lw-v0.1.3 sh
```

若要安装滚动更新的 **dev** 版本（来自 `main` 的最新逐次提交预发布版本，而非稳定版本），请传入 `dev-latest`：

```bash
```

安装过程中会生成随机的用户名、密码和访问路径。安装完成后，运行 `x-ui` 打开管理菜单，您可以在其中启动/停止服务、查看或重置登录凭据、管理 SSL 证书等。

每个发布资源都会在其旁边附带一个 `.sha256` 校验和。`install.sh` 和更新程序都会据此校验压缩包，不匹配时中止。

完整文档（安装、配置、运维以及完整的 API 参考）请访问 **[docs.sanaei.dev](https://docs.sanaei.dev/zh)**。

### 无人值守安装

安装程序也可以**非交互式**运行，适用于 cloud-init。
设置 `XUI_NONINTERACTIVE=1`（或在无 TTY 的情况下通过管道传入），它就会全程
零提示地完成端到端安装，生成随机凭据并写入
`/etc/x-ui/install-result.env`。请参阅 [`deploy/`](deploy/)：

- [Cloud-init user-data](deploy/cloud-init/) — 在任意云平台上无人值守安装（Hetzner/AWS/DO/Vultr/GCP/Azure/Oracle）
- [Hetzner Cloud 说明](deploy/marketplace/hetzner/) — 在 Hetzner 上基于 cloud-init 的部署

## 支持的平台

**操作系统：** Ubuntu、Debian、Armbian、Fedora、CentOS、RHEL、AlmaLinux、Rocky Linux、Oracle Linux、Amazon Linux、Virtuozzo、Arch、Manjaro、Parch、openSUSE (Tumbleweed / Leap)、Alpine 和 Windows。

**架构：** `amd64` · `386` · `arm64` (aarch64) · `armv7` · `armv6` · `armv5` · `s390x`。

## 数据库选项

3X-UI 支持两种后端，可在安装时选择：

- **SQLite**（默认）— 位于 `/etc/x-ui/x-ui.db` 的单个文件。无需配置，适合中小型部署。
- **PostgreSQL** — 推荐用于大量客户端或多节点设置。安装程序可以为您在本地安装 PostgreSQL，或接受指向现有服务器的 DSN。

运行时通过环境变量选择后端（安装程序会为您写入 `/etc/default/x-ui`）：

```
XUI_DB_TYPE=postgres
XUI_DB_DSN=postgres://xui:password@127.0.0.1:5432/xui?sslmode=disable
```

### 将现有的 SQLite 安装迁移到 PostgreSQL

```bash
x-ui migrate-db --dsn "postgres://xui:password@127.0.0.1:5432/xui?sslmode=disable"
# 然后在 /etc/default/x-ui 中设置 XUI_DB_TYPE 和 XUI_DB_DSN 并重启：
systemctl restart x-ui
```

源 SQLite 文件保持不变；在确认新后端正常工作后，请手动删除它。

### Docker

默认的 `docker compose up -d` 仍使用 SQLite。若要使用捆绑的 PostgreSQL 服务运行，请取消注释 `docker-compose.yml` 中的两行 `XUI_DB_*` 环境变量，并使用该 profile 启动：

```bash
docker compose --profile postgres up -d
```

该镜像捆绑了 Fail2ban（默认启用），用于强制执行按客户端的 **IP 限制**。Fail2ban 使用 `iptables` 封禁违规者，这需要 `NET_ADMIN` 权限。`docker-compose.yml` 已通过 `cap_add` 授予该权限；如果您改用 `docker run` 启动容器，请自行添加这些权限，否则封禁只会被记录而永远不会生效：

```bash
docker run -d --cap-add=NET_ADMIN --cap-add=NET_RAW ... ghcr.io/mhsanaei/3x-ui
```

## 环境变量

| 变量 | 说明 | 默认值 |
| --- | --- | --- |
| `XUI_DB_TYPE` | 数据库后端：`sqlite` 或 `postgres` | `sqlite` |
| `XUI_DB_DSN` | PostgreSQL 连接字符串（当 `XUI_DB_TYPE=postgres` 时） | — |
| `XUI_DB_FOLDER` | SQLite 数据库文件所在目录 | `/etc/x-ui` |
| `XUI_DB_MAX_OPEN_CONNS` | 最大打开连接数（PostgreSQL 连接池） | — |
| `XUI_DB_MAX_IDLE_CONNS` | 最大空闲连接数（PostgreSQL 连接池） | — |
| `XUI_INIT_WEB_BASE_PATH` | Web 面板的初始 URI 路径 | `/` |
| `XUI_ENABLE_FAIL2BAN` | 启用基于 Fail2ban 的 IP 限制 | `true` |
| `XUI_LOG_LEVEL` | 日志级别（`debug`、`info`、`warning`、`error`） | `info` |
| `XUI_DEBUG` | 启用调试模式 | `false` |
| `XUI_TUNNEL_HEALTH_MONITOR` | 启用隧道健康监控（探测某个 URL，在连续多次失败后重启 xray；重启会断开所有客户端） | `false` |
| `XUI_TUNNEL_HEALTH_PROXY` | 探测请求所经过的代理；将其指向本地 xray 入站，使探测能够测试隧道（例如 `socks5://127.0.0.1:1080`）。留空表示探测仅检查主机连通性 | — |
| `XUI_TUNNEL_HEALTH_URL` | 用于检测隧道健康状况的探测 URL | `https://www.cloudflare.com/cdn-cgi/trace` |
| `XUI_TUNNEL_HEALTH_INTERVAL` | 两次探测之间的间隔 | `30s` |
| `XUI_TUNNEL_HEALTH_TIMEOUT` | 单次探测的超时时间 | `10s` |
| `XUI_TUNNEL_HEALTH_FAILURES` | 触发重启前的连续失败次数 | `3` |
| `XUI_TUNNEL_HEALTH_COOLDOWN` | 两次连续重启之间的最小间隔 | `5m` |
| `NODE_TOKEN_ENCRYPTION` | 节点 API 令牌的静态加密：`off`、`migration` 或 `required`（注意：无 `XUI_` 前缀） | `off` |
| `XUI_NODE_TOKEN_KEY_FILE` | JSON 密钥环（权限 `0600`），包含活动密钥 ID 及其 base64 编码的 32 字节密钥 | `/etc/x-ui/node_token_key.json` |
| `XUI_NODE_TOKEN_KEY` | 单个 base64 编码的 32 字节密钥，仅在无法加载密钥文件时使用 | — |

完整列表请参阅[环境变量参考](https://docs.sanaei.dev/zh/docs/reference/env-vars)。

## 支持的语言

面板界面提供 13 种语言：

English · فارسی · العربية · 中文（简体） · 中文（繁體） · Español · Русский · Українська · Türkçe · Tiếng Việt · 日本語 · Bahasa Indonesia · Português (Brasil)

## 贡献

欢迎贡献。在提交 issue 或 pull request 之前，请阅读[贡献指南](/CONTRIBUTING.md)。

## 特别感谢

- [alireza0](https://github.com/alireza0/)

## 致谢

- [Iran v2ray rules](https://github.com/chocolate4u/Iran-v2ray-rules) (许可证: **GPL-3.0**): _增强的 v2ray/xray 和 v2ray/xray-clients 路由规则，内置伊朗域名，专注于安全性和广告拦截。_
- [Russia v2ray rules](https://github.com/runetfreedom/russia-v2ray-rules-dat) (许可证: **GPL-3.0**): _此仓库包含基于俄罗斯被阻止域名和地址数据自动更新的 V2Ray 路由规则。_

## 社区工具

社区围绕 3x-ui 构建的工具和集成。

- [terraform-provider-3x-ui](https://github.com/batonogov/terraform-provider-threexui) (许可证: **MIT**): _使用 Terraform / OpenTofu 通过代码管理入站、客户端、面板设置和 Xray 配置。_
- [3X-UI Manager](https://github.com/yukh975/3X-UI-Manager) (许可证: **MIT**): _3x-ui 的原生 Android 客户端 — 仪表板、入站、带二维码分享的客户端、节点以及多面板管理。可在 F-Droid 获取。_

## 支持项目

**如果这个项目对您有帮助，您可以给它一个**:star2:

<a href="https://www.buymeacoffee.com/MHSanaei" target="_blank">
<img src="./media/default-yellow.png" alt="Buy Me A Coffee" style="height: 70px !important;width: 277px !important;" >
</a>

</br>
<a href="https://nowpayments.io/donation/hsanaei" target="_blank" rel="noreferrer noopener">
   <img src="./media/donation-button-black.svg" alt="Crypto donation button by NOWPayments">
</a>

## 星标历史

<a href="https://www.star-history.com/?repos=mhsanaei%2F3x-ui&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=mhsanaei/3x-ui&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=mhsanaei/3x-ui&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=mhsanaei/3x-ui&type=date&legend=top-left" />
 </picture>
</a>

<p align="center">
 <a href="https://www.star-history.com/mhsanaei/3x-ui">
  <picture><source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/badge?repo=MHSanaei/3x-ui&type=rank&theme=dark" /><source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/badge?repo=MHSanaei/3x-ui&type=rank" /><img alt="Star History Rank" src="https://api.star-history.com/badge?repo=MHSanaei/3x-ui&type=rank" /></picture> <picture><source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/badge?repo=MHSanaei/3x-ui&type=trending&theme=dark" /><source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/badge?repo=MHSanaei/3x-ui&type=trending" /><img alt="GitHub Trending Repository of the Day" src="https://api.star-history.com/badge?repo=MHSanaei/3x-ui&type=trending" /></picture>
 </a>
</p>
