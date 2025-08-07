# install-latex-guide-zh-cn 文档补充

## 为什么只推荐这个文档安装

首先看一下这个文档的前言：

![install-latex-guide-zh-cn前言](https://images.gitee.com/uploads/images/2022/0228/155904_5cff65a9_7693572.png "屏幕截图.png")

- LaTeX 工作室有上千人的几个大群，经常有各种各样的安装问题，啸行和一些其他大佬将遇到的问题解决总结，写了这篇文档。**你要相信，你遇到的安装问题，早有别人遇到过**，在这个上面极大概率能找到解决办法

- 上面的内容非常全面，包括了 `TeXstudio`、`VScode` 等编辑器的安装和 `overleaf` 的使用介绍



## 如何阅读这个文档

我的建议是第一次读的话，**不要边看边安装，而是先把自己电脑系统的部分完整阅读一遍，有什么需要注意的，自己先心中有数再开始安装**

### Windows用户

首先明确自己之前是否安装过 `CTeX` 套装

- 如果安装过 `CTeX` 套装，请 
  1. **卸载 CTeX 套装** 
  2. 跟着 `1.1 安装TeXLive` 部分先解决 `system32` 丢失的问题
  3. 查看用户名是否是中文，是的话要改成英文，否则会影响安装
  4. 开始安装 `TeX Live`

其中第 3 步是绝大 Windows 用户遇到的最多的问题
![](https://images.gitee.com/uploads/images/2022/0316/010628_0e731039_7693572.png)

- 没安装过 `CTeX` 套装
  
  按照说明的下载镜像地址中下载`iso`文件后，一般不用`检查其MD5值`(来自`1.1 安装TeXLive`)，通常直接处理用户名的中英文问题然后开始安装即可


### MacOs用户

我自己就是mac用户，因为本身 `CTeX` 套装无法在 mac 系统上安装，所以 mac 用户不会有 `system32` 丢失之类的问题。

个人建议的话 `3.1 安装Homebrew` 部分可以跳过，虽然 `Homebrew` 是款优秀的软件，但是大部分用户可能暂时用不到，日后有兴趣自己研究即可，否则很多接触代码少的用户更是一头雾水了（这个是真实的用户反馈）

个人是强烈推荐安装 `MacTeX`，是 mac 系统对 `TeXLive` 的打包，安装基本上就是一路点到底然后等待安装完成即可，非常方便，具体网址是：
<https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/mac/mactex>

然后点击 `MacTeX .pkg` 即可下载

![MacTeX ](https://images.gitee.com/uploads/images/2022/0228/163829_dae1f740_7693572.png "屏幕截图.png")

如果下载慢或者打不开的话，就需要换一个源，手册的附录有不同地区的源，自己按需选择即可。（但不同的源的结构基本是一样的，也就是说跟着 `.../CTAN/systems/mac/mactex` 这个顺序大概率可以找到新的源的 `MacTeX` 下载地址，如果不是的话，不会差多少。


### Ubuntu用户

我没用过 ubuntu 系统，但是好像安装会更快，跟着文档的相应部分安装即可