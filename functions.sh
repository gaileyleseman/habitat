#---------------------------------------------------------------------------------------------------#
# Software via APT
#---------------------------------------------------------------------------------------------------#
function install_basic_pkgs(){
    sudo apt-get update -qq
    sudo apt-get install -qq -y \
    apt-transport-https \
    bat \
    ca-certificates \
    curl \
    git \
    gnupg \
    lsb-release \
    python3-pip \
    python3-dev \
    python3-setuptools \
    python3-vcstool \
    echo "installed packages through apt"
}

function install_python(){
    version=${1:-3.12} # default to 3.12
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt-get update -qq
    sudo apt-get install -qq -y \
    python$version\
    python$version-venv
    echo "installed python $version"
}

# apt install nvidia-cuda-toolkit

#---------------------------------------------------------------------------------------------------#
# Software via Snap
#---------------------------------------------------------------------------------------------------#

function install_snap_pkgs(){
    sudo snap install \
    bitwarden \
    bw \
    code \
    insomnia \
    postman \
    rpi-imager \
    spotify \
    echo "installed packages through snap"
}


function install_work_pkgs(){
    sudo snap install \
    code \
    storage-explorer \
    teams-for-linux \
    echo "installed work packages through snap"
}

#---------------------------------------------------------------------------------------------------#
# Other Software Installations
#---------------------------------------------------------------------------------------------------#

function install_prep(){
    sudo mkdir -p /etc/apt/keyrings
}

# Applications -------------------------------------------------------------------------------------#

# VS Code
function install_vscode(){
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/vscode-archive-keyring.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/vscode-archive-keyring.gpg] \
            https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -qq -y code
    echo "installed VS Code"
}

# Chrome
function install_chrome(){
    curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/googlechrome-keyring.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/googlechrome-keyring.gpg] \
            http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -qq -y google-chrome-stable
    echo "installed Google Chrome"
}

# Software ----------------------------------------------------------------------------------------#

# Docker 
function install_docker(){
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

# Helm
function install_helm(){
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor -o /usr/share/keyrings/helm.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] \
            https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update -qq
    sudo apt-get install -y helm
    echo "installed Helm"
}

# Poetry
function install_poetry(){
    curl -sSL https://install.python-poetry.org | python3 - > /dev/null
    echo "installed Poetry"
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

#---------------------------------------------------------------------------------------------------#
# Shell Set-up
#---------------------------------------------------------------------------------------------------#

source ./zsh/setup_zsh.sh


#---------------------------------------------------------------------------------------------------#
# Settings
#---------------------------------------------------------------------------------------------------#

# Setting up SSH and Github
function github_ssh_key(){
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