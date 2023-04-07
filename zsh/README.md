# zsh

## Introduction

## Installation

Install and configure `zsh` with the provided installation script:

```bash
./setup_zsh.sh
```

Switch between `bash` and `zsh` with the following commands:

```bash
bash
zsh
```

Change the default shell to `zsh` with the following commands:

```bash
chsh -s $(which zsh)
```

Finally, I would recommend `terminator` as a terminal app, which has a nice split screen feature. Install it with:

```bash
sudo apt install terminator
```

## Favorites Commands

Some of my personal favorites:

### oh-my-zsh

- <kbd>Ctrl</kbd> + <kbd>R</kbd> - will search your history for the command you are typing
  - if you start typing your command and use <kbd>↑</kbd> it will cycle through previous commands that match

- <kbd>Ctrl</kbd> + <kbd>T</kbd> - will recursively search the current directory for the file you are typing
  - can be used with other commands like `cd` and `python`

- `agi <package>` - will install a package with `sudo apt-get install`
  - other nice option: `agu` for `sudo apt-get update`

- `fuck` - will try to autocorrect the mistake in your previous command and prompt you with a solution. Some examples of mistakes:
  - if you made a type:, e.g. `puthon`
  - if you forgot to add a flag, e.g. `rm <folder>`
  - if you try to install the wrong package, e.g. `pip3 install yaml` or
  - if you forgot to add `sudo`
  - if you forgot to set the remote as upstream on your new branch when you push
  - and many more, just try and see

- `gcb branch-name` - to create and checkout a new branch. Also like:
  - `gco` for `git checkout`, and `gco -` to checkout the previous branch
  - `gst` for `git status`, and `gsb` for `git status --short -b`

- `google` - will directly search what you type on that search engine, also works for StackOverflow
  - example: `google is pluto a planet`
  - example: `stackoverflow how to concatenate std::string and int c++`

- `is_json < my_file.json` - will return if your file is a valid json
  - also nice:

- `jira branch` - opens the JIRA ticket referenced in the branch name in your browser
  - For this to work you need to update the url in `.jira-url` to match your board.
  - Als works with `jira new` and `jira mine`.

- `z` - jump around your filesystem with `z <folder>`. It will search for matches and you can use <kbd>Tab</kbd> to auto-complete, but it will only work for folders you have visited before.

### Custom functions and aliases

- `create_venv` will create a virtual environment, activate it and install the requirements for that directory
- `activate` will activate the default virtual environment (`venv`) for that directory

## Other Functionality

- auto-completion for packages such as `docker`, `git`, `helm`, `kubectl` and `minikube`.
- automatic fetching of all changes from all remotes every minute while you are working in a git-initialized directory.
  - can be disabled/enabled with `git-auto-fetch`
- prefix your command with `sudo` by press <kbd>Esc</kbd> twice
