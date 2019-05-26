#bin/bash

clear
echo '脚本开始执行。'
echo '正在进行环境检测。'

os=$(uname -s)
if [ ${os} == 'Linux' ]; then
	echo '检测到您的操作系统是Linux(只支持ubuntu)'
    if ! [ -x "$(command -v git)" ]; then
  		echo '尚未安装git,将自动安装'
  		sudo apt-get install git
	fi

	if ! [ -x "$(command -v nautilus)" ]; then
  		echo '尚未安装nautilus,将自动安装'
  		sudo apt-get install nautilus
	fi
elif [ ${os} == 'Darwin' ]; then
	echo '您的操作系统是macOS'
fi
echo -e '\n正在获取Bugprogrammer的Hackintosh仓库，请稍后:'
echo '-------------------------------------'

cd ~
#dir='hackintosh_'${date '+%Y%m%d%H%M%S'}
dir=hackintosh_$(date +%Y%m%d%H%M%S)
git clone https://github.com/bugprogrammer/hackintosh.git ${dir}

cd ${dir}

echo -e '\nBugprogrammer亲测过的Hackintosh机型Clover下载,此脚本支持如下机型:'
echo '-------------------------------------'
git branch -r | grep -v 'master' | sed 's/origin\///g' | awk '{print NR,$0}'
type=($(git branch -r | grep -v 'master' | sed 's/origin\///g'))

echo '请输入所需机型序号'
read input
echo '您选择的机型为:'${type[$input-1]}',现在开始下载Clover'

git checkout ${type[$input-1]}
echo 'Clover下载完成，将自动打开，路径位于'
pwd
if [ ${os} == 'Linux' ]; then
	nautilus .
elif [ ${os} == 'Darwin' ]; then
	open .
fi