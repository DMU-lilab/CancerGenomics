# CancerGenomics
Some useful tools for cancer genome processing developed by Li lab

### installation
#### Option 1(Recommended)
Using devtools
```
install.packages("devtools")
library(devtools)
install_github("DMU-lilab/CancerGenomics")
```
### Option 2
Manual installation
#### Checkout the latest release of CancerGenomics from GitHub
```git clone https://github.com/DMU-lilab/CancerGenomics.git```
#### Install R dependencies (in R)
 ```install.packages("data.table") # version > 1.10.4```

#### Install the CancerGenomics package
From the command line and in the directory where CancerGenomics github was cloned.
```R CMD INSTALL CancerGenomics ```


如果要添加实验室的其它函数，需要
* 下载这个文件夹到本地,直接下载或者用git
```
git clone https://github.com/DMU-lilab/CancerGenomics.git
```
* R环境中要有roxygen2和devtools两个包，如果没有,请在R环境下使用install.packages安装

```
install.packages("roxygen2")
install.packages("devtools")
```
* 用Rstudio打开文件夹内的CancerGenomics.Rproj，打开R工程
* 在工程里面新建新的R脚本，放在里面名称为R的文件夹，可以参照已经存在的脚本，如果函数有依赖的包的话，还需要修改DESCRIPTION文件
* 最后运行
```
devtools::document()
```
生成文本，看是否有问题
* Rstudio的Build - Check Package里面可以测试生成包是否有问题，有一些错误和warning可以酌情允许，还需要查看man里面的帮助文档是否有问题
* 使用git上传同步，需要有修改的权限，在CancerGenomics文件夹下，linux命令
```
git add *
git commit -m "msg" # "msg"就是为什么修改，修改了什么
git push -u origin master
```
这个时候输入帐号密码就可以同步了



