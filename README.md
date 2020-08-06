# LameBuilder

## 使用方法
将该脚本放到lame源码的根目录中.
lame3.1版本源码下载地址为:
[lame3.1源码下载](https://sourceforge.net/projects/lame/files/lame/3.100/lame-3.100.tar.gz/download)

执行命令,编译Lame库
`sh LameBuilderForiOS.sh`

编译结果:
假设dirPath_lameLib为您下载Lame库后放在电脑的路径,
该脚本会分别在
dirPath_lameLib/thin/x86_64
dirPath_lameLib/thin/i386
dirPath_lameLib/thin/armv7s
dirPath_lameLib/thin/arm64
四个目录中,编译对应平台下的库文件
然后将四个平台下的库合并到
dirPath_lameLib/fat中,实际使用时,我们只要把fat中的.a库文件和头文件一起拷贝到项目中去就可以了.

## 版本记录

### V0.0.2  2020-08-06
**1,修复bug,连续编译多个架构时,只有第一次编译成功**
将make clean移到make install后面,并添加make distclean命令,清除掉旧的Makefile文件.
**2,将编译开关打开**
**3,修改README.md**

### V0.0.1  2020-04-16
first commit
