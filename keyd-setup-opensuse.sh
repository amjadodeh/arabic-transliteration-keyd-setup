#!/bin/bash

sudo zypper in -y keyd

sudo mkdir -p /etc/keyd/

ln -s /usr/share/keyd/keyd.compose ~/.XCompose

head -n 10000 ~/.XCompose > ~/.XCompose.temp && mv -f ~/.XCompose.temp ~/.XCompose

sudo tee /etc/keyd/default.conf 1> /dev/null <<- 'EOF'
	[ids]

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
EOF

systemctl enable --now keyd.service

echo "Done! Please restart your applications for this to take effect."

