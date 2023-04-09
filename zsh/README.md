# zsh

## Introduction

This repository contains my personal configuration for `zsh` and [`oh-my-zsh`](https://ohmyz.sh/), as well as a helper script to install and configure `zsh`.
You can use this configuration as is, or as a starting point, using a different [theme](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes) or adding other [plugins](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins-Overview).

## Installation

Install and configure `zsh` with the provided installation script:

```bash
./setup_zsh.sh
```

If you have not installed it already, the script will also prompt you if you want to install `terminator`, a nice terminal emulator that has a split-screen functionality that allows you to have multiple terminals in one window.

## Favorite features

Some of my personal favorites:

### oh-my-zsh plugins

- <kbd>Ctrl</kbd> + <kbd>R</kbd> - will search your history for the command you are typing
  - Alternative: if you start typing your command and use <kbd>↑</kbd> it will cycle through previous commands that match

- <kbd>Ctrl</kbd> + <kbd>T</kbd> - will recursively search the current directory for the file you are typing
  - especially useful in combination with other commands like `cd` and `python`

- `agi` - will install a package with `sudo apt-get install`
  - example: `agi python3`
  - also: `agu` for `sudo apt-get update`

- `fuck` - will try to autocorrect the mistake in your previous command and prompt you with a solution. Some examples of mistakes:
  - if you made a type:, e.g. `puthon`
  - if you forgot to add a flag, e.g. `rm <folder>`
  - if you try to install the wrong package, e.g. `pip3 install yaml` or
  - if you forgot to add `sudo`
  - if you forgot to set the remote as upstream on your new branch when you push
  - and maybe more, just try and see

- `gcb` - will create and checkout a new branch
  - example: `gcb feature/cool-thing`
  - also: `gco` for `git checkout`, so you can use `gco -` to check out your previous branch
  - also: `gcmsg` for `git commit -m`

- `google` - will directly search what you type on that search engine, also works for StackOverflow and
  - example: `google is pluto a planet`
  - example: `stackoverflow how to concatenate std::string and int c++`

- `is_json` - will return if a file is a valid json
  - example: `is_json < my_file.json`

- `jira branch` - opens the JIRA ticket referenced in the branch name in your browser
  - For this to work you need to update the url in `.jira-url` to match your board.
  - also: `jira new` to create a new JIRA ticket and `jira mine` to view your JIRA tickets

- `z` - tool to directly jump to any directory that you have visited before
  - example: `z foo` + <kbd>Tab</kbd> to directy jump to `~/super/nested/directory/with/folder/foo`

### custom

- `create_venv` will create a virtual environment, activate it and install the requirements for that directory
- `activate` will activate the default virtual environment (`venv`) for that directory

### other functionalities

- auto completion for commands for different packages such as `docker`, `git`, `helm`, `kubectl`, `minikube`, `poetry` etc.
- `git-auto-fetch` will automatically fetch the latest changes from the remote repository
- interactive `cd` command that will show you the contents of the directory you are in
- press <kbd>Esc</kbd> twice to clear to add `sudo` to your previous command

## Troubleshooting

Switch between `bash` and `zsh` with the following commands:

```bash
bash
zsh
```

Change the default shell to `zsh` with the following commands:

```bash
chsh -s $(which zsh)
```

Run the following command to configure `p10k` theme if the shapes overlap or other issues occur:

```bash
p10k configure
```
