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
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network settings.
  networking.hostName = "nixos";
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Audio settings.
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

  # Setup user account.
  users.users.dme = {
    isNormalUser = true;
    description = "dme";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
  };
  services.getty.autologinUser = "dme";

  # Update nix packages.
  nixpkgs.config = {
    allowUnfree = true;
    pulseaudio = true;
  };

  # Package settings.
  environment.systemPackages = with pkgs; [ 
    curl 
    wayland 
    acpi 
    wbg 
    wtype 
    wl-clipboard 
    bat
    ripgrep
    eza
    pure-prompt
  ];

  # Configure zsh (at system level so we can set as default).
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    histSize = 5000;
    shellAliases = {
      cat = "bat";
      grep = "rg";
      ls = "eza";
    };
    promptInit = ''
      autoload -U promptinit; promptinit
      prompt pure
    '';
  };
  users.defaultUserShell = pkgs.zsh;
  environment = {
    shells = with pkgs; [ zsh ];
    variables = {
      LESSKEY = "$HOME/.less";
      EDITOR = "hx";
    };
  };

  # Configure hyprland (at system level because home manager broke it).
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Configure greeter.
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

  # Font settings.
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    fira-code-symbols
  ];

  # Some programs need SUID wrappers.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # System version for syncing. Do not change.
  system.stateVersion = "23.05";

  # The rest is devoted to home manager.
  home-manager.users.dme = { pkgs, ... }: {
    nixpkgs.config = {
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };
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
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;      
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
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            ublock-origin
            tabcenter-reborn
          ];
          settings = {
            "general.smoothScroll" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            # Startup settings
            "browser.aboutConfig.showWarning" = false;
            "browser.startup.page" = 1;
            "browser.startup.homepage" = "about:home";
            "browser.newtabpage.enabled" = false;
            "browser.newtab.preload" = false;
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "browser.newtabpage.activity-stream.feeds.snippets" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.default.sites" = "";
            # Geolocation settings.
            "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILA_API_KEY%";
            "geo.provider.use_gpsd" = false;
            "geo.provider.use_geoclue" = false;
            "browser.region.network.url" = "";
            "browser.region.update.enabled" = false;
            # Language settings
            "intl.accept_languages" = "en-US, en";
            "javascript.use_us_english_locale" = true;
            # Disable auto-updates and recommendations
            "app.update.background.scheduling.enabled" = false;
            "app.update.auto" = false;
            "extensions.getAddons.showPane" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "browser.discovery.enabled" = false;
            # Telemetry settings
            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemtry.unified" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.server" = "data:,";
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.coverage.opt-out" = true;
            "toolkit.coverage.opt-out" = true;
            "toolkit.coverage.endpoint.base" = "";
            "toolkit.ping-centre.telemetry" = false;
            "beacon.enabled" = false;
            "app.shield.optoutstudies.enabled" = false;
            "app.normandy.enabled" = false;
            "app.normandy.api_url" = "";
            "breakpad.reportURL" = "";
            "browser.tabs.crashReporting.sendReport" = false;
            "captivedetect.canonicalURL" = "";
            "network.captive-portal-service.enabled" = false;
            "network.connectivity-service.enabled" = false;
            # Networking settings
            "network.prefetch-next" = false;
            "network.dns.disablePrefetch" = true;
            "network.predictor.enabled" = false;
            "network.http.speculative-parallel-limit" = 0;
            "browser.places.speculativeConnect.enabled" = false;
            "network.dns.disableIPv6" = true;
            "network.gio.supported-protocols" = "";
            "network.file.disable_unc_paths" = true;
            "permissions.manager.defaultsUrl" = "";
            "network.IDN_show_punycode" = true;
            # Search settings
            "browser.search.suggest.enabled" = false;
            "browser.urlbar.suggest.searches" = false;
            "browser.fixup.alternate.enabled" = false;
            "browser.urlbar.trimURLs" = false;
            "browser.urlbar.speculativeConnect.enabled" = false;
            "browser.formfill.enable" = false;
            "extensions.formautofill.addresses.enabled" = false;
            "extensions.formautofill.available" = "off";
            "extensions.formautofill.creditCards.available" = false;
            "extensions.formautofill.creditCards.enabled" = false;
            "extensions.formautofill.heuristics.enabled" = false;
            "browser.urlbar.quicksuggest.scenario" = "history";
            "browser.urlbar.quicksuggest.enabled" = false;
            "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
            "browser.urlbar.suggest.quicksuggest.sponsored" = false;
            # Password settings
            "signon.rememberSignons" = false;
            "signon.autofillForms" = false;
            "signon.formlessCapture.enabled" = false;
            "network.auth.subresource-http-auth-allow" = 1;
            # Disk cache and Memory
            "browser.cache.disk.enable" = false;
            "browser.sessionstore.privacy_level" = 2;
            "browser.sessionstore.resume_from_crash" = false;
            "browser.pagethumbnails.capturing_disabled" = true;
            "browser.shell.shortcutFavicons" = false;
            "browser.helperApps.deleteTempFileOnExit" = true;
            # TLS-related settings
            "dom.security.https_only_mode" = true;
            "dom.security.https_only_mode_send_http_background_request" = false;
            "browser.xul.error_pages.expert_bad_cert" = true;
            "security.tls.enable_0rtt_data" = false;
            "security.OCSP.require" = true;
            "security.pki.sha1_enforcement_level" = 1;
            "security.cert_pinning.enforcement_level" = 2;
            "security.remote_settings.crlite_filters.enabled" = true;
            "security.pki.crlite_mode" = 2;
            "network.http.referer.XOriginPolicy" = 2;
            "network.http.referer.XOriginTrimmingPolicy" = 2;
            # WebRTC, WebGL, and DRM
            "media.peerconnection.enabled" = false;
            "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
            "media.peerconnection.ice.default_address_only" = true;
            "media.peerconnection.ice.no_host" = true;
            "webgl.disabled" = true;
            "media.autoplay.default" = 5;
            "media.eme.enabled" = false;
            "browser.download.useDownloadDir" = false;
            "browser.download.manager.addToRecentDocs" = false;
            # Cookies
            "browser.contentblocking.category" = "strict";
            "privacy.partition.serviceWorkers" = true;
            "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
            "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = true;
            # UI features
            "dom.disable_open_during_load" = true;
            "dom.popup_allowed_events" = "click dblclick mousedown pointerdown";
            "extensions.pocket.enabled" = false;
            "extensions.Screenshots.disabled" = true;
            "pdfjs.enabledScripting" = false;
            "privacy.userContext.enabled" = true;
            "extensions.enabledScopes" = 5;
            "extensions.webextensions.restrictedDomains" = "";
            "extensions.postDownloadThirdPartyPrompt" = false;
            # Firefox amnesia
            "network.cookie.lifetimePolicy" = 2;
            "privacy.sanitize.sanitizeOnShutdown" = true;
            "privacy.clearOnShutdown.cache" = true;
            "privacy.clearOnShutdown.cookies" = true;
            "privacy.clearOnShutdown.downloads" = true;
            "privacy.clearOnShutdown.formdata" = true;
            "privacy.clearOnShutdown.history" = true;
            "privacy.clearOnShutdown.offlineApps" = true;
            "privacy.clearOnShutdown.sessions" = true;
            "privacy.clearOnShutdown.sitesettings" = false;
            "privacy.sanitize.timeSpan" = 0;
            # Mitigate fingerprinting
            "privacy.resistFingerprinting" = true;
            "privacy.window.maxInnerWidth" = 1600;
            "privacy.window.maxInnerHeight" = 900;
            "privacy.resistFingerprinting.block_mozAddonManager" = true;
            "browser.startup.blankWindow" = false;
            "browser.display.use_system_colors" = false;
          };
          userChrome = ''
            @media (prefers-color-scheme: dark) {
              :root {
                  --uc-identity-colour-blue: #7ED6DF;
                  --uc-identity-colour-turquoise: #55E6C1;
                  --uc-identity-colour-green: #B8E994;
                  --uc-identity-colour-yellow: #F7D794;
                  --uc-identity-colour-orange: #F19066;
                  --uc-identity-colour-red: #FC5C65;
                  --uc-identity-colour-pink: #F78FB3;
                  --uc-identity-colour-purple: #786FA6;
                  --uc-base-colour: #1E2021;
                  --uc-highlight-colour: #191B1C;
                  --uc-inverted-colour: #FAFAFC;
                  --uc-muted-colour: #AAAAAC;
                  --uc-accent-colour: var(--uc-identity-colour-purple);
              }
          }
          @media (prefers-color-scheme: light) {
              :root {
                  --uc-identity-colour-blue: #1D65F5;
                  --uc-identity-colour-turquoise: #209FB5;
                  --uc-identity-colour-green: #40A02B;
                  --uc-identity-colour-yellow: #E49320;
                  --uc-identity-colour-orange: #FE640B;
                  --uc-identity-colour-red: #FC5C65;
                  --uc-identity-colour-pink: #EC83D0;
                  --uc-identity-colour-purple: #822FEE;
                  --uc-base-colour: #FAFAFC;
                  --uc-highlight-colour: #DADADC;
                  --uc-inverted-colour: #1E2021;
                  --uc-muted-colour: #191B1C;
                  --uc-accent-colour: var(--uc-identity-colour-purple);
              }
          }
          :root {
              --lwt-frame: var(--uc-base-colour) !important;
              --lwt-accent-color: var(--lwt-frame) !important;
              --lwt-text-color: var(--uc-inverted-colour) !important;
              --toolbar-field-color: var(--uc-inverted-colour) !important;
              --toolbar-field-focus-color: var(--uc-inverted-colour) !important;
              --toolbar-field-focus-background-color: var(--uc-highlight-colour) !important;
              --toolbar-field-focus-border-color: transparent !important;
              --toolbar-field-background-color: var(--lwt-frame) !important;
              --lwt-toolbar-field-highlight: var(--uc-inverted-colour) !important;
              --lwt-toolbar-field-highlight-text: var(--uc-highlight-colour) !important;
              --urlbar-popup-url-color: var(--uc-accent-colour) !important;
              --lwt-tab-text: var(--lwt-text-colour) !important;
              --lwt-selected-tab-background-color: var(--uc-highlight-colour) !important;
              --toolbar-bgcolor: var(--lwt-frame) !important;
              --toolbar-color: var(--lwt-text-color) !important;
              --toolbarseparator-color: var(--uc-accent-colour) !important;
              --toolbarbutton-hover-background: var(--uc-highlight-colour) !important;
              --toolbarbutton-active-background: var(--toolbarbutton-hover-background) !important;
              --lwt-sidebar-background-color: var(--lwt-frame) !important;
              --sidebar-background-color: var(--lwt-sidebar-background-color) !important;
              --urlbar-box-bgcolor: var(--uc-highlight-colour) !important;
              --urlbar-box-text-color: var(--uc-muted-colour) !important;
              --urlbar-box-hover-bgcolor: var(--uc-highlight-colour) !important;
              --urlbar-box-hover-text-color: var(--uc-inverted-colour) !important;
              --urlbar-box-focus-bgcolor: var(--uc-highlight-colour) !important;
          }
          .identity-color-blue {
              --identity-tab-color: var(--uc-identity-colour-blue) !important;
              --identity-icon-color: var(--uc-identity-colour-blue) !important;
          }
          .identity-color-turquoise {
              --identity-tab-color: var(--uc-identity-colour-turquoise) !important;
              --identity-icon-color: var(--uc-identity-colour-turquoise) !important;
          }
          .identity-color-green {
              --identity-tab-color: var(--uc-identity-colour-green) !important;
              --identity-icon-color: var(--uc-identity-colour-green) !important;
          }
          .identity-color-yellow {
              --identity-tab-color: var(--uc-identity-colour-yellow) !important;
              --identity-icon-color: var(--uc-identity-colour-yellow) !important;
          }
          .identity-color-orange {
              --identity-tab-color: var(--uc-identity-colour-orange) !important;
              --identity-icon-color: var(--uc-identity-colour-orange) !important;
          }
          .identity-color-red {
              --identity-tab-color: var(--uc-identity-colour-red) !important;
              --identity-icon-color: var(--uc-identity-colour-red) !important;
          }
          .identity-color-pink {
              --identity-tab-color: var(--uc-identity-colour-pink) !important;
              --identity-icon-color: var(--uc-identity-colour-pink) !important;
          }
          .identity-color-purple {
              --identity-tab-color: var(--uc-identity-colour-purple) !important;
              --identity-icon-color: var(--uc-identity-colour-purple) !important;
          }
          :root {
              --uc-border-radius: 0;
              --uc-status-panel-spacing: 12px;
              --uc-page-action-margin: 7px;
          }
          .titlebar-buttonbox-container { display: none !important; }
          #pageActionButton { display: none !important; }
          :root { --uc-toolbar-position: 0; }
          @media (prefers-color-scheme: dark) { :root { --uc-darken-toolbar: 0.2; }}
          @media (prefers-color-scheme: light) { :root { --uc-darken-toolbar: 0; }}
          :root {
              --uc-urlbar-min-width: 35vw;
              --uc-urlbar-max-width: 35vw;
              --uc-urlbar-position: 1;
          }
          #back-button, #forward-button { display: none !important; }
          #identity-permission-box { display: none !important; }
          .urlbar-page-action > image { margin-top: var(--uc-page-action-margin) !important; }
          #userContext-icons { display: none !important; }
          #urlbar-go-button { display: none !important; }
          #unified-extensions-button { display: none !important; }
          #alltabs-button { margin-top: 5px !important; }
          :root {
              --uc-active-tab-width: clamp(100px, 30vw, 300px);
              --uc-inactive-tab-width: clamp(100px, 20vw, 200px);
              --show-tab-close-button: none;
              --show-tab-close-button-hover: -moz-inline-block;
              --container-tabs-indicator-margin: 10px;
              --uc-identity-glow: 0 1px 10px 1px;
          }
          .tab-secondary-label { display: none !important; }
          :root {
              --uc-border-radius: 0;
              --uc-status-panel-spacing: 12px;
          }
          .titlebar-buttonbox-container { display: none !important; }
          #pageActionButton { display: none !important; }
          #PanelUI-menu-button { padding: 0 !important; }
          #PanelUI-menu-button .toolbarbutton-icon { width: 1px !important; }
          #PanelUI-menu-button .toolbarbutton-badge-stack { padding: 0 !important; }
          :root { --uc-toolbar-position: 0; }
          @media (prefers-color-scheme: dark) { :root { --uc-darken-toolbar: 0.2; }}
          @media (prefers-color-scheme: light) { :root { --uc-darken-toolbar: 0; }}
          :root {
              --uc-urlbar-min-width: 35vw;
              --uc-urlbar-max-width: 35vw;
              --uc-urlbar-position: 1;
              --uc-urlbar-top-spacing: 1px;
          }
          #back-button, #forward-button { display: none !important; }
          /* #tracking-protection-icon-container { display: none !important; } */
          #identity-permission-box { display: none !important; }
          /* #identity-box { display: none !important } */
          /* #page-action-buttons > :not(#urlbar-zoom-button) { display: none !important; } */
          #urlbar-go-button { display: none !important; }
          #unified-extensions-button { display: none !important; }
          :root {
              --uc-active-tab-width: clamp(100px, 30vw, 300px);
              --uc-inactive-tab-width: clamp(100px, 20vw, 200px);
              --show-tab-close-button: none;
              --show-tab-close-button-hover: none;
              --uc-show-all-tabs-button: none;
              --container-tabs-indicator-margin: 10px;
              --uc-identity-glow: 0 1px 10px 1px;
          }
          .tab-secondary-label { display: none !important; }
          #statuspanel #statuspanel-label { margin: 0 0 var(--uc-status-panel-spacing) var(--uc-status-panel-spacing) !important; }
          :root {
              --toolbarbutton-border-radius: var(--uc-border-radius) !important;
              --tab-border-radius: var(--uc-border-radius) !important;
              --arrowpanel-border-radius: var(--uc-border-radius) !important;
          }
          #TabsToolbar, #main-window, #nav-bar, #navigator-toolbox, #sidebar-box, #toolbar-menubar { box-shadow: none !important; }
          #PersonalToolbar, #TabsToolbar, #main-window, #nav-bar, #navigator-toolbox, #sidebar-box, #toolbar-menubar { border: none !important; }
          .titlebar-spacer { display: none !important; }
          #urlbar-input-container[pageproxystate="valid"] > #tracking-protection-icon-container > #tracking-protection-icon-box > #tracking-protection-icon { padding-bottom: 1px; }
          #PersonalToolbar {
              padding: 6px !important;
              box-shadow: inset 0 0 50vh rgba(0, 0, 0, var(--uc-darken-toolbar)) !important;
          }
          #statuspanel #statuspanel-label {
              border: none !important;
              border-radius: var(--uc-border-radius) !important;
          }
          #navigator-toolbox:not(:-moz-lwtheme) { background: var(--toolbar-field-background-color) !important; }
          #nav-bar {
              padding-block-start: 0 !important;
              border: none !important;
              box-shadow: none !important;
              background: transparent !important;
          }
          #urlbar, #urlbar * {
              padding-block-start: var(--uc-urlbar-top-spacing) !important;
              outline: none !important;
              box-shadow: none !important;
          }
          #urlbar-background { border: transparent !important; }
          #urlbar[focused='true'] > #urlbar-background,
          #urlbar:not([open]) > #urlbar-background { background: var(--toolbar-field-background-color) !important; }
          #urlbar[open] > #urlbar-background { background: var(--toolbar-field-background-color) !important; }
          .urlbarView-row:hover > .urlbarView-row-inner,
          .urlbarView-row[selected] > .urlbarView-row-inner { background: var(--toolbar-field-focus-background-color) !important; }
          #urlbar-go-button, .urlbar-icon { margin: auto; }
          .urlbar-page-action { padding: 0 inherit !important; }
          .urlbar-page-action .urlbar-icon { margin-top: 6px !important; }
          @media (min-width: 1000px) {
              #nav-bar { margin: calc((var(--urlbar-min-height) * -1) - 12px) calc(100vw - var(--uc-urlbar-min-width)) 0 0 !important; }
              #titlebar { margin-inline-start: var(--uc-urlbar-min-width) !important; }
              #navigator-toolbox:focus-within #nav-bar { margin: calc((var(--urlbar-min-height) * -1) - 12px) calc(100vw - var(--uc-urlbar-max-width)) 0 0 !important; }
              #navigator-toolbox:focus-within #titlebar { margin-inline-start: var(--uc-urlbar-max-width) !important; }
          }
          @media (min-width: 1000px) {
              #navigator-toolbox {
                  display: flex;
                  flex-wrap: wrap;
                  flex-direction: row;
              }
              #nav-bar {
                  order: var(--uc-urlbar-position);
                  width: var(--uc-urlbar-min-width);
              }
              #nav-bar #urlbar-container {
                  min-width: 0 !important;
                  width: auto !important;
              }
              #titlebar {
                  order: 2;
                  width: calc(100vw - var(--uc-urlbar-min-width) - 1px);
              }
              #PersonalToolbar {
                  order: var(--uc-toolbar-position);
                  width: 100%;
              }
              #navigator-toolbox:focus-within #nav-bar { width: var(--uc-urlbar-max-width); }
              #navigator-toolbox:focus-within #titlebar { width: calc(100vw - var(--uc-urlbar-max-width) - 1px); }
          }
          #tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs]) > #tabbrowser-arrowscrollbox > .tabbrowser-tab:nth-child(1 of :not([pinned], [hidden])) { margin-inline-start: 0 !important; }
          #alltabs-button { display: var(--uc-show-all-tabs-button) !important; }
          .tabbrowser-tab > .tab-stack > .tab-background { box-shadow: none !important; }
          #tabbrowser-tabs:not([noshadowfortests]) .tabbrowser-tab:is([multiselected]) > .tab-stack > .tab-background:-moz-lwtheme { outline-color: var(--toolbarseparator-color) !important; }
          .tabbrowser-tab:not([pinned]) .tab-close-button { display: var(--show-tab-close-button) !important; }
          .tabbrowser-tab:not([pinned]):hover .tab-close-button { display: var(--show-tab-close-button-hover) !important; }
          .tabbrowser-tab[selected][fadein]:not([pinned]) { max-width: var(--uc-active-tab-width) !important; }
          .tabbrowser-tab[fadein]:not([selected]):not([pinned]) { max-width: var(--uc-inactive-tab-width) !important; }
          .tabbrowser-tab[usercontextid] > .tab-stack > .tab-background > .tab-context-line {
              margin: -1px var(--container-tabs-indicator-margin) 0 var(--container-tabs-indicator-margin) !important;
              height: 1px !important;
              box-shadow: var(--uc-identity-glow) var(--identity-tab-color) !important;
          }
          .tab-icon-image:not([pinned]) { opacity: 1 !important; }
          .tab-icon-overlay:not([crashed]), .tab-icon-overlay[pinned][crashed][selected] {
              top: 5px !important;
              z-index: 1 !important;
              padding: 1.5px !important;
              inset-inline-end: -8px !important;
              width: 16px !important;
              height: 16px !important;
              border-radius: 10px !important;
          }
          .tab-icon-overlay:not([sharing], [crashed]):is([soundplaying], [muted], [activemedia-blocked]) {
              stroke: transparent !important;
              background: transparent !important;
              opacity: 1 !important;
              fill-opacity: 0.8 !important;
              color: currentColor !important;
              stroke: var(--toolbar-bgcolor) !important;
              background-color: var(--toolbar-bgcolor) !important;
          }
          .tabbrowser-tab[selected] .tab-icon-overlay:not([sharing], [crashed]):is([soundplaying], [muted], [activemedia-blocked]) {
              stroke: var(--toolbar-bgcolor) !important;
              background-color: var(--toolbar-bgcolor) !important;
          }
          .tab-icon-overlay:not([pinned], [sharing], [crashed]):is([soundplaying], [muted], [activemedia-blocked]) { margin-inline-end: 9.5px !important; }
          .tabbrowser-tab:not([image]) .tab-icon-overlay:not([pinned], [sharing], [crashed]) {
              top: 0 !important;
              padding: 0 !important;
              margin-inline-end: 5.5px !important;
              inset-inline-end: 0 !important;
          }
          .tab-icon-overlay:not([crashed])[activemedia-blocked]:hover,
          .tab-icon-overlay:not([crashed])[muted]:hover,
          .tab-icon-overlay:not([crashed])[soundplaying]:hover {
              color: currentColor !important;
              stroke: var(--toolbar-color) !important;
              background-color: var(--toolbar-color) !important;
              fill-opacity: 0.95 !important;
          }
          .tabbrowser-tab[selected] .tab-icon-overlay:not([crashed])[activemedia-blocked]:hover,
          .tabbrowser-tab[selected] .tab-icon-overlay:not([crashed])[muted]:hover,
          .tabbrowser-tab[selected] .tab-icon-overlay:not([crashed])[soundplaying]:hover {
              color: currentColor !important;
              stroke: var(--toolbar-color) !important;
              background-color: var(--toolbar-color) !important;
              fill-opacity: 0.95 !important;
          }
          #TabsToolbar .tab-icon-overlay:not([crashed])[activemedia-blocked],
          #TabsToolbar .tab-icon-overlay:not([crashed])[muted],
          #TabsToolbar .tab-icon-overlay:not([crashed])[soundplaying] {
              color: var(--toolbar-color) !important;
          }
          #TabsToolbar .tab-icon-overlay:not([crashed])[activemedia-blocked]:hover,
          #TabsToolbar .tab-icon-overlay:not([crashed])[muted]:hover,
          #TabsToolbar .tab-icon-overlay:not([crashed])[soundplaying]:hover {
              color: var(--toolbar-bgcolor) !important;
          }
          #TabsToolbar { display: none !important; }
          #nav-bar { width: 100vw !important; }
          #browser { position: relative; }
          #sidebar-box[sidebarcommand*="tabcenter"] #sidebar-header { display: none; }
          #sidebar-box[sidebarcommand*="tabcenter"]:not([hidden]) {
              display: block;
              position: absolute;
              top: 0;
              bottom: 0;
              z-index: 1;
              min-width: 50px !important;
              max-width: 50px !important;
              border-right: none;
              transition: all 0.2s ease;
              overflow: hidden;
          }
          [sidebarcommand*="tabcenter"] #sidebar,
          #sidebar-box[sidebarcommand*="tabcenter"]:hover {
              min-width: 10vw !important;
              width: 30vw !important;
              max-width: 250px !important;
          }
          [sidebarcommand*="tabcenter"] #sidebar {
              height: 100%;
              max-height: 100%;
          }
          #sidebar-box[sidebarcommand*="tabcenter"]:not([hidden]) ~ #appcontent { margin-left: 50px; }
          #main-window[inFullscreen][inDOMFullscreen] #appcontent { margin-left: 0; }
          #sidebar-box[sidebarcommand="tabcenter-reborn_ariasuni-sidebar-action"] #sidebar-header,
          #sidebar-box[sidebarcommand="tabcenter-reborn_ariasuni-sidebar-action"] ~ #sidebar-splitter { display: none; }
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
          # height = 8;
          # margin-top = 0;
          # margin-bottom = 0;
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
            format = "  {usage}%";
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
            padding: 0px 0px 0px 0px;
          }
        	window#waybar {
        	  background: rgba(43, 48, 59, 0.5);
          }
        	#workspaces {
        	  border-radius: 10px;
        	  background-color: #${theme.color.base};
        	  color: #${theme.color.subtext1};
            font-size: 7px;
            margin: 5px 0px 5px 8px;
            padding: 0px 10px 0px 10px;
        	}
        	#workspaces button {
        	  background-color: #${theme.color.base};
        	  color: #${theme.color.rosewater};
        	  /* border-bottom: 5px solid #${theme.color.base}; */
        	  padding: 0;
        	  margin-top: 0;
        	}
          #workspaces:hover {
            color: #${theme.color.text};
            background-color: #${theme.color.base};
          }
        	#workspaces button.active {
        	  color: #${theme.color.green};
        	}
        	#clock, #battery, #network, #pulseaudio, #cpu, #custom-power {
        	  border-radius: 10px;
        	  background-color: #${theme.color.base};
        	  color: #${theme.color.rosewater};
            margin: 5px 8px 5px 0px;
            padding: 0px 10px 0px 10px;
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
            margin-right: 0px;
            border-radius: 10px 0px 0px 10px;
          }
          #cpu {
            color: #${theme.color.yellow};
            border-radius: 0px 10px 10px 0px;
          }
          #custom-power {
            color: #${theme.color.surface0};
            background-color: #${theme.color.red};
            font-weight: 500;
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
        env = XDG_CURRENT_DESKTOP,Hyprland
        env = XDG_SESSION_TYPE,wayland
        env = XDG_SESSION_DESKTOP,Hyprland

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
      	bind = $mainMod, Q, killactive
      	bind = $mainMod, M, exit
      	bind = $mainMod, V, togglefloating
      	bind = $mainMod, P, pseudo, # dwindle
      	bind = $mainMod, H, togglesplit, # dwindle
        bind = $mainMod, S, togglespecialworkspace
        bind = $mainMod, F, fullscreen, 0
        bind = $mainMod SHIFT, S, movetoworkspace, special
        bind = $mainMod SHIFT, W, exec, find $HOME/media/images/wallpapers -type f | shuf -n 1 | xargs wbg

        bind = $mainMod, SPACE, exec, rofi -show drun
        bind = $mainMod, C, exec, rofi -show calc -modi calc -no-show-match -no-sort -no-persist-history -hint-welcome "" -calc-command "wtype {result}"> /dev/null
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
