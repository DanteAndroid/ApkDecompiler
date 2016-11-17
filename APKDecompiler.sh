#! /bin/bash

init()
{
read -p "-----------------------------------------------------------------
【我已经检查过apktool和jarsigner命令，请继续】
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
echo "【请先确保apktool已经安装(用终端输入apktool命令)】"
echo "Please make sure your Apktool is installed."
echo "To check that, type 'apktool','jarsigner' in terminal."
echo "If these commands doesn't work, go https://ibotpeaches.github.io/Apktool/ to install."

init
cd $APK_PATH
echo Start decompiling...
apktool d -f $APK

echo Open directory of decompiled directory...
open $APK_PATH/$APK_NAME

echo "Change the resources you wanna edit (like the icon)."
read -p "After edit is finished, come here type Enter to build new apk." 

apktool b $APK_PATH/$APK_NAME
echo "Start building edited apk..."

read -p "
【拖拽你的签名文件到这里，没有直接点enter】：
Drag your keystore to sign the apk, if you don't have one just enter:
" KEYSTORE
	if [[ $KEYSTORE != "" ]]; then
		read -p "
【输入keystore的别名alias】：
Enter your alias of keystore:" ALIAS
		echo Start signing apk...
		jarsigner -keystore $KEYSTORE -signedjar $APK_PATH/signed.apk $APK_PATH/$APK_NAME/dist/$APK_NAME.apk $ALIAS
		echo Mission finished.
	else 
		keytool -genkeypair -alias "test" -keyalg "RSA" -keystore "key.jks" 
		echo Start signing apk...
		jarsigner -keystore $APK_PATH/key.jks -signedjar $APK_PATH/signed.apk $APK_PATH/$APK_NAME/dist/$APK_NAME.apk "test"
		echo Mission finished.
	fi


open $APK_PATH
