#!/usr/bin/bash

function new_pc(){
    set -o errexit

    habitat_dir=$(dirname "$0")/..
    source "$habitat_dir"/zsh/config/.toolbox
    source "$habitat_dir"/pc/install_functions.sh

    
    echo_style "-------------------------------------------------------------------------" blue bold;
    echo "                                                                      ";
    echo "     ███████╗███████╗████████╗██╗   ██╗██████╗     ██████╗  ██████╗";
    echo "     ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗    ██╔══██╗██╔════╝";
    echo "     ███████╗█████╗     ██║   ██║   ██║██████╔╝    ██████╔╝██║     ";
    echo "     ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝     ██╔═══╝ ██║     ";
    echo "     ███████║███████╗   ██║   ╚██████╔╝██║         ██║     ╚██████╗";
    echo "     ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝         ╚═╝      ╚═════╝";
    echo "                                                                   ";
    echo_style "----------------------  Gailey's PC Setup Script -----------------------" blue bold;

    install_basic_pkgs

    echo_style "\n-------------------------------------------------------------------------" blue bold;
    echo_style "                         Applications                                    " blue bold;
    echo_style "-------------------------------------------------------------------------" blue bold;

    install_snap_apps
    echo_style "\nOther: " blue bold
    install_chrome
    install_displaylink_drivers

    
    echo_style "\n-------------------------------------------------------------------------" blue bold;
    echo_style "                         Development tools                               " blue bold;
    echo_style "-------------------------------------------------------------------------" blue bold;

    install_docker
    install_cloud_tools
    install_kubernetes_tools
    install_git_tools
    install_python_tools

    echo_style "\n-------------------------------------------------------------------------" blue bold;
    echo_style "                         Settings etc.                                   " blue bold;
    echo_style "-------------------------------------------------------------------------" blue bold;

    create_ssh_github
    create_ssh_key
    
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Script is being executed
    new_pc
fi