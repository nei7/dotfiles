#!/usr/bin/env bash

BACKUP_FOLDER_PATH="$HOME/backup"

success () {
  local message=$1  
  printf "$(tput setaf 2)✓ Success:$(tput sgr0) $message \n"
}

info () {
  local message=$1  
  printf "$(tput setaf 4)ℹ Info:$(tput sgr0) $message \n"
}


fail () {
  printf "$(tput setaf 3)⚠ Error:$(tput sgr0) $message \n"
  echo ''
  exit
}

warning () {
  local message=$1  
  printf "$(tput setaf 3)→ Warning:$(tput sgr0) $message\n"
}

link_file() {
    local src=$1 dst=$2

    local overwrite= skip= backup

  
    if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
    then
   
      warning "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
[s]kip [o]verwrite [b]ackup"

      local action=
      read -n 1 -s action

      case $action in 
        o )
          overwrite=true  
        ;;
        s )
          skip=true
        ;;
        b )
          backup=true
        ;;
        * ) 
        ;;
     esac

    fi

    if [ "$skip" == "true" ]
    then
         success "skiped $src"
    fi

    if [ "$overwrite" == "true" ]
    then 
        rm -rf "$dst"
        success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv $dst "$BACKUP_FOLDER_PATH/$(basename $dst)"
    fi

    if [ "$skip" != "true" ]
    then
       ln -fs "$1" "$2"
       success "linked $1 to $2"
    fi

}

pkg_installed() {
  pacman -Qi "$1" &> /dev/null
  return $?
}

install_yay() {
  if pkg_installed yay
  then
     info "yay is already installed..."
  fi

  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si

  if [ $? -eq 0 ]
  then
    info "yay installed..."
  else
    error "yay installation failed..."
  fi
}


install_dotfiles() {
  for f in $(find . -type f);
  do
    if grep .ignore -q $f
    then
      continue
    fi
    out_file=$HOME/$f
    if [ ! -d $(dirname $out_file) ]
    then
      mkdir -p $(dirname $out_file)
    fi
    link_file $f $out_file
  done
}

install_dependencies() {
  sudo pacman -S --noconfirm base-devel xorg-server xorg-apps xorg-xinit i3-gaps nodejs npm go git dunst picom htop neofetch ranger vim polybar rofi nitrogen chromium alacritty ly zsh zsh-autosuggestions zsh-syntax-highlighting
  yay -S --noconfirm nerd-fonts-fantasque-sans-mono ttf-jetbrains-mono noto-fonts-emoji ttf-sourcecodepro-nerd visual-studio-code-bin spotify

}

download_dotfiles() {
  info "Cloning repo..."
  git clone https://github.com/nei7/dotfiles
  cd "dotfiles"
}

main() {
  download_dotfiles

  if [ ! -d $BACKUP_FOLDER_PATH ]
  then
    mkdir $BACKUP_FOLDER_PATH
  fi

  install_yay
  install_dependencies
  install_dotfiles

  # display manager
  systemctl enable ly.service
  systemctl disable getty@tty2.service

  if [[ $SHELL != "/usr/bin/zsh" ]]; then
    info "Changing shell to zsh, your root pass is needed."
    chsh -s /usr/bin/zsh
  else
    success "%s%sYour shell is already zsh\nGood bye! installation finished, now reboot%s\n"
    zsh
  fi
}

main

