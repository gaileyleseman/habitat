#---------------------------------------------------------------------------------------------------#
# Settings
#---------------------------------------------------------------------------------------------------#

# Setting up SSH and Github
function git_upload_ssh_key () {
  read -p "Enter GitHub e-mail : " email
  echo "Using e-mail $email"
  if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -C "$email"
    ssh-add ~/.ssh/id_rsa
  fi
  pub=`cat ~/.ssh/id_rsa.pub`
  read -p "Enter GitHub username: " githubuser
  echo "Using username $githubuser"
  read -s -p "Enter GitHub password for user $githubuser: " githubpass
  echo
  read -p "Enter GitHub OTP: " otp
  echo "Using OTP $otp"
  echo
  confirm
  curl -u "$githubuser:$githubpass" -X POST -d "{\"title\":\"`hostname`\",\"key\":\"$pub\"}" --header "x-github-otp: $otp" https://api.github.com/user/keys
}


#---------------------------------------------------------------------------------------------------#
# Software via Debian Packages
#---------------------------------------------------------------------------------------------------#

# Spotify
function install_spotify(){
    curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update && sudo apt-get install -y spotify-client
}

# Microsoft Teams Desktop
function install_teams(){
    sudo apt install -y curl
    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
    sudo apt update
    sudo apt install teams
}

# VS Code
function install_vscode(){
    sudo apt install software-properties-common apt-transport-https wget
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt install code
}

# Chrome
function install_chrome(){
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt update && sudo apt install -y ./google-chrome-stable_current_amd64.deb
}


#---------------------------------------------------------------------------------------------------#