#!/bin/sh

VERSION="0.0.2"
AUTHOR="GikkiAres"
EMAIL="GikkiAres@icloud.com"
echo "Welcome to use lame builder for iOS,version:${VERSION}"
sleep 3
echo "If you have any problem using this build file,you can communicate with the author by email address: ${EMAIL}"
sleep 3
echo "Now let's starting,you should have a cup of coffee..."

#1 指定要编译的指令集,常见的有arm64,armv7s,x86_64,i386, armv7已经比较旧了.
#ARCHS="arm64 armv7s x86_64 i386"
ARCHS="i386 x86_64 arm64 armv7s"

#2 指定路径
#2.1 当前路径,应该将该sh文件,放到库的根目录下.
CWD=`pwd`
#2.2 各个指令集的单独库的目录路径
THIN="${CWD}/thin"
#2.3 混合库的目录路径
FAT="${CWD}/fat"

#3 configure参数
CONFIGURE_FLAGS="--enable-static --disable-shared --disable-frontend"
#host,目标机器指令集
HOST=""
# 本机的指令集
ARCH_SELF=""
#CFLAGS
CFLAGS=""
#LDFLAGS
LDFLAGS=""
#CPPFLAGS
CPPFLAGS=""
#CPU
CPU=""
#AS
AS=""
#CPP
CPP=""
#CXX
CXX=""
#CC
CC=""
#prefix,输出文件夹,绝对路径
PREFIX=""
# 配置的完整命令
CONFIGURE_CMD=""
# 导出的库的name,在运行中得到;
LIB=""

#4 是否编译和是否合并
COMPILE=1
LIPO=1

# --------- Complile start ---------

if [ $COMPILE == 1 ]
then
	echo "Compile begin... "
	for ARCH in $ARCHS
	do
		echo "Building binariy for $ARCH..."
        sleep 3

		if [ $ARCH = "i386" -o $ARCH = "x86_64" ]
		then
			PLATFORM="iPhoneSimulator"
			if [ "$ARCH" = "x86_64" ]
			then
				HOST="--host=x86_64-apple-darwin"
			else
				
				HOST="--host=i386-apple-darwin"
			fi
		else
			PLATFORM="iPhoneOS"
			if [ $ARCH = "arm64" ]
			then
                HOST="--host=arm-apple-darwin"
			else
				HOST="--host=arm-apple-darwin"
			fi
			
		fi
        CFLAGS="-arch $ARCH -fembed-bitcode -miphoneos-version-min=7.0"
        #将PLATFORM的值全部小写
		XCRUN_SDK=`echo $PLATFORM | tr [:upper:] [:lower:]`
		CC="xcrun -sdk $XCRUN_SDK clang -arch $ARCH"
		CXXFLAGS="$CFLAGS"
		LDFLAGS="$CFLAGS"
		PREFIX="$THIN/$ARCH"
        # 使用./config.guess命令得到本机的指令集,该程序由库文件提供
        ARCH_SELF=`./config.guess`

        echo "\$configure_flags is : $CONFIGURE_FLAGS"
        echo "\$HOST is : $HOST"
        echo "\$CPU is : $CPU"
        echo "\$CC is : $CC"
        echo "\$CXX is : $CXX"
        echo "\$CPP is : $CPP"
        echo "\$AS is : $AS"
        echo "\$CFLAGS is : $CFLAGS"
        echo "\$LDFLAGS is : $LDFLAGS"
        echo "\$CPPFLAGS is : $CPPFLAGS"
        echo "\$prefix is : $PREFIX"
        echo "\$ARCH_SELF is : $ARCH_SELF"

  # 必要的编译参数:CONFIGURE_FLAGS HOST BUILD CC CFLAGS LDFLAGS PREFIX
  # 非必要的:CXX CPP AS
		CONFIGURE_CMD="$CWD/configure $CONFIGURE_FLAGS $HOST --build=$ARCH_SELF $CPU CC=$CC CXX=$CC CPP=$CC -E $AS CFLAGS=$CFLAGS LDFAGS=$LDFLAGS CPPFLAGS=$CFLAGS --prefix=$PREFIX"
		echo "Configure command is: $CONFIGURE_CMD"
        
		$CWD/configure \
		$CONFIGURE_FLAGS \
		$HOST \
		--build=$ARCH_SELF \
		CC="$CC" \
		CFLAGS="$CFLAGS" \
		LDFLAGS="$LDFLAGS" \
		--prefix="$PREFIX"
#        CXX="$CC" \
        CPP="$CC -E" \
        AS="$AS" \
        $CPU \
        CPPFLAGS="$CFLAGS" \

        
		make -j8
		make install
		echo "Building binariy for $ARCH finish"
        make clean
        make distclean

		#显示该架构下的lib库文件信息.
        cd $THIN/$ARCH/lib/
        for LIB in *.a
        do
            lipo -info $THIN/$ARCH/lib/$LIB
        done
	done
	echo "Compile finish."
else
	echo "Choose not compile ..."
fi

if [ $LIPO == 1 ]
then
    echo "Building fat binaries,start."
    #创建文件夹FAT/lib
    mkdir -p $FAT/lib
    set - $ARCHS
    CWD=`pwd`
    cd $THIN/$1/lib
    for LIB in *.a
    do
        echo "\$LIB is $LIB"
        #创建查找命令,查找THIN目录下,各个架构的库文件.
        cmdFind="find $THIN -name $LIB"
        echo "cmdFind is : \n $cmdFind"
        #`执行并保存结果,结果为一个字符串数组.
        resFind=`$cmdFind`
        echo "result of find is : \n $resFind"
        FAT_LIB="$FAT/lib/$LIB"
        echo "Output file is: $FAT_LIB"
        echo "cmdLipo is: lipo -create `$cmdFind` -output $FAT_LIB"
        lipo -create `$cmdFind` -output $FAT_LIB
    done
    # 把第一个架构的头文件移到FAT中,头文件都是一样的.
    cp -rf $THIN/$1/include $FAT
    lipo -info $FAT/lib/$LIB
    echo "Building fat binaries,finish."
fi
echo "Operation done."
