
# Arabic Transliteration Keyd Setup

**WARNING: This will overwrite your current keyd config (/etc/keyd/default.conf) if you already have one.**

This repository contains scripts to configure keyd for mapping Arabic characters to specific Unicode characters, facilitating Arabic to English transliteration on Linux systems.

## Automated Setup

NOTE: This requires curl to run

### Distros:

- Alpine Linux: `ash <(curl -sL https://bit.ly/keyd-setup-alpine)`
- Debian-based / Ubuntu-based (via nixpkgs): `bash <(curl -sL https://bit.ly/keyd-setup-nixpkgs)`
- Fedora (via nixpkgs): `bash <(curl -sL https://bit.ly/keyd-setup-nixpkgs)`
- openSUSE Leap and Tumbleweed: `bash <(curl -sL https://bit.ly/keyd-setup-opensuse)`
- Any other Non-NixOS distributions (uses nixpkgs): `bash <(curl -sL https://bit.ly/keyd-setup-nixpkgs)`

## Manual Setup

- [Alpine Linux](#alpine-linux)
- [openSUSE](#opensuse)
- [Other Non-NixOS Distros](#using-nix-package-manager-on-non-nixos)
- [NixOS](#using-nixos)

### Alpine Linux:

Run the following in your terminal:

1. Add the community repositories to /etc/apk/repositories (skip this step if its already enabled)
```bash
doas tee /etc/apk/repositories 1> /dev/null <<- EOF
	#/media/cdrom/apks
	https://dl-cdn.alpinelinux.org/alpine/v$(cut -d'.' -f1,2 /etc/alpine-release)/main
	https://dl-cdn.alpinelinux.org/alpine/v$(cut -d'.' -f1,2 /etc/alpine-release)/community
	#https://dl-cdn.alpinelinux.org/alpine/edge/main
	#https://dl-cdn.alpinelinux.org/alpine/edge/community
EOF
```

2. Update the index of available packages to account for new repos
```bash
doas apk update
```

3. Install keyd
```bash
doas apk add keyd
```

4. Make directory for config files if it doesn't already exist
```bash
doas mkdir -p /etc/keyd/
```

5. Add unicode support for current user by symlinking /usr/share/keyd/keyd.compose to ~/.XCompose
```bash
ln -s /usr/share/keyd/keyd.compose ~/.XCompose
```

6. Prune every line in .XCompose after line 10000 to prevent GTK4 compiled apps from crashing
```bash
head -n 10000 ~/.XCompose > ~/.XCompose.temp && mv -f ~/.XCompose.temp ~/.XCompose
```

7. Create file 'default.conf' in keyd config directory if it doesn't already exist and write to that file
```bash
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
```

8. Enable keyd daemon
```bash
doas rc-update add keyd default
```
9. Start keyd daemon
```bash
doas rc-service keyd start
```

Thats it! You should now restart your system for changes to take effect.

### openSUSE:

Run the following in your terminal:

1. Install keyd
```bash
sudo zypper install keyd
```

2. Make directory for config files if it doesn't already exist
```bash
sudo mkdir -p /etc/keyd/
```

3. Add unicode support for current user by symlinking /usr/share/keyd/keyd.compose to ~/.XCompose
```bash
ln -s /usr/share/keyd/keyd.compose ~/.XCompose
```

4. Prune every line in .XCompose after line 10000 to prevent GTK4 compiled apps from crashing
```bash
head -n 10000 ~/.XCompose > ~/.XCompose.temp && mv -f ~/.XCompose.temp ~/.XCompose
```

5. Create file 'default.conf' in keyd config directory if it doesn't already exist and write to that file
```bash
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
```

6. Enable and start keyd daemon
```bash
systemctl enable --now keyd.service
```

Thats it! You may have to restart your applications for this to take effect.

### Using Nix Package Manager (on non-NixOS):

**REQUIREMENTS:**
- curl must be installed
- systemd init system
- /etc/sudoers exists

Run the following in your terminal:

1. Install Nix package manager using the single-user installation script (assuming its not already installed)
```bash
sh <(curl -L https://nixos.org/nix/install) --no-daemon
```

2. Update environment to allow for Nix to work in active shell
```bash
. $HOME/.nix-profile/etc/profile.d/nix.sh
```

3. Install keyd via the Nix package manager
```bash
nix-env -iA nixpkgs.keyd
```

4. Allow for current user to run keyd with sudo without password by appending a line to /etc/sudoers
```bash
echo "$USER ALL=(ALL) NOPASSWD: $HOME/.nix-profile/bin/keyd" | sudo tee -a /etc/sudoers 1> /dev/null
```

5. Make directory in .config for systemd user services if it doesn't already exist
```bash
mkdir -p $HOME/.config/systemd/user/
```

6. Create systemd user service file for keyd
```bash
sudo tee $HOME/.config/systemd/user/keyd.service 1> /dev/null <<- EOF
	[Unit]
	Description=key remapping daemon

	[Service]
	Type=simple
	ExecStart=/usr/bin/sudo $HOME/.nix-profile/bin/keyd

	[Install]
	WantedBy=default.target
EOF
```

7. Make directory for keyd config files if it doesn't already exist
```bash
sudo mkdir -p /etc/keyd/
```

8. Add unicode support for current user by symlinking path of keyd.compose to ~/.XCompose
```bash
ln -s "$(nix-build '<nixpkgs>' --attr keyd --no-out-link)/share/keyd/keyd.compose" ~/.XCompose
```

9. Prune every line in .XCompose after line 10000 to prevent GTK4 compiled apps from crashing
```bash
head -n 10000 ~/.XCompose > ~/.XCompose.temp && mv -f ~/.XCompose.temp ~/.XCompose
```

10. Create file 'default.conf' in keyd config directory if it doesn't already exist and write to that file
```bash
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
```

11. Enable and start keyd daemon
```bash
systemctl --user enable --now keyd.service
```

Thats it! You should now restart your system for changes to take effect.

### Using NixOS:

First, put the following in your configuration.nix and switch to the new configuration:

```nix
  # Enable keyd service and write configs
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            leftalt = "layer(alt)";
          };

          alt = {
            a = "ā";
            d = "ḍ";
            h = "ḥ";
            i = "ī";
            s = "ṣ";
            t = "ṭ";
            u = "ū";
            z = "ẓ";
            l = "ʿ";
            j = "ʾ";
          };

          "alt+shift" = {
            a = "Ā";
            d = "Ḍ";
            h = "Ḥ";
            i = "Ī";
            s = "Ṣ";
            t = "Ṭ";
            u = "Ū";
            z = "Ẓ";
          };
        };
      };
    };
  };

```

Then, run the following commands in your terminal to add unicode support to keyd:

1. Add unicode support for current user by symlinking path of keyd.compose to ~/.XCompose
```bash
ln -s "$(nix-build '<nixpkgs>' --attr keyd --no-out-link)/share/keyd/keyd.compose" "$HOME/.XCompose"
```
2. Prune every line in .XCompose after line 10000 to prevent GTK4 compiled apps from crashing
```bash
head -n 10000 "$HOME/.XCompose" > "$HOME/.XCompose.temp" && mv -f "$HOME/.XCompose.temp" "$HOME/.XCompose"
```
