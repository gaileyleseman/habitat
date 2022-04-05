
function install_ros2_galactic(){
	apt-cache policy | grep universe
	sudo apt install software-properties-common0
	sudo add-apt-repository universe
	sudo apt update && sudo apt install curl gnupg lsb-release
	sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
	sudo apt update
	sudo apt install ros-galactic-desktop
}

function install_moveit2(){
	source /opt/ros/galactic/setup.bash
	sudo apt install python3-rosdep
	sudo rosdep init
	rosdep update
	sudo apt update
	sudo apt dist-upgrade
	sudo apt install python3-colcon-common-extensions
	sudo apt install python3-colcon-mixin
	colcon mixin add default https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml
	colcon mixin update default
	sudo apt install python3-vcstool
	mkdir -p ~/ws_moveit2/src
	cd ~/ws_moveit2/src
	git clone https://github.com/ros-planning/moveit2_tutorials.git
	vcs import < moveit2_tutorials/moveit2_tutorials.repos
	rosdep install -r --from-paths . --ignore-src --rosdistro $ROS_DISTRO -y
	cd ~/ws_moveit2
	colcon build --mixin release
}

