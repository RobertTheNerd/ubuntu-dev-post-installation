# Ubuntu post installation script
This is the script to install & config a Ubuntu dev machine. Tested with Ubuntu 16.04. #DRY.
Features/software:
* No password for sudo
* git
* tree
* zsh, oh-my-zsh
* tmux (configured with zsh)
* vim, awesome_vimrc
* openssh-server
* LAMP
* Oracle JDK 8 
* Google Chrome
* sublime text 
* Indicator Netspeed 
* appgrid


## How to use
```
# Make sure to use bash instead of sh here as pushd is not available in sh.
curl -sSL "https://goo.gl/HhvNlV" | bash
```
## Post scripts (somehow embarassing)
* oh-my-zsh script will not be able to succeed the last step due to PAM authentication error. Run the following script manually:
```
chsh -s /usr/bin/zsh
```
