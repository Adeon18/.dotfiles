# How to Configure Arch after install

### Installing Base Packages
_The files with dependencies that can be installed are in the `dependencies` folder._
- `base_dep.txt` and `tools_dep.txt` can be installed via `pacman -S - < <file>`.
- `other_dep.txt` should be installed via something like `paru`, `aura` or `yay`.

### Enable services
**tlp**:
```
sudo tlp start
sudo systemctl enable tlp.service
```
---
**betterlockscreen**:
```
betterlockscreen -u ~/.dotfiles/backgrounds/red_cyan_futuristic.png --fx dim,pixel
systemctl enable betterlockscreen@$USER
```
---
**zsh**:
```
cd ~
mkdir opt
cd opt/
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
```
---

