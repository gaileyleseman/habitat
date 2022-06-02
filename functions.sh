#---------------------------------------------------------------------------------------------------#
# Software via APT
#---------------------------------------------------------------------------------------------------#
function install_basic_pkgs(){
    sudo apt-get install -y git
    sudo apt-get install -y curl
    sudo apt-get install -y terminator
}


#---------------------------------------------------------------------------------------------------#
# Software via Debian Packages
#---------------------------------------------------------------------------------------------------#

# Spotify
function install_spotify(){
    curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update
    sudo apt-get install -y spotify-client
}

# GitHub CLI
function install_github_cli(){
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y gh
}

# Microsoft Teams Desktop
function install_teams(){
    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
    sudo apt-get update
    sudo apt-get install -y teams
}

# VS Code
function install_vscode(){
    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt-get update
    sudo apt-get install -y code
}

# Chrome
function install_chrome(){
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
    sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt-get update
    sudo apt-get install google-chrome-stable
}

# Docker 
function install_docker {
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg lsb-release

    # docker
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # post-installation steps
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker 
}

function install_docker_script {
    curl -s https://get.docker.com | bash -s
}


#---------------------------------------------------------------------------------------------------#
# OTHER
#---------------------------------------------------------------------------------------------------#


#---------------------------------------------------------------------------------------------------#
# Settings
#---------------------------------------------------------------------------------------------------#

# Setting up SSH and Github
function github_ssh_key () {
    read -p "Enter GitHub e-mail :" email
    echo "Using e-mail $email"
    if [ ! -f ~/.ssh/id_rsa ]; then
        ssh-keygen -t rsa -b 4096 -C "$email"
        ssh-add ~/.ssh/id_rsa
    fi
    gh auth login -p ssh
}


#---------------------------------------------------------------------------------------------------#
# Prime Vision
#---------------------------------------------------------------------------------------------------#

# Setting up SSH and Gitlab
function pv_gitlab_ssh_key () {
    # https://gitlab.cicd.primevisiononline.com/-/profile/keys
    echo hoi 
}


# Downloading PV repositories 
function pv_clone_repos () {
    # robotics
    mkdir ~/pv-robotics && cd ~/pv-robotics
    git clone git@gitlab.cicd.primevisiononline.com:autonomous-sorting/cloud/services/floorplan-service.git
    git clone git@gitlab.cicd.primevisiononline.com:autonomous-sorting/simulators/simulator-workspace.git
    git clone git@gitlab.cicd.primevisiononline.com:autonomous-sorting/fleet/navigation.git
    git clone git@gitlab.cicd.primevisiononline.com:autonomous-sorting/fleet/motion-planning-library.git

    # documentation
    mkdir documentation && cd documentation
    git clone git@gitlab.cicd.primevisiononline.com:autonomous-sorting/docu/robotic-sorting-setup.git
    git clone git@gitlab.cicd.primevisiononline.com:autonomous-sorting/docu/robotic-sorting-rollout.git
    git clone git@gitlab.cicd.primevisiononline.com:autonomous-sorting/docu/robot-troubleshooting.git
    git clone git@gitlab.cicd.primevisiononline.com:autonomous-sorting/docu/robotic-sorting-maintenance.git
    cd ~
}

