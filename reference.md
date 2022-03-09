# CCNUthesis参考文献格式问题

您好，我是 `CCNUthesis`（华中师范大学学位论文模版） 的开发者，关于参考文献的格式想请教一些问题。

由于这个模版是2022年2月左右开发，目前还只针对数学与统计学学院的本科学位论文（开发的本意是想将数统学院老师用 `CTeX` 套装写的旧模版重新基于 `fduthesis` 进行重写，与教务处的一些细节有略微差别，且不知道其它学院的要求，所以暂时只支持数统学院；由于我只能获得教务处关于本科学位论文的 `word` 模版，关于硕士和博士暂不知道要求，但未来有意向继续开发）

我曾经向 `zepinglee` 请教过能否用 `bibtex` 处理，但是华中师范大学的2018级的参考文献要求中有一项“全角”符号的要求，`zepinglee` 说 `bst` 改起来会比较麻烦，让我来请教一下您。

下面只对《关于毕业论文注释与参考文献著录格式
修订的通知》（华中师范大学本科生院（党委学工部）2021年1月4日）（下面简称为《通知》）中的“理工科毕业论文注释与参考文献的格式说明”进行了测试，对于文科部分等以后有需要再进行开发



## 关于《通知》中对于标点的要求

![](https://images.gitee.com/uploads/images/2022/0309/104515_abae2fa8_7693572.png)



## 关于《通知》中列举的11种文献类型

**注** 以下的测试效果均在

```latex
\usepackage[backend = biber,style = gb7714-2015]{biblatex}
```
下使用 `xelatex + biber + xelatex * 2` 的编译方式下进行。

其中 `rawtype` 后缀表示没有对数据进行处理；`CCNUtype` 后缀表示通过某些手段（比如调整了数据所在的 `filed` 等操作）让最终达到学校的效果

### 期刊文献

#### 格式

作者．题名[文献类型标识]．刊名（外文刊名写全称，不缩写），出版年，卷（期）：起讫页码．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/103935_1802752d_7693572.png)

#### 编译测试1

- `bib`中的代码
  ```latex
  @article{李晓东rawtype,
    author          = {李晓东 and 张庆红 and 叶瑾琳},
    title           = {气候学研究的若干理论问题},
    journaltitle    = {北京大学学报：自然科学版},
    year            = {1999},
    volume          = {35},
    number          = {1},
    pages           = {101-106}
  }
  ```
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0309/105007_e5728bf4_7693572.png)
- 与学校要求的差异
  - “.”需要是全角“.”
  - “，”需要是中文的全角逗号
  - “期 number”数据的括号需要是中文括号（）


#### 编译测试2

**注**：下面的“Steven Ahn”的“Steven”是我自己加的（为了测试效果），《通知》里是“Ahn S”，我实在没查到“S”全称，但是查到了“Tanksley SD”的全称

- `bib`中的代码
  ```latex
  @article{Ahnrawtype,
    author          = {Steven Ahn and Steven D. Tanksley},
    title           = {Comparative linkage maps of the rice and maize genomes},
    journaltitle    = {Proceedings of the National Academy of Sciences of the United States of America},
    year            = {1993},
    volume          = {90},
    pages           = {7980-7984}
  }
  ```
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0309/110750_7e4f3143_7693572.png)
- 与学校要求的差异
  - 姓名的大小写差异（可以通过给名字加`{}`，比如 `{Ahn S}` 方式实现，但是这治标不治本，还是希望从格式角度处理）
  - “SD”中间需要无空格


### 杂志（报纸文献）

#### 格式

作者．题名[文献类型标识]．刊名（外文刊名写全称，不缩写），出版年-月-日（版次）．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/103837_240b191c_7693572.png)

#### 编译测试

- `bib`中的代码
  ```latex
  @newspaper{丁文祥rawtype,
    author          = {丁文祥},
    title           = {数字革命与竞争国际化},
    journaltitle    = {中国青年报},
    date            = {2000-11-20},
    number          = {15}
  }
  ```
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0309/111314_7ff2b220_7693572.png)
- 与学校要求的差异
  - “.”需要是全角“.”
  - “，”需要是中文的全角逗号

### 会议论文集

#### 格式

作者．题名[文献类型标识]．见或In：编者（主编或编，外文编者后加ed. 多编者加eds.），文集名. 会议名，会址，会议年．出版地：出版者，出版年：起讫页.

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/103909_23efbc22_7693572.png)


#### 编译测试

- `bib`中的代码
  ```latex
  @inproceedings{邱泽奇rawtype,
    author          = {邱泽奇},
    title           = {建构与分化：当代中国社会结构的过程},
    editor          = {潘乃谷 and 马戎},
    booktitle       = {中国社会学纪念费孝通教授学术活动 60 周年学术讨论会},
    location        = {北京},
    year            = {1998},
    publisher       = {天津：天津农业科技术出版社},
    pages           = {1-10},
    volume          = {volume},
    number          = {number},
    series          = {series},
    address         = {address},
    month           = {month},
    organization    = {organization},
    note            = {note},
  }
  ```
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0309/114026_b8fbccca_7693572.png)
- 与学校要求的差异
  - “.”需要是全角“.”
  - “，”需要是中文的全角逗号


### 会议论文

#### 格式

作者．题名[文献类型标识]．会议名，开会年，会址．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104008_66aa3172_7693572.png)



### 普通图书

#### 格式

作者．书名[文献类型标识]．其他责任者（或译者）．版次（第一版不标注）．出版地：出版者，出版年：起讫页.

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104035_d583f5b7_7693572.png)



### 专著章节或文集

#### 格式

作者．题名[文献类型标识]．见或In：编者（主编或编，外文编者后加ed. 多位编者加eds.），专著（文集）名．出版地：出版者，出版年：起迄页．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104110_8c1e6874_7693572.png)



### 学位论文

#### 格式

作者．论文题目[文献类型标识]．[学位论文]．保存地点：保存学位授予单位，年份．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104151_40e98e82_7693572.png)



### 专利

#### 格式

专利权所有者．专利名称：专利国别，专利号[文献类型标识]．授权日期（年-月-日）．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104218_d44d91bf_7693572.png)



### 技术标准

#### 格式

起草责任者．标准代号．标准顺序号-发布年．标准名称[文献类型标识]．出版地：出版者，出版年．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104249_0aaaba6d_7693572.png)



### 报告

#### 格式

起草责任者．报告名称[文献类型标识]. 发布地点：出版单位，发布时间：起讫页．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104321_618eaf3b_7693572.png)



### 电子资源

#### 格式

作者．题名[电子资源及载体类型标识]．出版地：出版者，出版年：引文页码（更新或修改日期）[引用日期]．获取和访问路径．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104358_4d90d5bc_7693572.png)


