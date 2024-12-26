# ArcBlock Blog

本项目实现了一个 ArcBlock 博客阅读器 App，使用 Swift 和 UIKit 构建，包管理使用 Swift Package Manager

## 快速开始

1. 克隆项目
```bash
git clone git@github.com:Choyi/ArcBlockBlog.git
cd ArcBlockBlog
```

2. 打开项目
```bash
open ArcBlockBlog.xcodeproj
```

3. Build & Run

## 功能介绍

- 适配了 Light 和 Dark 模式
- 适配 iPhone 和 iPad
- App 首次启动后加载骨架屏，成功获取数据后，再次启动会加载上次缓存的数据
- 博文列表展示了封面、标题、标签、发布时间等信息
- 列表支持下拉刷新获取最新数据，上拉加载历史数据，每页加载 20 条
- 点击博文可进入详情页，使用 SFSafariViewController 展示
- 由于封面图分辨率比较大，所以加载时会做适当缩小，降低内存消耗
- 列表加载出错时，显示友好的错误提示页面
- 点击右上角设置进入设置页，可进行缓存的清除
- 图标使用了 SF Symbols

## 依赖

- Alamofire: 网络请求
- Cache: 缓存数据和持久化
- MJRefresh: 下拉刷新和上拉加载
- SDWebImage: 图片加载和缓存
- SnapKit: AutoLayout 布局
- Then: 简化初始化语法

## 构建环境

- iOS 13.0+
- Xcode 16.1

## 许可证

MIT License
