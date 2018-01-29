# Start with ubunto 17.10 ami

	us-west-2 ami-2eb40856

# Update the installation

	sudo apt-get -y update
	sudo apt-get -y upgrade

# Install lubuntu Desktop

	sudo apt-get -y install lubuntu-desktop

# Install xllvnc server

	sudo apt-get -y install x11vnc
	sudo apt-get install xserver-xorg-video-dummy

	expect <<EOF
	spawn x11vnc -storepasswd
	expect "Enter VNC password:"
	send "dockerlab\r"
	expect "Verify password:"
	send "dockerlab\r"
	expect "Write password to /home/ubuntu/.vnc/passwd?"
	send "y\r"
	expect eof
	exit
	EOF

	cat << EOF > /lib/systemd/system/x11vnc.service
	[Unit]
	Description=Start x11vnc at startup.
	After=multi-user.target

	[Service]
	Type=simple
	ExecStart=/usr/bin/x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbauth /home/ubuntu/.vnc/passwd -rfbport 5901 -shared

	[Install]
	WantedBy=multi-user.target
	EOF

	sudo mv x11vnc.service /lib/systemd/system/x11vnc.service
	sudo chmod +x /lib/systemd/system/x11vnc.service
	sudo systemctl daemon-reload
	sudo systemctl enable x11vnc.service
	sudo systemctl start x11vnc.service

# Install tightvnc server

	sudo apt-get -y install tightvncserver expect
		
	# Set the vnc password
	expect <<EOF
	spawn vncserver
	expect "Password:"
	send "dockerlab\r"
	expect "Verify:"
	send "dockerlab\r"
	expect "Would you like to enter a view-only password (y/n)?"
	send "n\r"
	expect eof
	exit
	EOF

	vncserver -kill :1

	# configure lubuntu desktop to start
	echo "/usr/bin/startlxde" >> ~/.vnc/xstartup

	# Configure the startup file
	cat <<EOF > vncserver.service
	[Unit]
	Description=Start tightvnc server at startup.
	After=multi-user.target

	[Service]
	Type=simple
	ExecStart=/bin/su - ubuntu -c "/usr/bin/vncserver -depth 16 -geometry 1280x786 :1"

	[Install]
	WantedBy=multi-user.target
	EOF

	sudo mv vncserver.service /lib/systemd/system/vncserver.service
	sudo chmod +x /lib/systemd/system/vncserver.service
	sudo systemctl daemon-reload
	sudo systemctl enable vncserver.service
	sudo systemctl start vncserver.service

	# Disable the screen saver
	cat <<EOF > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
	<?xml version="1.0" encoding="UTF-8"?>
	<channel name="xfce4-power-manager" version="1.0">
		<property name="xfce4-power-manager" type="empty">
			<property name="power-button-action" type="empty"/>
			<property name="logind-handle-lid-switch" type="bool" value="false"/>
			<property name="lock-screen-suspend-hibernate" type="bool" value="false"/>
		</property>
	</channel>
	EOF

# Install NoVNC web server

	#cd /usr/share
	#sudo git clone https://github.com/novnc/noVNC.git
	#cd noVNC
	#sudo ln -s vnc.html index.html
	#
	#sudo su
	#
	#cat << EOF > launchAWS.sh
	#VNC_HOST=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`
	#VNC_PORT=5901
	#HTTP_PORT=8901
	#./utils/launch.sh --vnc ${VNC_HOST}:${VNC_PORT} --listen ${HTTP_PORT}
	#EOF
	#	
	#sudo chmod +x launchAWS.sh
	#	
	#cat << EOF > /lib/systemd/system/noVNC.service
	#[Unit]
	#Description=Start noVNC websockets server
	#After=multi-user.target
	#	
	#[Service]
	#Type=simple
	#ExecStart=/usr/share/noVNC/launchAWS.sh
	#	
	#[Install]
	#WantedBy=multi-user.target
	#EOF
	#
	#chmod +x /lib/systemd/system/noVNC.service
	#sudo systemctl daemon-reload
	#sudo systemctl enable noVNC.service
	#sudo systemctl start noVNC.service
	#echo "autologin-user=ubuntu" >> /etc/llightdm/lightdm.conf

# Configure Terminal to use the Solarized Theme

	sed -i ~/.config/lxtermain/lxterminal.conf s/"^color_preset=*"/"color_preset=Solarized"/

# Install Atom IDE

	sudo add-apt-repository -y ppa:webupd8team/atom
	sudo apt-get update
	sudo apt-get install -y atom

	# now run atom from cmd line and pin to taskbar

# Install Docker-CE

	sudo apt-get update
	sudo apt-get install \
		apt-transport-https \
		ca-certificates \
		curl \
		software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		$(lsb_release -cs) \
		stable"
	sudo apt-get update
	sudo apt-get -y install docker-ce

# Install Docker-compose

	sudo usermod ubuntu -a -G docker
	sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
	sudo chmod 755 /usr/local/bin/docker-compose

# install AWS CLI

	sudo apt -y install python-pip
	sudo pip install --upgrade pip
	sudo pip install awscli --upgrade

# Install travis cli

	sudo apt -y install ruby ruby-dev
	gem install travis -v 1.8.8 --no-rdoc --no-ri

# Install terraform

	curl -s https://releases.hashicorp.com/terraform/0.10.6/terraform_0.10.6_linux_amd64.zip | gzip -d - > ./terraform
	chmod 755 ./terraform
	sudo mv terraform /usr/local/bin

# Install jq

	sudo apt -y install jq
