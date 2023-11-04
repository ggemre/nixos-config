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

  # Audio settings
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

  # Generation garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than-7d";
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
    # packages = with pkgs; [ ];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "dme";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [ curl wayland acpi wbg wtype wl-clipboard pure-prompt bemoji rofi-power-menu ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = { sudo = "sudo "; };
    promptInit = ''
      autoload -U promptinit; promptinit
      prompt pure 
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
          "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "dme";
      };
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
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
      sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
      };
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
          "A-h" = "flip_selections";
          "A-j" = "select_prev_sibling";
          "A-k" = "shrink_selection";
          "A-l" = "expand_selection";
          "A-;" = "select_next_sibling";
          z = { k = "scroll_down"; l = "scroll_up"; };
          g = { j = "goto_line_start"; ";" = "goto_line_end"; };
          "C-w" = { 
            j = "jump_view_left";
            "C-j" = "jump_view_left";
            k = "jump_view_down";
            "C-k" = "jump_view_down";
            l = "jump_view_up";
            "C-l" = "jump_view_up";
            ";" = "jump_view_right";
            "C-;" = "jump_view_right";
          };
        };
        keys.select = {
          j = "extend_char_left";
          k = "extend_visual_line_down";
          l = "extend_visual_line_up";
          ";" = "extend_char_right";
          h = "collapse_selection";
          "A-h" = "flip_selections";
          "A-j" = "select_prev_sibling";
          "A-k" = "shrink_selection";
          "A-l" = "expand_selection";
          "A-;" = "select_next_sibling";
          z = { k = "scroll_down"; l = "scroll_up"; };
          g = { j = "goto_line_start"; ";" = "goto_line_end"; };
          "C-w" = { 
            j = "jump_view_left";
            "C-j" = "jump_view_left";
            k = "jump_view_down";
            "C-k" = "jump_view_down";
            l = "jump_view_up";
            "C-l" = "jump_view_up";
            ";" = "jump_view_right";
            "C-;" = "jump_view_right";
          };
        };
      };
    };
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      font = theme.font;
      plugins = with pkgs; [
        rofi-calc
      ];
      theme = builtins.toString (pkgs.writeText "rofi-theme" ''
          * {
            font: "${theme.font} 10";
          }
          element-text, element-icon , mode-switcher {
            background-color: #${theme.color.base};
            text-color: inherit;
          }
          window {
            transparency: "real";
            location: center;
            anchor: center;
            orientation: vertical;
            height: 350px;
            width: 500px;
            border: 3px;
            border-color: #${theme.color.lavender};
            background-color: #${theme.color.surface0};
            border-radius: 12px;
          }
          mainbox {
            background-color: #${theme.color.base};
            children: [mode-switcher, message, inputbar, listview];
          }
          mode-switcher {
            spacing: 0;
          }
          button selected {
            background-color: #${theme.color.blue};
            text-color: #${theme.color.surface2};
          }
          message {
            background-color: #${theme.color.base};
            padding: 2px 0px 2px;
          }
          textbox {
            padding: 5px 5px 5px 30px;
            background-color: #${theme.color.base};
            text-color: #${theme.color.rosewater};
          }
          inputbar {
            children: [entry];
            background-color: #${theme.color.base};
            border-radius: 5px;
            padding: 2px;
          }
          prompt {
            background-color: #${theme.color.surface0};
            padding: 6px;
            text-color: #${theme.color.text};
            border-radius: 3px;
            margin: 20px 0px 0px 20px;
          }
          textbox-prompt-colon {
            expand: false;
            str: ":";
          }
          entry {
            padding: 6px 0px 0px;
            margin: 10px 0px 0px 10px;
            text-color: #${theme.color.rosewater};
            background-color: #${theme.color.base};
          }
          listview {
            border: 0px 0px 0px;
            padding: 6px 0px 0px;
            margin: 10px 0px 0px 10px;
            columns: 1;
            background-color: #${theme.color.base};
          }
          element {
            padding: 5px;
            background-color: #${theme.color.base};
            text-color: #${theme.color.rosewater} ;
          }
          element-icon {
            size: 25px;
          }
          element selected {
            background-color: #${theme.color.surface2};
            text-color: #${theme.color.rosewater};
          }
          button {
            padding: 10px;
            background-color: #${theme.color.base};
            text-color: #${theme.color.text};
            vertical-align: 0.5;
            horizontal-align: 0.5;
          }
      '');
    };
    programs.firefox = { 
      enable = true; 
      package = pkgs.firefox-wayland;
      profiles = {
        main = {
          id = 0;
          name = "main";
          search = {
            force = true;
            default = "DuckDuckGo";
            engines = {
              "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "type"; value = "packages"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
            };
          };
          settings = {
            "general.smoothScroll" = true;
            "devtools.theme" = "dark";
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.archive.enabled" = false;
            "experiments.supported" = false;
            "experiments.enabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.healthreport.service.enabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "signon.rememberSignons" = false;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.newtabpage.enabled" = false;
            "browser.newtabpage.activity-stream.enabled" = false;
            "browser.newtabpage.enhanced" = false;
            "browser.newtab.preload" = false;
            "browser.newtabpage.directory.ping" = "";
            "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "extensions.htmlaboutaddons.discover.enabled" = false;
            "extensions.pocket.enabled" = false;
            "app.normandy.enabled" = false;
            "app.normandy.api_url" = "";
            "extensions.shield-recipe-client.enabled" = false;
            "app.shield.optoutstudies.enabled" = false;
            "dom.battery.enabled" = false;
            "beacon.enabled" = false;
            "browser.send_pings" = false;
            "browser.fixup.alternate.enabled" = false;
          };
          userChrome = ''
            #TabsToolbar { visibility: collapse !important; }
            #sidebar-header { visibility: collapse !important; }
            #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] {
              visibility: collapse !important;
            }
          '';
        };
      };
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
          margin-top = 0;
          margin-bottom = 3;
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "clock" ];
          modules-right = [ "network" "pulseaudio" "cpu" "battery" "custom/power" ];
          "hyprland/workspaces" = { format = ""; };
          clock = {
            interval = 60;
            format = "{:%I:%M %p}";
            format-alt = "{:%a %b %d}";
            tooltip = false;
          };
          network = {
            format-wifi = "󰖩";
            format-ethernet = "󰖩";
            format-disconnected = "󰖪";
            tooltip = false;
          };
          pulseaudio = {
            format = "{icon} {volume}%";
            format-icons = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
          };
          cpu = {
            interval = 10;
            format = "  {}%";
            max-length = 10;
          };
          battery = {
            format = "{capacity}";
            format-charging = "{capacity}";
            format-full = "{capacity}";
            bat-compatibility = true;
          };
          "custom/power" = {
            format = "⏻";
            on-click = "rofi -show p -modi p:'rofi-power-menu --no-symbols'";
            tooltip = false;
          };
        };
      };
      style = ''
          * {
        	  border: none;
        	  font-family: ${theme.font};
        	  font-size: 11px;
        	  font-weight: 400;
          }
        	window#waybar {
        	  background: rgba(43, 48, 59, 0.5);
          }
        	#workspaces {
        	  border-radius: 20px;
        	  background-color: #${theme.color.base};
        	  color: #${theme.color.subtext1};
        	  margin-left: 8px;
        	  padding-left: 7px;
        	  padding-right: 7px;
            font-size: 7px;
        	}
        	#workspaces button {
        	  background-color: #${theme.color.base};
        	  color: #${theme.color.rosewater};
        	  border-bottom: 5px solid #${theme.color.base};
        	  padding: 0;
        	  margin: 0;
        	}
          #workspaces:hover {
            color: #${theme.color.text};
          }
        	#workspaces button.active {
        	  color: #${theme.color.green};
        	}
        	#clock, #battery, #network, #pulseaudio, #cpu, #custom-power {
        	  border-radius: 20px;
        	  background-color: #${theme.color.base};
        	  color: #${theme.color.rosewater};
        	  padding-left: 10px;
        	  padding-right: 12px;
        	  margin-right: 8px;
        	}
          #clock {
            background: transparent;
            color: #${theme.color.text}; 
            font-weight: 500;
          }
          #network {
            color: #${theme.color.sky};
          }
          #pulseaudio {
            color: #${theme.color.peach};
          }
          #cpu {
            color: #${theme.color.yellow};
          }
          #custom-power {
            color: #${theme.color.rosewater};
          }
      '';
    };
    home.file.".config/hypr/hyprland.conf".text = ''
      	# See https://wiki.hyprland.org/Configuring/Monitors/
      	monitor=,preferred,auto,auto

      	# Execute your favorite apps at launch
      	exec-once = waybar & find $HOME/media/images/wallpapers -type f | shuf -n 1 | xargs wbg

      	# Source a file (multi-file configs)
      	# source = ~/.config/hypr/myColors.conf

      	# Some default env vars.
      	env = XCURSOR_SIZE,10
        env = WLR_NO_HARDWARE_CURSORS,1
        env = WLR_RENDERER_ALLOW_SOFTWARE,1

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
      	    gaps_out = 5
      	    border_size = 2
      	    col.active_border = 0xff${theme.color.maroon} 0xff${theme.color.lavender} 45deg
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

      	bind = $mainMod, T, exec, alacritty
        bind = $mainMod, B, exec, firefox
      	bind = $mainMod, Q, killactive, 
      	bind = $mainMod, M, exit, 
      	bind = $mainMod, V, togglefloating, 
      	bind = $mainMod, P, pseudo, # dwindle
      	bind = $mainMod, H, togglesplit, # dwindle
        bind = $mainMod SHIFT, W, exec, find $HOME/media/images/wallpapers -type f | shuf -n 1 | xargs wbg

        bind = $mainMod, SPACE, exec, rofi -show drun
        bind = $mainMod, C, exec, rofi -show calc -modi calc -no-show-match -no-sort -no-persist-history -hint-welcome "" > /dev/null
        bind = $mainMod, E, exec, bemoji -t -n
                
      	# Move focus with mainMod + arrow/hx keys
      	bind = $mainMod, left, movefocus, l
      	bind = $mainMod, right, movefocus, r
      	bind = $mainMod, up, movefocus, u
      	bind = $mainMod, down, movefocus, d
        bind = $mainMod, J, movefocus, l
        bind = $mainMod, K, movefocus, d
        bind = $mainMod, L, movefocus, u
        bind = $mainMod, semicolon, movefocus, r

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
