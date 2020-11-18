# 脚本名称

LameBuilderForiOS

# 使用方法
## 下载源码

将该脚本放到lame源码的根目录中.
lame3.1版本源码下载地址为:
[lame3.1源码下载](https://sourceforge.net/projects/lame/files/lame/3.100/lame-3.100.tar.gz/download)

## 配置参数

### 配置源码路径

假设dirPath_lameLib为您下载Lame库后放在电脑的路径.

需要在脚本中,设置libPath为该路径.

### 配置要编译的架构

在archs中,设定要编译的架构,默认为"i386 x86_64 armv7 arm64"

## 运行脚本

执行命令,编译Lame库
`sh LameBuilderForiOS.sh`

## 编译结果

该脚本会分别在
dirPath_lameLib/../Build/Thin/x86_64
dirPath_lameLib/../Build/Thin/i386
dirPath_lameLib/../Build/Thin/armv7s
dirPath_lameLib/../Build/Thin/arm64
四个目录中,编译对应平台下的库文件
然后将四个平台下的库合并到
dirPath_lameLib/../Build/Fat中

实际使用时,我们只要把fat中的.a库文件和头文件一起拷贝到项目中去就可以了.

# 版本记录

### 0.0.3(0) 2020-11-18

1,调整脚本结构,便于阅读.

### V0.0.2  2020-08-06
**1,修复bug,连续编译多个架构时,只有第一次编译成功**
将make clean移到make install后面,并添加make distclean命令,清除掉旧的Makefile文件.
**2,将编译开关打开**
**3,修改README.md**

### V0.0.1  2020-04-16
first commit

