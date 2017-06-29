#!/usr/bin/env bash
which curl &> /dev/null || { echo >&2 "I require curl but it's not installed.  Aborting."; exit 1; }
				echo "curl is installed."
echo "setting variables and checking some things"
mkdir ~/minecraft
BASEDIR="$HOME/minecraft"
mkdir $BASEDIR/logs/
touch $BASEDIR/logs/log.txt
git config --global user.name "$USER"
echo "Please enter your sudo password:"
sudo ls &> $BASEDIR/logs/logs.txt
clear
if curl --output $BASEDIR/logs/logs.txt --silent --head --fail "www.tcpr.ca"; then
  clear
else
  echo "Connection can not be made to www.tcpr.ca"
  exit 1
fi
if curl --output /dev/null --silent --head --fail "hub.spigotmc.org"; then
  echo "Can contact hub.spigotmc.org"
else
  echo "Connection can not be made to hub.spigotmc.org"
  exit 1
fi
if curl --output /dev/null --silent --head --fail "dev.bukkit.org"; then
  echo "Can contact dev.bukkit.org"
else
  echo "Connection can not be made to dev.bukkit.org"
  exit 1
fi
VER=$(ls | grep "jar" | grep "spigot")
echo "setting directories"
mkdir $BASEDIR/BuildTools
mkdir $BASEDIR/logs/
touch $BASEDIR/logs/logs.txt &> $BASEDIR/logs/logs.txt
echo "checking if some things are installed"
cd $BASEDIR
clear
which pv &> /dev/null || { echo >&2 "I require pv but it's not installed.  Aborting."; exit 1; }
				echo "pv is installed."

which java &> /dev/null || { echo >&2 "I require java but it's not installed.  Aborting."; exit 1; }
				echo "Java is installed."

which git &> /dev/null || { echo >&2 "I require git but it's not installed.  Aborting."; exit 1; }
echo "Git is installed."
cd $BASEDIR
echo "Everything required is installed. Downloading BuildTools.jar..."
cd $BASEDIR
wget -O BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar 2> /dev/null | pv > /dev/null
clear
echo "Compiling your tools. This can take up to 1-5 mins depending on your internet/cpu speed."
echo ""
cd "$HOME/minecraft"
java -jar $BASEDIR/BuildTools.jar 2> /dev/null | pv > /dev/null
cd $BASEDIR/plugins/ &> $BASEDIR/logs/logs.txt
mkdir ./plugins
wget -N  https://dev.bukkit.org/media/files/909/154/PermissionsEx-1.23.4.jar --no-check-certificate 2> /dev/null | pv > /dev/null
wget -N  https://dev.bukkit.org/media/files/911/841/ChatEx.jar --no-check-certificate 2> /dev/null | pv > /dev/null
wget -N  https://dev.bukkit.org/media/files/922/48/worldedit-bukkit-6.1.3.jar --no-check-certificate 2> /dev/null | pv > /dev/null
mv PermissionsEx-1.23.4.jar ./plugins
mv ChatEx.jar ./plugins
mv worldedit-bukkit-6.1.3.jar ./plugins
clear
echo "creating and filling start.sh"
touch $BASEDIR/start.sh
cat > $BASEDIR/start.sh << 'EndOfMessage'
 BASEDIR=$(dirname "$0")
 cd $BASEDIR/
 VER=$(ls | grep "jar" | grep "spigot")
 java -Xmx1024M -XX:MaxPermSize=128M -jar $VER -o true 
 sleep 5
 echo "Restarting..." && bash $BASEDIR/start.sh
EndOfMessage
 sleep 1
 sudo chmod 775 -R $BASEDIR 
 cd $BASEDIR/
 VER=$(ls | grep "jar" | grep "spigot")
 java -Xmx1024M -jar $VER -o true | grep "agree"
sudo chmod 775 -R $BASEDIR
echo ""
clear
echo Finished. You can start your server by typing "bash $BASEDIR/start.sh" in your terminal.