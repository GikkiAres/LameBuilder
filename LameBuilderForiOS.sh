#!/bin/sh

# ------
# User Config
# ------

libPath=/Users/gikkiares/Desktop/0301_MyData/05_音视频开源工具库/01_Lame/01_软件源码/lame-3.100
archs="i386 x86_64 armv7 arm64"

# ------
# Description
# ------

# This shell is to compile lame for ${archs},compile thin lib for each,and then merge them to a fat lib.
# You must configure the lame path and archs you want.
#


# ------
# Program Begin
# ------
author="GikkiAres"
email="GikkiAres@icloud.com"
shellName=LameBuilderForiOS
versionName="0.0.2"
versionCode="0"
updateTime="2020-11-18"
thinDirPath="${libPath}/../Build/Thin"
fatDirPath="${libPath}/../Build/Fat"
cd ${libPath}

function greet() {
    echo "Welcome to use ${shellName},current version is:${versionName}(${versionCode}),update time is:${updateTime}"
    sleep 3
    echo "If you have any problem using this build file,you can communicate me by email address: ${email}"
    sleep 3
    echo "Now let's start,you should have a cup of coffee..."
    sleep 3
}

function complie_i386() {
    archName="i386"
    export CC="xcrun -sdk iphonesimulator clang -arch ${archName}"
    export CFLAGS="-arch ${archName} -fembed-bitcode -mios-simulator-version-min=8.0"
    export LDFLAGS="-arch ${archName} -fembed-bitcode -mios-simulator-version-min=8.0"
    export CPP="${CC} -E"
    export CPPFLAGS=${CFLAGS}
    export CXX=${CC}
    export CXXFLAGS=${CFLAGS}
    export AS="xcrun -sdk iphonesimulator clang"  
    
    ./configure \
        --prefix="${thinDirPath}/${archName}" \
        --disable-shared \
        --enable-static \
        --disable-frontend \
        --host=i386-apple-darwin

    make clean
    make -j8
    make install
}
function complie_x86_64() {
    archName="x86_64"
    export CC="xcrun -sdk iphonesimulator clang -arch ${archName}"
    export CFLAGS="-arch ${archName} -fembed-bitcode -mios-simulator-version-min=8.0"
    export LDFLAGS="-arch ${archName} -fembed-bitcode -mios-simulator-version-min=8.0"
    export CPP="${CC} -E"
    export CPPFLAGS=${CFLAGS}
    export CXX=${CC}
    export CXXFLAGS=${CFLAGS}
    export AS="xcrun -sdk iphonesimulator clang"  

    ./configure \
        --prefix="${thinDirPath}/${archName}" \
        --disable-shared \
        --enable-static \
        --disable-frontend \
        --host=x86_64-apple-darwin

    make clean
    make -j8
    make install
}

function complie_armv7() {
    archName="armv7"
    export CC="xcrun -sdk iphoneos clang -arch ${archName}"
    export CFLAGS="-arch ${archName} -fembed-bitcode -miphoneos-version-min=8.0"
    export LDFLAGS="-arch ${archName} -fembed-bitcode -miphoneos-version-min=8.0"
    export CPP="${CC} -E"
    export CPPFLAGS=${CFLAGS}
    export CXX=${CC}
    export CXXFLAGS=${CFLAGS}
    export AS="xcrun -sdk iphoneos clang"  
    
    ./configure \
        --prefix="${thinDirPath}/${archName}" \
        --disable-shared \
        --enable-static \
        --disable-frontend \
        --host=arm-apple-darwin

    make clean
    make -j8
    make install
}

function complie_arm64() {
        archName="arm64"
        export CC="xcrun -sdk iphoneos clang -arch ${archName}"
        export CFLAGS="-arch ${archName} -fembed-bitcode -miphoneos-version-min=8.0"
        export LDFLAGS="-arch ${archName} -fembed-bitcode -miphoneos-version-min=8.0"
        export CPP="${CC} -E"
        export CPPFLAGS=${CFLAGS}
        export CXX=${CC}
        export CXXFLAGS=${CFLAGS}
        export AS="xcrun -sdk iphoneos clang"  

    ./configure \
        --prefix="${thinDirPath}/${archName}" \
        --disable-shared \
        --enable-static \
        --disable-frontend \
        --host=aarch64-apple-darwin       

    make clean
    make -j8
    make install
}


#1 要用的函数
function printVarOfName() {
    name=$1
    eval value=\$$1
    if [ "$value" ]
    then
        echo "$name is : \n$value"
    fi
}

function mergeThinToFat() {
    echo "Merge,begin"
    #创建胖子库/lib文件夹
    mkdir -p $fatDirPath/lib
    set - $archs
    cd $thinDirPath/$1/lib
    for libName in *.a
    do
        # 针对当前目录的每一个.a文件,从thinDir中,寻找同名的,进行合并
        # 放到变量之中后,变成一个字符串了,而不是数组.
        thinLibPath=`find $thinDirPath -name $libName`
        printVarOfName thinLibPath
        lipo -create `find $thinDirPath -name $libName` -output $fatDirPath/lib/$libName
    done

    # 复制头文件到fatDirPath/include下
    cp -rf $thinDirPath/$1/include $fatDirPath

    echo "Merge,compete"
}

function finish() {
    echo "All job finished."
}


greet
complie_x86_64
complie_i386
complie_armv7
complie_arm64
mergeThinToFat
finish
