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


#### 编译测试1

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
  - “//”要改为“. 见：”，这个了解到可以通过 `gbpunctin = false`改，但是前面的“.”和“:”效果都是半角，但是学校要求需要全角
  - `editor` 的后面没有“主编”两个字
  - 《通知》中的例子中“...主编，社区研究与社会发展”的“社区研究与社会发展”（<文集名>）不知道填在什么filed里面，了解的几个都试过了，感觉像是 `series`，但前后的标点不同
  - 会议名后面需要是“，”不是“.”
  - 会址后需要是“，”
  - 有一个会议年好像没有接口，`year` 的效果应该是出版年
  - 出版地和出版社前面需要是全角“.”
  - 好像没有出版地的接口，目前是把出版地和出版者统一写在了 `publisher` 里面

#### 编译测试2

- `bib`中的代码
  ```latex
  @proceedings{雷光春rawtype,
    author          = {雷光春},
    title           = {综合湿地管理：综合湿地管理国际研讨会论文集},
    location        = {北京},
    publisher       = {海洋出版社},
    year            = {2012},
  }
  ```
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0309/170725_819841da_7693572.png)
- 与学校要求的差异
  - “.”需要是全角“.”
  - “，”需要是中文的全角逗号


#### 其它

由于《通知》中没有外文的例子，但好像有用户反馈说“In”的“i”需要大写，看了文档，测试了一下下面的代码可行：
```latex
\DefineBibliographyStrings{english}{in={In:\space}}
\DefineBibliographyStrings{english}{incn={见：}}
```


### 会议论文

#### 格式

作者．题名[文献类型标识]．会议名，开会年，会址．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104008_66aa3172_7693572.png)

#### 编译测试1

- `bib`中的代码
  ```latex
  @proceedings{邱泽奇会议论文rawtype,  
    author       = {邱泽奇},
    title        = {建构与分化：当代中国社会结构的过程},
    journaltitle = {中国社会学纪念费孝通教授学术活动 60 周年学术讨论会 },
    year         = {1996},
    address       = {北京},
  }

  @article{邱泽奇会议论文CCNUtype,  
    usera        = {C},
    author       = {邱泽奇},
    title        = {建构与分化：当代中国社会结构的过程},
    journaltitle = {中国社会学纪念费孝通教授学术活动 60 周年学术讨论会 },
    year         = {1996},
    volume       = {北京},
  }
  ```
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0309/172345_8a7c5f5b_7693572.png)

  [9] 为 `rawtype`, [10] 为 `CCNUtype`
- 与学校要求的差异
  - “.”需要是全角“.”
  - “，”需要是中文的全角逗号
  - `proceedings`没有显示 `journaltitle`
  - `proceedings`的开会年和会址需要反过来

`CCNUtype` 是通过 `article` “伪装”并且把“会址”填到 `volumn` 里达到的效果


#### 编译测试2

- `bib`中的代码
  ```latex
  @article{zhangrawtype,  
    author       = {{Zhang Q} and {Gao YJ} and {Yang SH} and {Ragab R}},
    title        = {Molecular marker-based analysis of heterosis in hybrid rice},
    journaltitle = {Abstract, 7th Annual Meeting of the Rockefeller Foundation's International Program on Rice Biotechnology},
    year         = {1994},
    address      = {Bali, Indonesia},
  }

  @article{zhangCCNUtype,  
    usera        = {C},
    author       = {{Zhang Q} and {Gao YJ} and {Yang SH} and {Ragab R}},
    title        = {Molecular marker-based analysis of heterosis in hybrid rice},
    journaltitle = {Abstract, 7th Annual Meeting of the Rockefeller Foundation's International Program on Rice Biotechnology},
    year         = {1994},
    volume       = {Bali, Indonesia},
  }
  ```
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0309/173044_e1c3e153_7693572.png)

  [11] 为 `rawtype`, [12] 为 `CCNUtype`
- 与学校要求的差异
  - `proceedings`没有显示 `journaltitle`
  - `proceedings`的开会年和会址需要反过来
  - 姓名由于查找原文不方便，下用我的姓名进行了测试：
    - 三种输入：`Xia KangWei and Xia Kang Wei and Xia Kangwei`
    - 输出：`KANGWEI X, WEI X K, KANGWEI X`
    - 按照《通知》的示例，希望的效果是 `Xia KW`
    - 由于这里是中文名，如果是英文名能否像`article`上面的编译代码一样处理？如果中英文名混杂是否不方便？还是需要用户直接就`{Xia KW}`这样输入更方便？
    - （顺便一问，请问三个当中哪个是正确的输入？）

