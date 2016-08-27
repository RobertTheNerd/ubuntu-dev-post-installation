# Ubuntu initialization script
This is the script to install & config a Ubuntu dev machine. Tested for Ubuntu 16.04. #DRY.


## How to use
```
# Make sure to use bash instead of sh here as pushd is not available in sh.
curl -L "https://goo.gl/HhvNlV" | bash
```
## Post scripts (somehow embarassing)
* oh-my-zsh script will not be able to succeed the last step due to PAM authentication error. Run the following script manually:
```
chsh -s /usr/bin/zsh
```
