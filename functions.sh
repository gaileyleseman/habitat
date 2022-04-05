#---------------------------------------------------------------------------------------------------#
# Software via APT
#---------------------------------------------------------------------------------------------------#
function install_basic_pkgs(){
    sudo apt install -y curl
    sudo apt install -y terminator
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
    sudo apt update
    sudo apt install -y gh
}

# Microsoft Teams Desktop
function install_teams(){
    sudo apt install -y curl
    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
    sudo apt update
    sudo apt install -y teams
}

# VS Code
function install_vscode(){
    sudo apt install software-properties-common apt-transport-https wget
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
    sudo apt install -y code
}

# Chrome
function install_chrome(){
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt update 
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
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
