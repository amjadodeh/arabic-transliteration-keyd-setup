#!/bin/ash

doas setup-apkrepos -c1

doas apk update

doas apk add keyd

doas mkdir -p /etc/keyd/

ln -s /usr/share/keyd/keyd.compose ~/.XCompose

head -n 10000 ~/.XCompose > ~/.XCompose.temp && mv -f ~/.XCompose.temp ~/.XCompose

doas tee /etc/keyd/default.conf 1> /dev/null <<- 'EOF'
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

doas rc-update add keyd default
doas rc-service keyd start

echo ""
echo "Done! Please restart your system for changes to take effect."

