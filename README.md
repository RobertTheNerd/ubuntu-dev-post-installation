# Ubuntu post-installation script
This is the script to install & config a Ubuntu dev machine. Tested with Ubuntu 16.04. #DRY.

Features/software:
* No password for sudo
* curl
* git
* tree
* zsh, oh-my-zsh
* tmux (configured with zsh)
* ~~vim, awesome_vimrc~~
* OpenSSH-Server
* ~~LAMP~~, Apache & PHP
* ~~.Net Core~~
* ~~Oracle JDK 8~~
* Node.js
* Docker
* ~~Google Chrome~~
* ~~Sublime Text~~ 
* ~~Indicator Netspeed ~~
* ~~AppGrid~~


## How to use
After system installation, run the command below under your non-root account:
```
wget -q -O- --header="Cache-Control: no-cache" "https://goo.gl/sjKqgP"  | sh
```
or 
```
curl -sSL "https://goo.gl/sjKqgP" -H 'Cache-Control: no-cache' | sh
```
