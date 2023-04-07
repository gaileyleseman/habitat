#!/usr/bin/bash

# ------------------------------------------------------------------------#
#  This script installs zsh, oh-my-zsh, and the plugins and fonts needed  #
# ------------------------------------------------------------------------#

function install_zsh_and_ohmyzsh(){
    # Install Zsh and Oh My Zsh
    echo_style "Installing Zsh and Oh My Zsh..." blue bold
    # Check if Zsh is installed
    if ! command -v zsh >/dev/null 2>&1; then
        # Install Zsh
        echo "zsh is not installed. Installing zsh..."
        sudo apt update
        sudo apt install zsh
    else
        echo_style "zsh is already installed." gray dim
    fi
    
    # Check if Oh My Zsh is installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        # Install Oh My Zsh
        echo "oh-my-zsh is not installed. Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo_style "oh-my-zsh is already installed." gray dim
    fi
}

function install_ohmyzsh_plugins(){
    CUSTOM_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
    
    # Declare the plugins array
    plugins=(
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
        "junegunn/fzf"
    )
    
    # Declare the themes array
    themes=(
        "romkatv/powerlevel10k"
    )
    
    echo_style "\nInstalling oh-my-zsh plugins, themes and other tools..." blue bold

    # Install plugins
    echo_style "Installing plugins..." white bold
    for plugin in "${plugins[@]}"; do
        plugin_dir="${CUSTOM_DIR}/plugins/$(basename "${plugin}")"
        if [ ! -d "${plugin_dir}" ]; then
            echo "Installing plugin: ${plugin}"
            git clone --depth 1 "git@github.com:${plugin}.git" "${plugin_dir}"
        else
            echo_style "Plugin '${plugin}' is already installed." gray dim;
        fi
    done
    
    # Install themes
    echo_style "\nInstalling themes..." white bold
    for theme in "${themes[@]}"; do
        theme_dir="${CUSTOM_DIR}/themes/$(basename "${theme}")"
        if [ ! -d "${theme_dir}" ]; then
            echo "Installing theme: ${theme}"
            git clone --depth 1 "git@github.com:${theme}.git" "${theme_dir}"
        else
            echo_style "Theme '${theme}' is already installed." gray dim
        fi
    done

    # Install Nerd Fonts
    echo_style "\nInstalling Nerd Fonts..." white bold
    FONTS_DIR="${HOME}/.fonts"
    if [ ! -d "${FONTS_DIR}/nerd-fonts" ]; then
        echo "Nerd Fonts are not installed. Installing Nerd Fonts..."
        git clone --depth 1 git@github.com:ryanoasis/nerd-fonts.git "${FONTS_DIR}/nerd-fonts"
        "${FONTS_DIR}/nerd-fonts/install.sh" FiraCode Meslo
        echo "Nerd Fonts installed successfully!"
    else
        echo_style "Nerd Fonts are already installed." gray dim
    fi
    
    # Install thefuck command
    echo_style "\nInstalling other completion tools..." white bold
    if ! command -v thefuck >/dev/null 2>&1; then
        echo "Installing thefuck command"
        sudo pip3 install thefuck --user > /dev/null
    else
        echo_style "Thefuck command is already installed." gray dim
    fi
    
    # Install poetry completions
    poetry_dir="${CUSTOM_DIR}/plugins/poetry"
    if [ ! -d "${poetry_dir}" ]; then
        echo "Installing poetry completions"
        mkdir "${poetry_dir}"
        poetry completions zsh > "${poetry_dir}/_poetry"
    else
        echo_style "Poetry completions are already installed." gray dim
    fi
}

function copy_zsh_dotfiles(){
    # Copy files to root directory
    echo_style "\nCopying configuration files..." white bold
    files=(
        .jira-url
        .p10k.zsh
        .toolbox
        .zshrc
    )

    config_dir=$1
    backup_dir=$HOME/.oh-my-zsh/backup
    mkdir -p "$backup_dir"

    for file in "${files[@]}"
    do
        src_file="$config_dir/$file"
        dst_file="${HOME}/test/$file"

        if [ -e "$dst_file" ]; then
            if diff "$src_file" "$dst_file" >/dev/null; then
                echo_style "Skipping $file (no changes)" gray dim
                continue
            else
                backup_file="$backup_dir/$file_$(date +%Y%m%d_%H%M%S)_.bak"
                mv "$dst_file" "$backup_file"
                echo "Backed up $dst_file to $backup_file"
            fi
        fi
    
        # Copy the new file to the destination directory
        cp "$src_file" "$dst_file"
        echo "Copied $src_file to $dst_file"
    done 
}


function setup_zsh(){
    config_dir=$(dirname "$0")/config
    source "$config_dir"/.toolbox
    
    echo "                                                                       ";
    echo " ███████╗███████╗████████╗██╗   ██╗██████╗     ███████╗███████╗██╗  ██╗";
    echo " ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗    ╚══███╔╝██╔════╝██║  ██║";
    echo " ███████╗█████╗     ██║   ██║   ██║██████╔╝      ███╔╝ ███████╗███████║";
    echo " ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝      ███╔╝  ╚════██║██╔══██║";
    echo " ███████║███████╗   ██║   ╚██████╔╝██║         ███████╗███████║██║  ██║";
    echo " ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝         ╚══════╝╚══════╝╚═╝  ╚═╝";
    echo "                                                                       ";
    echo_style "----------------------  Gailey's ZSH Setup Script ----------------------" blue bold;
    echo "                                                                      ";
    
    install_zsh_and_ohmyzsh
    install_ohmyzsh_plugins
    copy_zsh_dotfiles $config_dir

    read -n 1 -p "$(echo_style '\nDo you want to change your default shell to zsh? [y/n]' blue bold)" answer

    if [[ $answer =~ ^[Yy]$|^$ ]]; then
        echo_style "\nSetting zsh as default shell, please enter your password." 
        chsh -s $(which zsh)
    else
        echo -e "\nDefault shell not changed. If you want to change it later, run 'chsh -s $(which zsh)'"
    fi

    echo_style "\nFinished setting up zsh! You might need to close your terminal and open it again." blue bold


}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Script is being executed
    setup_zsh
fi
