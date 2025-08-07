## 卸载了 `CTeX` 套装，安装了 `TeX Live` 却无法编译参考文献怎么办？

### 先确认是不是环境变量的问题

如果是安装了 `CTeX` 套装，卸载并安装了 `TeX Live`后，用户可能会发现无法编译参考文献（但是正常的 `xelatex` 编译是可行的）。

当用户发现 `xelatex` 正常，`biber` 或者 `latexmk` 失效时，可以通过下面的步骤进行自查：

1. 终端进入到 `CCNUthesis.v.x.x.x` 的目录下（VScode 的话就点击「终端」，「新建终端」，然后有个弹窗出来）
2. 输入
   ```bash 
   xelatex main
   ```
   回车，等待编译结束
3. 输入
   ```bash 
   biber main
   ```
   回车

如果此时提示信息是
```bash
INFO - This is Biber 2.17
INFO - Logfile is 'main.blg'
INFO - Reading 'main.bcf'
INFO - Found 29 citekeys in bib section 0
INFO - Processing section 0
INFO - Looking for bibtex file 'CCNUthesis-main.bib' for section 0
INFO - LaTeX decoding ...
INFO - Found BibTeX data source 'CCNUthesis-main.bib'
INFO - Overriding locale 'en-US' defaults 'variable = shifted' with 'variable = non-ignorable'
INFO - Overriding locale 'en-US' defaults 'normalization = NFD' with 'normalization = prenormalized'
INFO - Sorting list 'none/global//global/global' of type 'entry' with template 'none' and locale 'en-US'
INFO - No sort tailoring available for locale 'en-US'
INFO - Writing 'main.bbl' with encoding 'UTF-8'
INFO - Output to main.bbl
...
```
那么环境变量大概率没有问题，这个时候要看有没有 `ERROR`，如果有的话就是 `bib`文件里面有错误，自己核查一下，而且一般这个报错信息会提示你哪里错了，一般根据提示就可以解决；如果没有 `ERROR` 的话就要考虑自己写的 `.tex` 文件里的问题了，但是这个时候一般在 `xelatex main` 的时候就会报错的，所以一般不会。

如果此时的提示信息是
```bash
Error unlinking file C:\WINDOWS\TEMP\...
```
![](https://images.gitee.com/uploads/images/2022/0409/233841_5b4ccf9a_7693572.png)

恭喜你，问题找到了，那么接下来我们就来解决这个问题。


### 如果是环境变量的问题，如何解决？


1. 在电脑的 D 盘或者其它盘里新建一个 `temp` 命名的空白文件夹（下面以 D 盘为例）![](https://images.gitee.com/uploads/images/2022/0409/235150_30f85e97_7693572.png)
2. 右击桌面的「此电脑」（注意不能是快捷方式），点击「属性」![](https://images.gitee.com/uploads/images/2022/0409/234208_6910b40f_7693572.png)
3. 左上角的搜索框内输入“环境变量”，点击「编辑系统环境变量」 ![](https://images.gitee.com/uploads/images/2022/0409/234335_20131187_7693572.png)
4. 点击「环境变量」![](https://images.gitee.com/uploads/images/2022/0409/234517_e1ca7286_7693572.png)
5. 下面要做的就是把上下两个地方的 `TEMP` 和 `TMP` （一共四个）从 `C:\WINDOWS\TEMP` 改到我们新建的目录 `D:\temp` ![](https://images.gitee.com/uploads/images/2022/0409/234617_fb879da9_7693572.png)
6. 选中 `TEMP` 点击「编辑」后点击「浏览目录」，找到「此电脑」-「本地磁盘(D:)」-「temp」，然后「确定」（或者直接把「变量值(V)」的内容改为 `D:\temp`，用「浏览目录」方法的最终效果是一样的）![](https://images.gitee.com/uploads/images/2022/0409/235031_e39651fe_7693572.png)
7. 其余的三个同理修改
8. 最后编辑 「系统变量」 中的 `path` 或 `PATH`![](https://images.gitee.com/uploads/images/2022/0409/234118_d8dcc6c7_7693572.png)
9. 点击「浏览」通过和上面一样的方式找到 `D:\temp`, 也可以「新建」，然后输入 `D:\temp`，最后点击确定![](https://images.gitee.com/uploads/images/2022/0409/234115_b911ec3e_7693572.png)
10. 搞定！回去重新测试一下，基本就没问题了


注意：修改完环境变量后，**修改之前打开的终端（包括 VScode 的）要彻底关掉重新开（如果后面有用到的话），否则它还是采用之前的设置**