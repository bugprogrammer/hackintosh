#bin/bash

clear
echo '脚本开始执行。'
echo '正在进行环境检测。'

os=$(uname -s)

if [ $os != 'Darwin' ]; then
	echo '您的操作系统不是macOS，该脚本只支持macOS'
    exit;
fi
echo '您的操作系统是macOS，继续'
xcode-select --install
echo -e "\033[32m请注意您的电脑是否出现弹窗，如出现弹窗，请点击最右侧的安装按钮，安装结束后按回车继续。如果未出现弹窗直接按回车继续: \033[0m"
read n1

echo -e "\033[32m\n欢迎使用Bugprogrammer的Hackintosh常用kext以及Bootloader编译脚本，请输入序号。
如需编译多个项目，请按,隔开。输入完成按回车结束输入(如1,3,6回车).如需编译全部请按0:\033[0m"

cd ~/Desktop
dir=hackintosh_Plugins_$(date +%Y%m%d%H%M%S)
mkdir -p $dir/Release
mkdir -p $dir/Sources
cd $dir/Sources

buildArray=(
     'Clover,https://github.com/CloverHackyColor/CloverBootloader.git' 
     'OpenCore,https://github.com/acidanthera/OpenCorePkg.git'
     'AppleSupportPkg,https://github.com/acidanthera/AppleSupportPkg.git' 
     'Lilu,https://github.com/acidanthera/Lilu.git'
     'AirportBrcmFixup,https://github.com/acidanthera/AirportBrcmFixup.git'
     'AppleALC,https://github.com/acidanthera/AppleALC.git'
     'ATH9KFixup,https://github.com/chunnann/ATH9KFixup.git'
     'BT4LEContinuityFixup,https://github.com/acidanthera/BT4LEContinuityFixup.git'
     'CPUFriend,https://github.com/PMheart/CPUFriend.git'
     'HibernationFixup,https://github.com/acidanthera/HibernationFixup.git'
     'NoTouchID,https://github.com/al3xtjames/NoTouchID.git'
     'RTCMemoryFixup,https://github.com/acidanthera/RTCMemoryFixup.git'
     'SystemProfilerMemoryFixup,https://github.com/Goldfish64/SystemProfilerMemoryFixup.git'
     'VirtualSMC,https://github.com/acidanthera/VirtualSMC.git'
     'acidanthera_WhateverGreen,https://github.com/acidanthera/WhateverGreen.git'
     'bugprogrammer_WhateverGreen,https://github.com/bugprogrammer/WhateverGreen.git'
     'IntelMausiEthernet,https://github.com/Mieze/IntelMausiEthernet.git'
     'AtherosE2200Ethernet,https://github.com/Mieze/AtherosE2200Ethernet.git'
     'RTL8111,https://github.com/Mieze/RTL8111_driver_for_OS_X.git')

liluPlugins='AirportBrcmFixup AppleALC ATH9KFixup BT4LEContinuityFixup CPUFriend HibernationFixup 
            NoTouchID RTCMemoryFixup SystemProfilerMemoryFixup VirtualSMC acidanthera_WhateverGreen bugprogrammer_WhateverGreen'

bootLoader='OpenCore AppleSupportPkg'


for(( i=0;i<${#buildArray[@]};i++)) do
    echo $[$i+1] ${buildArray[i]%,*};
done;

read input
function hackintosh_Build()
{
    echo "将要编译"${buildArray[$1]%,*}

    mkdir -p ../Release/${buildArray[$1]%,*}/Release
    mkdir -p ../Release/${buildArray[$1]%,*}/Debug
    git clone ${buildArray[$1]##*,} ${buildArray[$1]%,*}
    cd ${buildArray[$1]%,*}
    if [ ${buildArray[$1]%,*} == 'Clover' ]; then
        ./buildme
        cp -Rf CloverPackage/sym/* ../../Release/${buildArray[$1]%,*}/Release
        rm -rf ~/Desktop/$dir/Release/${buildArray[$1]%,*}/Debug
    elif [[ $bootLoader =~ ${buildArray[$1]%,*} ]]; then
        ./macbuild.tool
        cp Binaries/RELEASE/*.zip ../../Release/${buildArray[$1]%,*}/Release
        cp Binaries/DEBUG/*.zip ../../Release/${buildArray[$1]%,*}/Debug
    else
        if [[ $liluPlugins =~ ${buildArray[$1]%,*} ]]; then
            if [ ! -e *.kext ]; then
                if [ ! -e ~/Desktop/$dir/Sources/Lilu/build/Debug/Lilu.kext ]; then
                    pushd ~/Desktop/$dir/Sources
                    git clone https://github.com/acidanthera/Lilu.git && cd Lilu
                    xcodebuild -configuration Debug
                    popd
                    cp -Rf ~/Desktop/$dir/Sources/Lilu/build/Debug/Lilu.kext .
                else
                    cp -Rf ~/Desktop/$dir/Sources/Lilu/build/Debug/Lilu.kext .
                fi
            fi
        fi
        xcodebuild -configuration Release
        xcodebuild -configuration Debug
        if [ -e build/Release/*.zip ]; then
            cp -Rf build/Release/*.zip ../../Release/${buildArray[$1]%,*}/Release
            cp -Rf build/Debug/*.zip ../../Release/${buildArray[$1]%,*}/Debug
        else
            cp -Rf build/Release/*.kext ../../Release/${buildArray[$1]%,*}/Release/${buildArray[$1]%,*}-Release.kext
            cp -Rf build/Debug/*.kext ../../Release/${buildArray[$1]%,*}/Debug/${buildArray[$1]%,*}-Debug.kext
        fi
    fi
    cd ~/Desktop/$dir/Sources
}

if [ $input == '0' ]; then
    for(( i=0;i<${#buildArray[@]};i++)) do
        hackintosh_Build $i
    done;
else
    inputArray=(`echo $input | tr ',' ' '`)
    for(( i=0;i<${#inputArray[@]};i++)) do
        hackintosh_Build ${inputArray[i]}-1
    done;
fi

open ~/Desktop/$dir/Release

echo -e "\033[32m\n编译完成,脚本运行结束!\033[0m"