`CCNUtype` 是通过 `article` “伪装”、把“会址”填到 `volumn` 里、并用`{}`保持姓名原样输出达到的效果



### 普通图书

#### 格式

作者．书名[文献类型标识]．其他责任者（或译者）．版次（第一版不标注）．出版地：出版者，出版年：起讫页.

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104035_d583f5b7_7693572.png)

#### 编译测试1

- `bib`中的代码
  ```latex
  @book{马克思rawtype,
    title        = {马克思恩格斯选集（第1卷）},
    location     = {北京},
    publisher    = {人民出版社},
    year         = {1995},
    pages        = {22-23},
  }
  @book{昂温CCNUtype,
    author       = {{昂温, G} and {昂温, PS}},
    title        = {外国出版史},
    translator   = {陈生铮},
    location     = {北京},
    publisher    = {中国书籍出版社},
    year         = {1988},
  }
  ```
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0309/182505_168c4193_7693572.png)
- 与学校要求的差异
  - “.”需要是全角“.”
  - “，”需要是中文的全角逗号
  - “：”需要时中文的冒号

请问“昂温, G”这种中英一起的正确输入是说明呢？


#### 编译测试2

- `bib`中的代码
  ```latex
  @book{Fothrawtype,
    author       = {Henry D. Foth},
    title        = {Fundamentals of soil science},
    edition      = {7},
    location     = {New York},
    publisher    = {John Wiley & Sons},
    year         = {1984},
    pages        = {151-159},
  }
  ```
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0309/183259_dacea81c_7693572.png)
- 与学校要求的差异
  - 依旧是英文名的区别，需要效果是“Foth HD”


### 专著章节或文集

#### 格式

作者．题名[文献类型标识]．见或In：编者（主编或编，外文编者后加ed. 多位编者加eds.），专著（文集）名．出版地：出版者，出版年：起迄页．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104110_8c1e6874_7693572.png)

#### 编译测试1

- `bib`中的代码
  ```latex
  @inbook{杨国枢rawtype,
    author       = {杨国枢},
    title        = {中国人对现代化的反应：心理学的观点},
    editor       = {乔健},
    booktitle    = {中国人的观念与行为},
    location     = {天津},
    publisher    = {天津人民出版社},
    year         = {1995},
    pages        = {209-239},
  }
  @inbook{杨国枢CCNUtype,
    author       = {杨国枢},
    title        = {中国人对现代化的反应：心理学的观点},
    booktitle    = {乔健主编, 中国人的观念与行为},
    location     = {天津},
    publisher    = {天津人民出版社},
    year         = {1995},
    pages        = {209-239},
  }
  ```
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0309/234208_d24746b9_7693572.png)

  [16] 为 `rawtype`, [17] 为 `CCNUtype`
- 与学校要求的差异
  - “.”需要是全角“.”
  - “，”需要是中文的全角逗号
  - “：”需要是全角
  - 缺少“主编”二字
  - 主编后主要是“，”

`CCNUtype`是把主编放在了`booktitle`里达到的效果

#### 编译测试1

- `bib`中的代码
  ```latex
  @inbook{Morisonrawtype,
    author       = {James I L Morison},
    title        = {Intercellular $\mathrm{CO}_2$ concentration and stomatal responses to $\mathrm{CO}_2$},
    editor       = {Zeiger E},
    booktitle    = {Stomatal Function},
    location     = {Stanford},
    publisher    = {Stanford University Press},
    year         = {1987},
    pages        = {229-251}
  }
  @inbook{MorisonCCNUtype,
    author       = {{Morison JIL}},
    title        = {Intercellular $\mathrm{CO}_2$ concentration and stomatal responses to $\mathrm{CO}_2$},
    booktitle    = {Zeiger E, Farquhar GD, Cowan IR eds., Stomatal Function},
    location     = {Stanford},
    publisher    = {Stanford University Press},
    year         = {1987},
    pages        = {229-251}
  }
  ```
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0309/235158_450e33ce_7693572.png)

  [18] 为 `rawtype`, [19] 为 `CCNUtype`
- 与学校要求的差异
  - 主编的名字需要和author一样的处理
  - 缺少 “ed” 和 “eds”
  - 主编后主要是“, ”


