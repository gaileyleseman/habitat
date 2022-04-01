# source functions
source ./functions.sh

# change password
sudo passwd $USER

# create an SSH key
echo -e "\n"|ssh-keygen -t rsa -N ""

# install software via debians
install_teams
install_chrome
install_vscode
install_spotify

# install software via apt
sudo apt install -y terminator

# c++ stuff
sudo apt install -y g++
sudo apt install build-essential
