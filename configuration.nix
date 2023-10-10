{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  # services.xserver = {
  #   layout = "us";
  #   xkbVariant = "";
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dme = {
    isNormalUser = true;
    description = "dme";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "dme";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    neovim
    curl
    wayland
    waybar
    wofi
  ];

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    ohMyZsh.enable = true;
    ohMyZsh.theme = "gentoo";
  };
  users.defaultUserShell = pkgs.zsh;

  programs.hyprland.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd /home/dme/scripts/start";
	user = "dme";
      };
    };
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  home-manager.users.dme = { pkgs, ... }: {
    home.stateVersion = "23.05";
    programs.git = {
      enable = true;
      userName = "ggemre";
      userEmail = "gmoore1@byu.edu";
    };
    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        window = {
	  padding.x = 8;
	  padding.y = 8;
        };
	font = {
	  normal = {
	    family = "Fira Code";
	    style = "Regular";
	  };
	  bold = {
	    family = "Fira Code";
	    style = "Bold";
	  };
	  italic = {
	    family = "Fira Code";
	    style = "Italic";
	  };
	  bold_italic = {
	    family = "Fira Code";
	    style = "Bold Italic";
	  };
	  size = 11;
	};
      };
    };
    home.file.".config/hypr/hyprland.conf".text = ''
	# See https://wiki.hyprland.org/Configuring/Monitors/
	monitor=,preferred,auto,auto


	# See https://wiki.hyprland.org/Configuring/Keywords/ for more

	# Execute your favorite apps at launch
	exec-once = waybar # & hyprpaper & firefox

	# Source a file (multi-file configs)
	# source = ~/.config/hypr/myColors.conf

	# Some default env vars.
	env = XCURSOR_SIZE,24

	# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
	input {
	    kb_layout = us
	    kb_variant =
	    kb_model =
	    kb_options =
	    kb_rules =

	    follow_mouse = 1

	    touchpad {
		natural_scroll = no
	    }

	    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
	}

	general {
	    # See https://wiki.hyprland.org/Configuring/Variables/ for more

	    gaps_in = 5
	    gaps_out = 20
	    border_size = 2
	    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
	    col.inactive_border = rgba(595959aa)

	    layout = dwindle
	}

	decoration {
	    # See https://wiki.hyprland.org/Configuring/Variables/ for more

	    rounding = 10
	    blur = yes
	    blur_size = 3
	    blur_passes = 1
	    blur_new_optimizations = on

	    drop_shadow = yes
	    shadow_range = 4
	    shadow_render_power = 3
	    col.shadow = rgba(1a1a1aee)
	}

	animations {
	    enabled = yes

	    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

	    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

	    animation = windows, 1, 7, myBezier
	    animation = windowsOut, 1, 7, default, popin 80%
	    animation = border, 1, 10, default
	    animation = borderangle, 1, 8, default
	    animation = fade, 1, 7, default
	    animation = workspaces, 1, 6, default
	}

	dwindle {
	    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
	    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
	    preserve_split = yes # you probably want this
	}

	master {
	    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
	    new_is_master = true
	}

	gestures {
	    # See https://wiki.hyprland.org/Configuring/Variables/ for more
	    workspace_swipe = off
	}

	# Example per-device config
	# See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
	device:epic-mouse-v1 {
	    sensitivity = -0.5
	}

	# Example windowrule v1
	# windowrule = float, ^(kitty)$
	# Example windowrule v2
	# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
	# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


	# See https://wiki.hyprland.org/Configuring/Keywords/ for more
	$mainMod = SUPER

	# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
	bind = $mainMod, T, exec, alacritty
	bind = $mainMod, B, exec, librewolf
	bind = $mainMod, C, killactive, 
	bind = $mainMod, M, exit, 
	bind = $mainMod, V, togglefloating, 
	bind = $mainMod, R, exec, wofi --show drun
	bind = $mainMod, P, pseudo, # dwindle
	bind = $mainMod, J, togglesplit, # dwindle

	# Move focus with mainMod + arrow keys
	bind = $mainMod, left, movefocus, l
	bind = $mainMod, right, movefocus, r
	bind = $mainMod, up, movefocus, u
	bind = $mainMod, down, movefocus, d

	# Switch workspaces with mainMod + [0-9]
	bind = $mainMod, 1, workspace, 1
	bind = $mainMod, 2, workspace, 2
	bind = $mainMod, 3, workspace, 3
	bind = $mainMod, 4, workspace, 4
	bind = $mainMod, 5, workspace, 5
	bind = $mainMod, 6, workspace, 6
	bind = $mainMod, 7, workspace, 7
	bind = $mainMod, 8, workspace, 8
	bind = $mainMod, 9, workspace, 9
	bind = $mainMod, 0, workspace, 10

	# Move active window to a workspace with mainMod + SHIFT + [0-9]
	bind = $mainMod SHIFT, 1, movetoworkspace, 1
	bind = $mainMod SHIFT, 2, movetoworkspace, 2
	bind = $mainMod SHIFT, 3, movetoworkspace, 3
	bind = $mainMod SHIFT, 4, movetoworkspace, 4
	bind = $mainMod SHIFT, 5, movetoworkspace, 5
	bind = $mainMod SHIFT, 6, movetoworkspace, 6
	bind = $mainMod SHIFT, 7, movetoworkspace, 7
	bind = $mainMod SHIFT, 8, movetoworkspace, 8
	bind = $mainMod SHIFT, 9, movetoworkspace, 9
	bind = $mainMod SHIFT, 0, movetoworkspace, 10

	# Scroll through existing workspaces with mainMod + scroll
	bind = $mainMod, mouse_down, workspace, e+1
	bind = $mainMod, mouse_up, workspace, e-1

	# Move/resize windows with mainMod + LMB/RMB and dragging
	bindm = $mainMod, mouse:272, movewindow
	bindm = $mainMod, mouse:273, resizewindow
    '';
  };
}
