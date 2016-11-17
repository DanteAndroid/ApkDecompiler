#! /bin/bash

init()
{
read -p "-----------------------------------------------------------------
已经检查过apktool和jarsigner命令，请继续。

I've checked 'apktool' and 'jarsigner' commands, please move on.
-----------------------------------------------------------------
【拖拽要反编译的apk到这里】：

【Drag your apk to be decompiled here】: 
" APK

APK_NAME=$(basename "$APK" ".apk")
APK_PATH=$(dirname "$APK")

	if [[ $APK = "" ]]; then
	echo "Path cannot be empty, please drag your apk: "
	init
	fi
}

#Start mission...
echo "-----------------------------------------------------------------"
echo Please make sure your Apktool is installed.
echo "To check that, type 'apktool','jarsigner' in terminal."
echo "If these commands doesn't work, go https://ibotpeaches.github.io/Apktool/ to install."

init
cd $APK_PATH
echo Start decompiling...
apktool d $APK

echo Open directory of decompiled directory...
open $APK_PATH/$APK_NAME

echo "Change the resources you wanna edit (like the icon)."
echo "After edit is finished,"
read -p "Come here type 【Enter】 to build new apk." 

apktool b $APK_PATH/$APK_NAME
echo "Start building edited apk..."

read -p "
【拖拽你的签名文件到这里】：
Drag your keystore to sign the apk: " KEYSTORE
read -p "
【输入keystore的别名alias】：
Enter your alias of keystore:" ALIAS
echo Start signing apk...
jarsigner -keystore $KEYSTORE -signedjar $APK_PATH/signed.apk $APK_PATH/$APK_NAME/dist/$APK_NAME.apk $ALIAS
echo Mission finished.
open $APK_PATH
