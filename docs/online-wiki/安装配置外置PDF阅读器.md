# 如何安装配置外置PDF阅读器？

本文主要介绍如何安装配置 Mac 系统上的外置 PDF 阅读器。Windows 用户使用 VS Code 自带的内部阅读器已经足够，可以满足双向链接，如果有需要可以配置 SumatraPDF，具体可以看啸行大佬（`install-latex-guide-zh-cn`的编者）写的「[《SumatraPDF 阅读器的配置方法》](https://gitee.com/OsbertWang/latex-editor-sumatrapdf/attach_files/686232/download/main.pdf)」。ubuntu 系统我不了解，为了避免误导还是请用自行去查询

**声明：是否安装外置 PDF 阅读器完全凭个人喜好和需求，并不强求**


## Mac 系统

我个人是 Mac 系统，Skim 阅读器使用体验还是很不错的：

- 和一般的 Acrobat 等PDF阅读器比，它可以设置“检查文件变化”并“自动重新加载”的效果，也就是编译后不需要关闭再重新打开来查看，一直开着就可以及时查看编译效果。

- 可以配置正向搜索和反向搜索外

但是这些功能，VS Code的内部阅读器已经具有，那为什么还推荐安装Skim呢？那就要提及它的交叉引用的预览功能，只需要鼠标悬浮在链接处就会出现对应的预览图，这个对于有很多定理类环境或是图表引用的用户还是很方便的：

![skim鼠标悬浮](https://images.gitee.com/uploads/images/2022/0302/104647_952b5bcc_7693572.png "skim鼠标悬浮.png")

###  如何下载

1. 打开官网：<https://skim-app.sourceforge.io/>

![Skim下载](https://images.gitee.com/uploads/images/2022/0302/151928_d1681378_7693572.png "屏幕截图.png")

2. 点击`Download`，然后等待下载即可。

### 如何配置

#### 配置Skim

下载完成后正常安装后，打开skim软件进行配置：

1. 点击左上角的`skim`，然后点击`选项`
![输入图片说明](https://images.gitee.com/uploads/images/2022/0302/155108_6c36f6fb_7693572.png "屏幕截图.png")

2. 如果打开界面是`一般`的，点击右上角的`>>`然后点击`同步`
![skim-同步](https://images.gitee.com/uploads/images/2022/0302/155220_e5651da1_7693572.png "屏幕截图.png")

3. 将两个框选打勾，并且把下面的`预设`改为`Visual Studio Code`
![skim-同步](https://images.gitee.com/uploads/images/2022/0302/155208_36965386_7693572.png "屏幕截图.png")


#### 配置VS Code

按照另一篇配置 VS Code 的 wiki 操作完之后，把下面的代码加到 `setting.json` 的 `{}` 内并**保存！保存！保存！**（配置 VS Code 的 wiki 中 `setting.json` 的配置没有外界阅读器部分，所以这里需要额外加）：

```json
"latex-workshop.view.pdf.viewer": "external",
  "latex-workshop.view.pdf.external.synctex.command": "/Applications/Skim.app/Contents/SharedSupport/displayline",
  "latex-workshop.view.pdf.external.synctex.args": [
    "-r",
    "%LINE%",
    "%PDF%",
    "%TEX%"
  ],
  "latex-workshop.view.pdf.external.viewer.command": "/Applications/Skim.app/Contents/SharedSupport/displayline",
  "latex-workshop.view.pdf.external.viewer.args": [
    "0",
    "%PDF%"
  ],
```

## Windows 下的外部阅读器

![](https://raw.githubusercontent.com/syvshc/image/master/CCNUwiki/sumatrapdf-settings.png)

Windows 下支持反向搜索的阅读器可以使用 SumatraPDF, 下载地址: https://www.sumatrapdfreader.org/download-free-pdf-viewer , 通常我们下载 64 位的安装 (64 bit installer) 版本, 当然便携版 (Portable version) 也可以完成相应的操作. 具体操作方法见「[如何安装、配置和使用VS Code?](https://gitee.com/xkwxdyy/CCNUthesis/wikis/%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98FAQ/%E5%A6%82%E4%BD%95%E5%AE%89%E8%A3%85%E3%80%81%E9%85%8D%E7%BD%AE%E5%92%8C%E4%BD%BF%E7%94%A8VS Code?sort_id=5310425#%E5%A6%82%E4%BD%95%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE%E5%92%8C%E4%BD%BF%E7%94%A8VS Code)」


## Linux 下的外部阅读器

Linux 下我使用过 KDE 桌面的 Okular, 通常来说会随桌面进行安装, 如果是非 KDE 桌面, 可以使用包管理器 (如 `apt`, `pacman`, `sanp` 等) 进行安装, 这里不多赘述.