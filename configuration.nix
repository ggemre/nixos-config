{ config, pkgs, lib, ... }:

let
  theme = {
    font = "Fira Code";
    color = {
      rosewater = "f5e0dc";
      flamingo = "f2cdcd";
      pink = "f5c2e7";
      mauve = "cba6f7";
      red = "f38ba8";
      maroon = "eba0ac";
      peach = "fab387";
      yellow = "f9e2af";
      green = "a6e3a1";
      teal = "94e2d5";
      sky = "94e2d5";
      saphire = "74c7ec";
      blue = "89b4fa";
      lavender = "b4befe";
      text = "cdd6f4";
      subtext1 = "bac2de";
      subtext0 = "a6adc8";
      overlay2 = "9399b2";
      overlay1 = "7f849c";
      overlay0 = "6c7086";
      surface2 = "585b70";
      surface1 = "45475a";
      surface0 = "313244";
      base = "1e1e2e";
      mantle = "181825";
      crust = "11111b";
    };
  };
in {
  imports = [ # Include the results of the hardware scan.
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

  hardware.pulseaudio.enable = true;

  # MacBook specific settings
  hardware.facetimehd.enable = false;
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  boot.kernelParams = [ "acpi_backlight=vendor" "acpi_osi=" ];
  services.xserver.deviceSection = lib.mkDefault ''
    Option "TearFree" "true"
  '';

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
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [ ];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "dme";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [ curl wayland wofi acpi wbg ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = { sudo = "sudo "; };
    shellInit = ''
      parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
      }
      setopt PROMPT_SUBST
      PROMPT='%n@%m %~ $(parse_git_branch) '
    '';
  };
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command =
          "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd /home/dme/scripts/start";
        user = "dme";
      };
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

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
    home = {
      stateVersion = "23.05";
      pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 10;
      };
    };
    programs.git = {
      enable = true;
      userName = "";
      userEmail = "";
    };
    programs.helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "catppuccin_mocha";
        keys.normal = {
          j = "move_char_left";
          k = "move_visual_line_down";
          l = "move_visual_line_up";
          ";" = "move_char_right";
          h = "collapse_selection";
        };
      };
    };
    programs.firefox = { enable = true; };
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
            family = theme.font;
            style = "Regular";
          };
          bold = {
            family = theme.font;
            style = "Bold";
          };
          italic = {
            family = theme.font;
            style = "Italic";
          };
          bold_italic = {
            family = theme.font;
            style = "Bold Italic";
          };
          size = 9;
        };
        colors = {
          primary = {
            background = "#${theme.color.base}";
            foreground = "#${theme.color.text}";
            dim_foreground = "#${theme.color.text}";
            bright_foreground = "#${theme.color.text}";
          };
          cursor = {
            text = "#${theme.color.base}";
            cursor = "#${theme.color.rosewater}";
          };
          vi_mode_cursor = {
            text = "#${theme.color.base}";
            cursor = "#${theme.color.lavender}";
          };
          search = {
            matches = {
              foreground = "#${theme.color.base}";
              background = "#${theme.color.subtext0}";
            };
            focused_match = {
              foreground = "#${theme.color.base}";
              background = "#${theme.color.green}";
            };
            footer_bar = {
              foreground = "#${theme.color.base}";
              background = "#${theme.color.subtext0}";
            };
          };
          hints = {
            start = {
              foreground = "#${theme.color.base}";
              background = "#${theme.color.yellow}";
            };
            end = {
              foreground = "#${theme.color.base}";
              background = "#${theme.color.subtext0}";
            };
          };
          selection = {
            text = "#${theme.color.base}";
            background = "#${theme.color.rosewater}";
          };
          normal = {
            black = "#${theme.color.surface1}";
            red = "#${theme.color.red}";
            green = "#${theme.color.green}";
            yellow = "#${theme.color.yellow}";
            blue = "#${theme.color.blue}";
            magenta = "#${theme.color.pink}";
            cyan = "#${theme.color.teal}";
            white = "#${theme.color.subtext1}";
          };
          bright = {
            black = "#${theme.color.surface1}";
            red = "#${theme.color.red}";
            green = "#${theme.color.green}";
            yellow = "#${theme.color.yellow}";
            blue = "#${theme.color.blue}";
            magenta = "#${theme.color.pink}";
            cyan = "#${theme.color.teal}";
            white = "#${theme.color.subtext1}";
          };
          dim = {
            black = "#${theme.color.surface1}";
            red = "#${theme.color.red}";
            green = "#${theme.color.green}";
            yellow = "#${theme.color.yellow}";
            blue = "#${theme.color.blue}";
            magenta = "#${theme.color.pink}";
            cyan = "#${theme.color.teal}";
            white = "#${theme.color.subtext1}";
          };
        };
      };
    };
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        main = {
          layer = "top";
          position = "top";
          height = 22;
          "modules-left" = [ "hyprland/workspaces" ];
          "modules-center" = [ "clock" ];
          "modules-right" = [ "network" "pulseaudio" "cpu" "battery" ];
          "hyprland/workspaces" = { format = "{name}"; };
          clock = {
            interval = 1;
            format = "{:%H:%M}";
            tooltip = true;
          };
          network = {
            format-wifi = "wifi";
            format-ethernet = "ether";
            format-disconnected = "none";
            tooltip = false;
          };
          battery = {
            format = "{capacity}";
            format-charging = "{capacity}";
            format-full = "{capacity}";
            bat-compatibility = true;
          };
        };
      };
      style = ''
                * {
        	  border: none;
        	  border-radius: 8;
        	  font-family: ${theme.font};
        	  font-size: 11px;
        	  font-weight: 500;
                }
        	window#waybar {
        	  background: transparent;
                }
        	#workspaces {
        	  border-radius: 10px;
        	  background-color: #${theme.color.base};
        	  color: #${theme.color.rosewater};
        	  margin-top: 15px;
        	  margin-right: 15px;
        	  padding-top: 1px;
        	  padding-left: 10px;
        	  padding-right: 10px;
        	}
        	#workspaces button {
        	  background-color: #${theme.color.base};
        	  color: #${theme.color.rosewater};
        	  border-bottom: 5px solid #${theme.color.base};
        	  padding: 0;
        	  margin: 0;
        	}
        	#workspaces button.active {
        	  border-bottom: 5px solid #${theme.color.mauve};
        	}
        	#clock, #battery, #network, #pulseaudio, #cpu {
        	  border-radius: 10px;
        	  background-color: #${theme.color.base};
        	  color: #${theme.color.rosewater};
        	  margin-top: 15px;
        	  padding-left: 10px;
        	  padding-right: 10px;
        	  margin-right: 15px;
        	}
      '';
    };
    home.file.".config/hypr/hyprland.conf".text = ''
      	# See https://wiki.hyprland.org/Configuring/Monitors/
      	monitor=,preferred,auto,auto

      	# Execute your favorite apps at launch
      	exec-once = waybar & wbg 'find $HOME/media/images/wallpapers | shuf -n 1'

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
      	    col.active_border = 0xff${theme.color.blue} 0xff${theme.color.lavender} 45deg
      	    col.inactive_border = 0xff${theme.color.overlay2}

      	    layout = dwindle
      	}

      	decoration {
      	    # See https://wiki.hyprland.org/Configuring/Variables/ for more

      	    rounding = 10
      	    
      	    blur {
      		enabled = true
      		size = 3
      		passes = 1
      	    }

      	    drop_shadow = yes
      	    shadow_range = 4
      	    shadow_render_power = 3
      	    col.shadow = 0xff${theme.color.surface1}
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
        bind = $mainMod, B, exec, firefox
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
