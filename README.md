
# Arabic Transliteration Keyd Setup

**WARNING: This will overwrite your current keyd config (/etc/keyd/default.conf) if you already have one.**

This repository contains scripts to configure keyd for mapping Arabic characters to specific Unicode characters, facilitating Arabic to English transliteration on Linux systems.

## Purpose

Scholarly writings English usually don't use Arabic script, but rather a romanized *transliteration*, whereby each Arabic letter is written with a Latin letter with diacritics added for the sounds plain Latin can't otherwise distinguish. Characters like ḥ, ṣ, ā, and ʿ aren't on any standard keyboard layout, which makes them tedious to type.

This repository configures [keyd](https://github.com/rvaiya/keyd) so that holding **Left Alt** turns your normal letter keys into those transliteration characters. For example, `Alt + h` types **ḥ**, `Alt + s` types **ṣ**, and adding **Shift** gives the capital (**Ḥ**). Every other key still types normally, so the layer is only there when you actually want a special character.

These characters follow the **IJMES** (International Journal of Middle East Studies) transliteration system, the standard used in English-language Middle East studies. It writes the long vowels with macrons (ā, ī, ū), marks ḥ and the four emphatic consonants (ṣ, ḍ, ṭ, ẓ) with a dot below, and renders ʿayn (ʿ) and hamza (ʾ) with half-rings. Everything else is typed with ordinary keys (plain Latin letters and the digraphs th, kh, dh, sh, and gh) so only these non-ASCII characters need remapping.

| Keys | Output | Arabic letter |
|:----:|:------:|:-------------:|
| `Alt + a` | ā | ا&nbsp;&nbsp;(long ā) |
| `Alt + d` | ḍ | ض&nbsp;&nbsp;ḍād |
| `Alt + h` | ḥ | ح&nbsp;&nbsp;ḥāʾ |
| `Alt + i` | ī | ي&nbsp;&nbsp;(long ī) |
| `Alt + s` | ṣ | ص&nbsp;&nbsp;ṣād |
| `Alt + t` | ṭ | ط&nbsp;&nbsp;ṭāʾ |
| `Alt + u` | ū | و&nbsp;&nbsp;(long ū) |
| `Alt + z` | ẓ | ظ&nbsp;&nbsp;ẓāʾ |
| `Alt + j` | ʾ | ء&nbsp;&nbsp;hamza |
| `Alt + l` | ʿ | ع&nbsp;&nbsp;ʿayn |

Add **Shift** for the capital forms (Ā, Ḍ, Ḥ, Ī, Ṣ, Ṭ, Ū, Ẓ), used for proper nouns and at the start of sentences. ʿayn and hamza have no capital forms.

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
	#https://dl-cdn.alpinelinux.org/alpine/edge/testing
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
	j = ʾ
	l = ʿ

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
	j = ʾ
	l = ʿ

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
	j = ʾ
	l = ʿ

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

Simply put the following in your configuration.nix and switch to the new configuration:

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
            a = "ā";  # ا alif (long vowel)
            d = "ḍ";  # ض ḍād
            h = "ḥ";  # ح ḥāʾ
            i = "ī";  # ي yāʾ (long vowel)
            s = "ṣ";  # ص ṣād
            t = "ṭ";  # ط ṭāʾ
            u = "ū";  # و wāw (long vowel)
            z = "ẓ";  # ظ ẓāʾ
            j = "ʾ";  # ء hamza
            l = "ʿ";  # ع ʿayn
          };

          "alt+shift" = {
            a = "Ā";  # ا alif (long vowel)
            d = "Ḍ";  # ض ḍād
            h = "Ḥ";  # ح ḥāʾ
            i = "Ī";  # ي yāʾ (long vowel)
            s = "Ṣ";  # ص ṣād
            t = "Ṭ";  # ط ṭāʾ
            u = "Ū";  # و wāw (long vowel)
            z = "Ẓ";  # ظ ẓāʾ
          };
        };
      };
    };
  };

  # Enable unicode suppert system-wide by settings the $XCOMPOSEFILE environment variable
  # Alternatively, compose file can be enabled on a per-user basis using home-manager
  environment.sessionVariables."XCOMPOSEFILE" = "${pkgs.keyd}/share/keyd/keyd.compose";

  # Optional, but makes sure that when you type the make palm rejection work with keyd
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
```

