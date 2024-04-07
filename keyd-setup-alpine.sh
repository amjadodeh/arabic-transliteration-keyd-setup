#!/bin/ash

echo "
https://dl-cdn.alpinelinux.org/alpine/v$(cut -d'.' -f1,2 /etc/alpine-release)/main/
https://dl-cdn.alpinelinux.org/alpine/v$(cut -d'.' -f1,2 /etc/alpine-release)/community/
https://dl-cdn.alpinelinux.org/alpine/edge/testing/
" | doas tee /etc/apk/repositories 1> /dev/null

doas apk update

doas apk add keyd

doas mkdir -p /etc/keyd/

ln -s /usr/share/keyd/keyd.compose ~/.XCompose

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
" | doas tee /etc/keyd/default.conf 1> /dev/null

doas rc-update add keyd default
doas rc-service keyd start

echo ""
echo "Done! Please restart your system for changes to take effect."

