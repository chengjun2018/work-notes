path="/home/projects/api/jaky"
p=$path"/"$1

cd $p
echo 执行dev合并到test操作：
echo $p
return

echo 查看状态
git status
echo 切换到dev
git checkout dev
echo 拉取远程dev和本地合并
git pull origin dev
echo 提送到远程dev
git push origin dev
echo 切换到test
git checkout test
echo 拉取远程test和本地合并
git pull origin test
echo test合并dev
git merge dev
echo 合并完成，推送到远程test
git push origin test
echo 切回dev环境
git checkout dev
