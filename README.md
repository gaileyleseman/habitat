# Habitat

Scripts and programs for setting up a new PC.

## PC Setup

Helper script to configure a new PC.
The script will install a set of packages, programs and tools that you might find useful.
Run the script with `./pc/setup_pc.sh`.

## zsh

Helper script to install and configure `zsh`.
The script will also install `oh-my-zsh` with a Powerlevel10k theme and a set of plugins for auto-completion and aliases for commonly used packages. Run the script with `./zsh/setup_zsh.sh`.
More information in the [README](./zsh/README.md), see the image below for an example of the prompt.

![image](https://user-images.githubusercontent.com/22048962/230769612-e225fd30-305d-469b-ab2d-20af62dc3751.png)

## Linting and Formatting


## Pre-commit

Git hooks are scripts that Git executes before or after events such as: commit, push, and receive.
You can use these hooks to catch (style) errors before they are committed by running linting and formatting tools.
[Pre-commit](https://pre-commit.com/) is a multi-language package manager that allows you to easily install and manage pre-commit hooks.

To use pre-commit, you'll need to create a configuration file named `.pre-commit-config.yaml` in the root of your repository.
Then run the following commands to install pre-commit and install the hooks specified in the configuration file.

```bash
pip install pre-commit
pre-commit install
```

Alternatively, if you have set up the `toolbox` functions from this repository, you use the following command to copy the pre-commit configuration file from this repository to your current working directory.

```bash
pre-commit-copy-habitat
```
