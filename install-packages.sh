sudo pacman -Syu

# common apps
sudo pacman -S --needed --noconfirm git base-devel i3-gaps alacritty dunst picom htop neofetch ranger vim polybar rofi nitrogen chromium

# pipewire
sudo pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse
systemctl --user enable pipewire pipewire-pulse pipewire-alsa

# installing zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


# installing yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# fonts
yay -S --noconfirm nerd-fonts-fantasque-sans-mono ttf-jetbrains-mono noto-fonts-emoji ttf-sourcecodepro-nerd

# other apps 
yay -S --noconfirm visual-studio-code-bin spotify pfetch

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# other
sudo pacman -S --noconfirm nodejs npm go

echo "Installing vscode extensions..."
# vscode extensions
pkglist=(
	golang.Go
	pkief.material-icon-theme
	esbenp.prettier-vscode
	hbenl.test-adapter-converter
	hbenl.vscode-test-explorer
	johnsoncodehk.vscode-typescript-vue-plugin
	johnsoncodehk.volar
	bungcip.better-toml
    erayuzgur.crates
	icrawl.discord-vscode
	editorconfig.editorconfig
    dbaeumer.vscode-eslint
	yandeu.five-server
	prisma.prisma-insider
	humao.rest-client
	rust-lang.rust
	swellaby.vscode-rust-test-adapter
	matklad.rust-analyzer
	bradlc.vscode-tailwindcss
	octref.vetur
	zxh404.vscode-proto3
	redhat.vscode-yaml
	ms-azuretools.vscode-docker
    eamodio.gitlens
)

for i in ${pkglist[@]}; do
	  code --install-extension $i
done