#---------------------------------------------------------------------------------------------------#
# Software via APT
#---------------------------------------------------------------------------------------------------#

function install_basic_pkgs(){
    echo_style "Installing some basic packages with apt.. Please enter your password when prompted." white bold
    echo_style "We are updating the repositories in the background, so this may take a while..." white

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
    python3-vcstools

    echo "Done! Installed some basic packages with apt."
}

# apt install nvidia-cuda-toolkit

#---------------------------------------------------------------------------------------------------#
# Software via Snap
#---------------------------------------------------------------------------------------------------#

function install_snap_apps() {
    echo_style "\nSnap: " blue bold

    work_apps=(
        "Visual Studio Code:code"
        "Azure Storage Explorer:storage-explorer"
        "Microsoft Teams for Linux:teams-for-linux"
        "OneNote Desktop:onenote-desktop"
        "Postman:postman"
        "draw.io:drawio"
    )

    personal_apps=(
        "Spotify:spotify"
        "Raspberry Pi Imager:rpi-imager"
        "Arduino IDE:arduino"
        "Discord:discord"
        "Blender:blender"
        "Bitwarden:bitwarden"
        "Bitwarden CLI:bw"
    )

    classic_apps=(
        "code"
        "blender"
    )

    selected_apps=()

    echo_style "\nWhich of the following work applications would you like to install?" white bold

    for app in "${work_apps[@]}"; do
        app_name="${app%%:*}"
        app_cmd="${app#*:}"
        read -n 1 -p "  Do you want to install $app_name? [y/n]  " answer
        if [[ $answer == [Yy]* ]]; then
            selected_apps+=("$app_cmd")
        fi
        echo ""
    done

    echo_style "\nWhich of the following personal applications would you like to install?" white bold

    for app in "${personal_apps[@]}"; do
        app_name="${app%%:*}"
        app_cmd="${app#*:}"
        read -n 1 -p "  Do you want to install $app_name? [y/n]  " answer
        if [[ $answer == [Yy]* ]]; then
            selected_apps+=("$app_cmd")
        fi
        echo ""
    done

    if [[ ${#selected_apps[@]} -gt 0 ]]; then
        echo ""
        echo_style "The following apps will be installed:" white bold
        for app in "${work_apps[@]}"; do
            app_name="${app%%:*}"
            app_cmd="${app#*:}"
            if [[ " ${selected_apps[@]} " =~ " $app_cmd " ]]; then
                echo "  - $app_name"
            fi
        done

        for app in "${personal_apps[@]}"; do
            app_name="${app%%:*}"
            app_cmd="${app#*:}"
            if [[ " ${selected_apps[@]} " =~ " $app_cmd " ]]; then
                echo "  - $app_name"
            fi
        done

        read -n 1 -p "$(echo_style '\nDo you want to continue with the installation? [y/n]' white bold)" answer
        echo ""

        if [[ $answer == [Yy]* ]]; then            
            for app_cmd in "${selected_apps[@]}"; do
                if [[ " ${classic_apps[@]} " =~ " $app_cmd " ]]; then
                    sudo snap install "$app_cmd" --classic
                else
                    sudo snap install "$app_cmd"
                fi
            done
            echo "Installed apps through snap"
        else
            echo "Installation canceled"
        fi
    else
        echo "No work apps or personal apps selected for installation"
    fi
}


#---------------------------------------------------------------------------------------------------#
# Other Software Installations
#---------------------------------------------------------------------------------------------------#

# Applications -------------------------------------------------------------------------------------#

# Chrome
function install_chrome(){
    read -n 1 -p "$(echo_style '\nDo you want to install Google Chrome? [y/n]' white bold)" answer
    echo ""
    if [[ $answer != [Yy]* ]]; then
        echo "Skipping Google Chrome installation"
        return
    fi

    curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/googlechrome-keyring.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/googlechrome-keyring.gpg] \
            http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -qq -y google-chrome-stable
    echo "installed Google Chrome"
}

# Drivers ----------------------------------------------------------------------------------------#

function install_displaylink_drivers(){
    read -n 1 -p "$(echo_style '\nDo you want to install DisplayLink drivers? [y/n]' white bold)" answer
    echo ""
    if [[ $answer != [Yy]* ]]; then
        echo "Skipping DisplayLink installation"
        return
    fi

    wget -O ~/Downloads/synaptics-repository-keyring.deb https://www.synaptics.com/sites/default/files/Ubuntu/pool/stable/main/all/synaptics-repository-keyring.deb
    sudo apt install -qq -y ~/Downloads/synaptics-repository-keyring.deb
    sudo apt-get update -qq
    sudo apt install -qq -y displaylink-driver 
    echo "installed DisplayLink drivers"
}

# Software ----------------------------------------------------------------------------------------#

# Docker 
function install_docker(){
    echo_style "\nDocker: " blue bold
    # Docker
    read -n 1 -p "$(echo_style 'Do you want to install Docker? [y/n]' white bold)" answer
    echo ""
    if [[ $answer != [Yy]* ]]; then
        echo_style "Skipping Docker installation" white
        return
    fi

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
            https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -qq -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-compose-plugin \
        docker-buildx-plugin
    echo "installed Docker Engine"

    # post-installation steps
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker 
}

# Kubernetes Tools
function install_kubernetes_tools(){
    echo_style "\nKubernetes: " blue bold
    # Minikube
    read -n 1 -p "$(echo_style 'Do you want to install Minikube? [y/n]' white bold)" answer
    echo ""
    if [[ $answer == [Yy]* ]]; then
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        sudo install minikube-linux-amd64 /usr/local/bin/minikube
        echo "installed Minikube"
    else
        echo_style "Skipping Minikube installation" white
    fi

    # Kubectl
    read -n 1 -p "$(echo_style '\nDo you want to install Kubectl? [y/n]' white bold)" answer
    echo ""
    if [[ $answer == [Yy]* ]]; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        echo "installed Kubectl" 
    else 
        echo_style "Skipping Kubectl installation" white
    fi

    # Helm
    read -n 1 -p "$(echo_style '\nDo you want to install Helm? [y/n]' white bold)" answer
    echo ""
    if [[ $answer == [Yy]* ]]; then
        curl https://baltocdn.com/helm/signing.asc | gpg --dearmor -o /usr/share/keyrings/helm.gpg > /dev/null
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] \
                https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
        sudo apt-get update -qq
        sudo apt-get install -y helm
        echo "installed Helm"
    else 
        echo_style "Skipping Helm installation" white
    fi
}

function install_cloud_tools(){
    echo_style "\nCloud: " blue bold

    # Azure CLI
    read -n 1 -p "$(echo_style 'Do you want to install Azure CLI? [y/n]' white bold)" answer
    echo ""
    if [[ $answer == [Yy]* ]]; then
        curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash > /dev/null
        echo "installed Azure CLI"
    else
        echo_style "Skipping Azure CLI installation" white
    fi
}

# Poetry
function install_python_tools(){
    echo_style "\nPython:" blue bold

    # Python Versions
    echo_style "Your current Python version is $(python3 --version)" white
    echo_style "The available Python versions are:" white
    update-alternatives --list python3
    echo ""

    read -n 1 -p "$(echo_style 'Do you want to install another version of Python? [y/n]' white bold)" answer
    echo ""
    if [[ $answer == [Yy]* ]]; then
        read -p "$(echo_style 'Enter the version of Python you want to install (e.g. 3.10):' white bold)" PYTHON_VERSION
        install_python $PYTHON_VERSION
    else
        echo_style "Skipping Python installation" white
    fi

    read -n 1 -p "$(echo_style '\nDo you want to update the default version for Python? [y/n]' white bold)" answer
    echo ""
    if [[ $answer == [Yy]* ]]; then
        update_python
    else
        echo_style "Skipping Python update" white
    fi

    # Poetry
    read -n 1 -p "$(echo_style '\nDo you want to install Poetry? [y/n]' white bold)" answer
    echo ""
    if [[ $answer == [Yy]* ]]; then
        curl -sSL https://install.python-poetry.org | python3 - > /dev/null
        echo "installed Poetry"
    else
        echo_style "Skipping Poetry installation" white
    fi

    # Pre-commit, Ruff, Black
    read -n 1 -p "$(echo_style '\nDo you want to install pre-commit, ruff and black? [y/n]' white bold)" answer
    echo ""
    if [[ $answer == [Yy]* ]]; then
        pip3 install pre-commit ruff black > /dev/null
        echo "installed pre-commit, ruff and black"
    else
        echo_style "Skipping pre-commit, ruff and black installation" white
    fi
}

# GitHub CLI
function install_git_tools(){
    echo_style "\nGit: " blue bold

    # GitHub CLI
    read -n 1 -p "$(echo_style 'Do you want to install GitHub CLI? [y/n]' white bold)" answer
    echo ""
    if [[ $answer == [Yy]* ]]; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
                https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt-get update -qq
        sudo apt-get install -qq -y gh
        echo "installed GitHub CLI"
    else
        echo_style "Skipping GitHub CLI installation" white
    fi
}

function install_llvm_clang(){
    echo_style "\nLLVM/Clang: " blue bold

    # LLVM/Clang
    read -n 1 -p "$(echo_style 'Do you want to install LLVM/Clang? [y/n]' white bold)" answer
    echo ""
    if [[ $answer == [Yy]* ]]; then
        wget https://apt.llvm.org/llvm.sh
        chmod +x llvm.sh
        sudo apt-get update -qq
        sudo ./llvm.sh all
        rm llvm.sh
        sudo apt-get upgrade -qq
        echo "installed LLVM/Clang"

    else
        echo_style "Skipping LLVM/Clang installation" white
    fi
}

#---------------------------------------------------------------------------------------------------#
# Settings
#---------------------------------------------------------------------------------------------------#

# Setting up SSH and Github
function create_ssh_github(){
    
    read -n 1 -p "$(echo_style '\nDo you want to set a SSH key for GitHub? [y/n]' white bold)" answer
    echo ""

    if [[ $answer != [Yy]* ]]; then
        echo "Skipping Github SSH key setup"
        return
    fi

    if ! command -v gh &> /dev/null
    then
        echo_style "GitHub CLI could not be found. Please install it first." white
        return
    fi

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

function create_ssh_key(){

    read -n 1 -p "$(echo_style '\nDo you want to create a SSH key? [y/n]' white bold)" answer
    echo ""

    if [[ $answer != [Yy]* ]]; then
        echo "Skipping SSH key creation"
        return
    fi

    if [ ! -f ~/.ssh/id_rsa ]; then
        read -p "Enter your e-mail: " EMAIL
        ssh-keygen -t rsa -b 4096 -C "$EMAIL"
        ssh-add ~/.ssh/id_rsa
    else 
        echo "SSH key already exists"
    fi

    echo "This is the public key:"
    echo " " 
    cat ~/.ssh/id_rsa.pub
    echo " "
}

