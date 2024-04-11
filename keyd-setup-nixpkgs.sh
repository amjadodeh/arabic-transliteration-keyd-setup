#!/bin/bash

sh <(curl -L https://nixos.org/nix/install) --no-daemon --yes

. $HOME/.nix-profile/etc/profile.d/nix.sh

nix-env -iA nixpkgs.keyd

echo "$USER ALL=(ALL) NOPASSWD: $HOME/.nix-profile/bin/keyd" | sudo tee -a /etc/sudoers 1> /dev/null

mkdir -p $HOME/.config/systemd/user/

echo "[Unit]
Description=key remapping daemon

[Service]
Type=simple
ExecStart=/usr/bin/sudo $HOME/.nix-profile/bin/keyd

[Install]
WantedBy=default.target
" | sudo tee $HOME/.config/systemd/user/keyd.service 1> /dev/null

sudo mkdir -p /etc/keyd/

KEYD_COMPOSE_PATH=$(sudo find / -name 'keyd.compose' | grep "/nix/store/.*$($HOME/.nix-profile/bin/keyd -v | grep -oP 'v\K[0-9.]+')/share/keyd/keyd.compose")

ln -s $KEYD_COMPOSE_PATH ~/.XCompose

head -n 10000 ~/.XCompose > ~/.XCompose.temp && mv ~/.XCompose.temp ~/.XCompose

echo "[ids]

*

[main]

leftalt = layer(alt)

[alt]

a = ā
d = ḍ
h = ḥ
i = ī
s = ṣ
t = ṭ
u = ū
z = ẓ
l = ʿ
j = ʾ

[alt+shift]

a = Ā
d = Ḍ
h = Ḥ
i = Ī
s = Ṣ
t = Ṭ
u = Ū
z = Ẓ
" | sudo tee /etc/keyd/default.conf 1> /dev/null

systemctl --user enable --now keyd.service

echo ""
echo "Done! Please restart your system for changes to take effect."

