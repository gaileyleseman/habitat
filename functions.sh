#---------------------------------------------------------------------------------------------------#
# Software via APT
#---------------------------------------------------------------------------------------------------#
function install_basic_pkgs(){
    sudo apt-get update -qq
    sudo apt-get install -qq -y \
    ca-certificates \
    curl \
    git \
    gnupg \
    lsb-release \
    terminator
    echo "installed packages through apt"
}

# sudo apt-get install python3.10-venv
# sudo apt-get install python3-dev
# libasound2-dev
# libjack0
# libjack-dev


#---------------------------------------------------------------------------------------------------#
# Other Software
#---------------------------------------------------------------------------------------------------#

# Spotify
function install_spotify(){
    curl -fsSL https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo gpg --dearmor -o /usr/share/keyrings/spotify-archive-keyring.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/spotify-archive-keyring.gpg] \
            http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -qq -y spotify-client
    echo "installed Spotify"
}

# GitHub CLI
function install_github_cli(){
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
            https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -qq -y gh
    echo "installed GitHub CLI"
}

# VS Code
function install_vscode(){
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/vscode-archive-keyring.gpg > /dev/null
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/vscode-archive-keyring.gpg] \
            https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -qq -y code
    echo "installed VS Code"
}

# Chrome
function install_chrome(){
    curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-keyring.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/googlechrome-keyring.gpg] \
            http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -qq -y google-chrome-stable
    echo "installed Google Chrome"
}

# Docker 
function install_docker {
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
            https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -qq -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    echo "installed Docker Engine"

    # post-installation steps
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker 
}

#---------------------------------------------------------------------------------------------------#
# Settings
#---------------------------------------------------------------------------------------------------#

# Setting up SSH and Github
function github_ssh_key () {
    read -p "Enter GitHub e-mail: " GITHUB_EMAIL
    read -p "Enter name: " NAME
    echo "Using e-mail $GITHUB_EMAIL"
    if [ ! -f ~/.ssh/id_rsa ]; then
        ssh-keygen -t rsa -b 4096 -C "$GITHUB_EMAIL"
        ssh-add ~/.ssh/id_rsa
    fi
    gh auth login -p ssh
    git config --global user.email $GITHUB_EMAIL
    git config --global user.name $NAME
}
