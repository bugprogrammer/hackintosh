#bin/bash

clear
echo '脚本开始执行。'

echo -e '\n正在获取Bugprogrammer的Hackintosh仓库，请稍后:'
echo '-------------------------------------'

cd ~

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
open .