### 学位论文

#### 格式

作者．论文题目[文献类型标识]．[学位论文]．保存地点：保存学位授予单位，年份．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104151_40e98e82_7693572.png)

#### 编译测试

- `bib`中的代码
  ```latex
  @phdthesis{张志祥rawtype,
    author       = {张志祥},
    title        = {间断动力系统的随机扰动及其在守恒律方程中的应用},
    location     = {北京},
    institution  = {北京大学},
    year         = {1998}
  }
  @mastersthesis{徐秀英rawtype,
    author       = {徐秀英},
    title        = {家庭教育对低年级小学生语文学习习惯的影响及对策研究},
    location     = {武汉},
    institution  = {华中师范大学},
    year         = {2013}
  }
  @mastersthesis{Aldemitarawtype,
    author       = {Rhodora Romero Aldemita},
    title        = {Genetic Engineering of rice: Agrobacterium tumefaciens-mediatedtransformation of rice and evaluation of a corn pollen-specific promoter using the gusA gene in transgenic rice},
    location     = {West Lafyatte},
    publisher    = {Purdue University},
    year         = {1998}
  }
  ```
  其中，我进行了相关设置：
  ```latex
  \usepackage[..., gbfieldtype = true]{biblatex}
  ...
  \DefineBibliographyStrings{english}{mathesis={(Master dissertation)}}
  \DefineBibliographyStrings{english}{mathesiscn={[硕士学位论文]}}
  \DefineBibliographyStrings{english}{phdthesis={(Ph D dissertation)}}
  \DefineBibliographyStrings{english}{phdthesiscn={[博士学位论文]}}
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0310/000716_33b1c19f_7693572.png)

- 与学校要求的差异
  - 中文的文献中“.”需要是全角“.”
  - 中文的文献中“，”需要是中文的全角逗号
  - 英文作者的author还是上述的大写问题

<!-- #### 编译测试

- `bib`中的代码
  ```latex
  
  ```
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0309/105007_e5728bf4_7693572.png)
- 与学校要求的差异
  - “.”需要是全角“.”
  - “，”需要是中文的全角逗号 -->

### 专利

#### 格式

专利权所有者．专利名称：专利国别，专利号[文献类型标识]．授权日期（年-月-日）．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104218_d44d91bf_7693572.png)

#### 编译测试

- `bib`中的代码
  ```latex
  @patent{张凯军rawtype,
    author       = {张凯军},
    title        = {轨道火车及高速轨道火车紧急安全制动辅助装置},
    location     = {China},
    number       = {201220158825.2},     
    date         = {2012-04-05}
  }
  @patent{Kosekrawtype,
    author       = {{Kosek A} and {Momose H} and {Kawahito M} and {Alan Turling}},
    title        = {Compiler},
    location     = {US},
    number       = {828402},     
    date         = {2002-05-25}
  }
  @patent{KosekCCNUtype,
    author       = {{Kosek A} and {Momose H} and {Kawahito M} and {Alan Turling}},
    title        = {Compiler},
    number       = {US, 828402},     
    date         = {2002-05-25}
  }
  ```
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0310/001850_2617e56a_7693572.png)

  [23][24] 为 `rawtype`, [25] 为 `CCNUtype`
- 与学校要求的差异
  - 中文的文献中“.”需要是全角“.”
  - 中文的文献中“，”需要是中文的全角逗号
  - 英文作者的 `author` 还是上述的大写问题
  - `location` 需要在 `number` 前面并通过 ", "连接
  - 英文作者的author还是上述的大写问题

### 技术标准

#### 格式

起草责任者．标准代号．标准顺序号-发布年．标准名称[文献类型标识]．出版地：出版者，出版年．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104249_0aaaba6d_7693572.png)

#### 编译测试

- `bib`中的代码
  ```latex
  @standard{文献编写CCNUtype,
    author       = {全国文献工作标准化技术委员会第六分委员会},
    title        = {GB 6447-86. 文献编写规则},
    location     = {北京},
    publisher    = {中国标准出版社},
    year         = {1986}
  }
  ```

  由于没查到“标准代号．标准顺序号-发布年”的处理，就把这个放在了`title`里，不知道有没有相对应的`filed`处理
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0310/002500_54bcfa0e_7693572.png)

- 与学校要求的差异
  - “.”需要是全角“.”
  - “，”需要是中文的全角逗号

### 报告

#### 格式

起草责任者．报告名称[文献类型标识]. 发布地点：出版单位，发布时间：起讫页．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104321_618eaf3b_7693572.png)

#### 编译测试

- `bib`中的代码
  ```latex
  @report{国防白皮CCNUtype,
    author       = {中华人民共和国国务院新闻办公室},
    title        = {国防白皮书：中国武装力量的多样化运用},
    year         = {2013-04-16[2014-06-11]} 
  }
  @report{federalCCNUtype,
    author       = {{U.S. Department of Transportation Federal Highway Administration}},
    title        = {Guidelines for bandling excavated acid-producing materials, PB 91-194001},
    location     = {Springfield},
    institution  = {U.S. Department of Commerce National Information Service},
    year         = {1990},
    pages        = {22-23} 
  }
  @report{healthCCNUtype,
    author       = {{World Health Organization}},
    title        = {Factors regulating the immune response: report of WHO Scientific Group},
    location     = {Geneva},
    institution  = {WHO},
    year         = {1970},
    pages        = {10-11} 
  }
  ```

  由于组织名称特殊性，这里直接加了`{}`保证原样输出
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0310/003348_60319af4_7693572.png)

- 与学校要求的差异
  - 中文文献的“.”需要是全角“.”
  - 中文文献的“，”需要是中文的全角逗号
  - “国防白皮CCNUtype”中如果使用`date`则不显示，放在`year`里才行

### 电子资源

#### 格式

作者．题名[电子资源及载体类型标识]．出版地：出版者，出版年：引文页码（更新或修改日期）[引用日期]．获取和访问路径．

#### 《通知》中的示例

![](https://images.gitee.com/uploads/images/2022/0309/104358_4d90d5bc_7693572.png)

#### 编译测试

- `bib`中的代码
  ```latex
  @online{江向东rawtype,
    author          = {江向东},
    title           = {互联网环境下的信息处理与图书管理系统解决方案},
    usera           = {J},
    journal         = {情报学报},
    number          = {2},
    volume          = {18},
    year            = {1998},
    pages           = {4},
    urldate         = {2000-01-18},
    url             = {http://www.chinainfo.gov.cn/periodical/gbxb/gbxb99/gbxb990203}
  }
  @article{江向东CCNUtype,
    author          = {江向东},
    title           = {互联网环境下的信息处理与图书管理系统解决方案},
    usera           = {J},
    journal         = {情报学报},
    number          = {2},
    volume          = {18},
    year            = {1998},
    pages           = {4},
    urldate         = {2000-01-18},
    url             = {http://www.chinainfo.gov.cn/periodical/gbxb/gbxb99/gbxb990203}
  }
  @online{萧钮CCNUtype,
    author          = {萧钮},
    title           = {出版业信息化迈入快车道},
    year            = {2001-12-19[2002-04-15]},
    url             = {http://www.creader.com/news/20011219/200112190019.html}
  }
  @online{Dublinrawtype,
    title           = {Dublin core metadata element set: version 1.1},
    year            = {2012-06-14},
    urldate         = {2014-06-11},
    url             = {http://dublincore.org/documents/dees/}
  }
  ```

  [20] 为 `rawtype`, [21] 为`CCNUtype`
- 效果
  
  ![](https://images.gitee.com/uploads/images/2022/0310/004315_9673e1b5_7693572.png)

- 与学校要求的差异
  - 中文文献“.”需要是全角“.”
  - 中文文献“，”需要是中文的全角逗号
  - 中文文献需要用全角冒号“：”
  - 对于[20]和[21]如果使用`online`的话无法出现"1999, 18(2): 4"的效果，所以"CCNUtype"里将其改为`article`，请问这个做法是否正确？

这就是我整理出来的学校的参考文献要求和现有的设置的参数的差异。

由于时间较为紧迫，这一届正在使用我开发的这个模版，所以我才想尽早地将参考文献处理好，但是由于本人在开发前对参考文献相关了解甚少，也正如您在`biblatex-zh-cn`项目中说的：
![](https://images.gitee.com/uploads/images/2022/0310/004828_25c514f1_7693572.png)

很多设置我在文档里找起来如大海捞针，而且目前在读研，暂时没有精力把文档读完（但是日后有时间一定会好好钻研），咨询过 `zepinglee` 后，他让我来请教一下您，希望您能在百忙之中为我上述总结的一些问题（尤其是全角的标点）的处理提供一些帮助，我将不胜感激！
