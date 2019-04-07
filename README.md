# CancerGenomics
Some useful tools for cancer genome processing developed by Li lab

如果要添加实验室的其它函数，需要
* 下载这个文件夹到本地
* R环境中要有roxygen2和devtools两个包，如果没有,请在R环境下使用install.packages安装
* 用Rstudio打开文件夹内的CancerGenomics.Rproj，打开R工程
* 在工程里面新建新的R脚本，放再里面名称为R的文件夹，可以参照已经存在的脚本，如果函数有依赖的包的话，还需要修改DESCRIPTION文件
* 最后运行devtools::document()，生成文本，看是否有问题
* Rstudio的Build - Check Package里面可以测试生成包是否有问题，有一些错误和warning可以酌情允许，还需要查看man里面的帮助文档是否有问题
