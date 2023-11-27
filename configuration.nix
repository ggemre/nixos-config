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
            ublock-origin
          ];
          settings = {
            "general.smoothScroll" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.download.folderList" = 2;
            "browser.download.dir" = "/home/dme/tmp";
            "browser.download.lastDir" = "/home/dme/tmp";
            "browser.download.useDownloadDir" = true;
            # Startup settings
            "browser.aboutConfig.showWarning" = false;
            "browser.startup.page" = 0;
            "browser.startup.homepage" = "about:blank";
            "browser.newtabpage.enabled" = false;
            "browser.newtab.url" = "about:blank";
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
            # Performance optimization
            "content.notify.interval" = 100000;
            "browser.cache.jsbc_compression_level" = 3;
            "media.memory_cache_max_size" = 65536;
            "media.cache_readahead_limit" = 7200;
            "media.cache_resume_threshold" = 3600;
            "image.mem.decode_bytes_at_a_time" = 32768;
            "network.buffer.cache.size" = 262144;
            "network.buffer.cache.count" = 128;
            "network.http.max-connections" = 1800;
            "network.http.max-persistent-connections-per-server" = 10;
            "network.http.max-urgent-start-excessive-connections-per-host" = 5;
            "network.predictor.enabled" = false;
          };
          userChrome = ''
            .tab-line{ background-color: transparent !important; }
            toolbarseparator {
              appearance: auto;
              -moz-default-appearance: separator;
              margin: 3px 4px;
              display: none !important;
            }
            #alltabs-button { display: none !important; }
            #identity-popup-permissions-content > description, #protections-popup-content > description { color: #${theme.color.red} !important; }
            #identity-box[pageproxystate="valid"].notSecureText > .identity-box-button, #identity-box[pageproxystate="valid"].chromeUI > .identity-box-button, #identity-box[pageproxystate="valid"].extensionPage > .identity-box-button, #urlbar-label-box {
                background-color: transparent !important;
            }
            #identity-box[pageproxystate="valid"].notSecureText > .identity-box-button:hover:not([open]), #identity-box[pageproxystate="valid"].chromeUI > .identity-box-button:hover:not([open]), #identity-box[pageproxystate="valid"].extensionPage > .identity-box-button:hover:not([open]) {
                background-color: transparent !important;
            }
            #identity-box[pageproxystate="valid"].notSecureText > .identity-box-button:hover:active, #identity-box[pageproxystate="valid"].notSecureText > .identity-box-button[open="true"], #identity-box[pageproxystate="valid"].chromeUI > .identity-box-button:hover:active, #identity-box[pageproxystate="valid"].chromeUI > .identity-box-button[open="true"], #identity-box[pageproxystate="valid"].extensionPage > .identity-box-button:hover:active, #identity-box[pageproxystate="valid"].extensionPage > .identity-box-button[open="true"] {
                background-color: transparent !important;
            }
            #urlbar[open] > .urlbarView > .urlbarView-body-outer > .urlbarView-body-inner { border-top: none !important; }
            .urlbarView-results { padding-block: 0px !important; }
            .urlbarView:not([noresults]) > .search-one-offs:not([hidden]) { border-top: none !important; }
            #urlbar .search-one-offs:not([hidden]) { padding-block: 0px !important; }
            #urlbar-zoom-button {
              border: 1px solid #${theme.color.red} !important;
              padding: 0px 7px !important;
            }
            #PersonalToolbar {
              visibility: collapse !important;
              margin-bottom: -20px !important;
              transition: all .4s ease .5s !important;
            }
            #navigator-toolbox:hover > #PersonalToolbar {
              visibility: visible !important;
              margin-bottom: 0px !important;
              transition: all .4s ease .5s !important;
            }
            #urlbar[breakout], #urlbar[breakout][breakout-extend] {
              --urlbar-height: 28px !important;
              --urlbar-toolbar-height: 30px !important;
              width: 100% !important;
              top: calc((var(--urlbar-toolbar-height) - var(--urlbar-height)) / 2) !important;
              left: 0 !important;
            }
            #urlbar[focused="true"]:not([suppress-focus-border]) > #urlbar-background, #searchbar:focus-within {
              outline-color: #${theme.color.red} !important;
              border-color: transparent;
            }
            #urlbar[breakout][breakout-extend] > #urlbar-input-container, #urlbar-input-container {
              height: var(--urlbar-height) !important;
              width: 100% !important;
              padding-block: unset !important;
              padding-inline: unset !important;
              transition: none !important;
            }
            #confirmation-hint { display: none !important; }
            .urlbarView-url {
              overflow: hidden;
              color: #${theme.color.maroon} !important;
            }
            .text-link { color: #${theme.color.red} !important; }
            .urlbarView-title:not(:empty) ~ .urlbarView-action { color: #${theme.color.maroon} !important; }
            .urlbarView-row:not([type="tip"], [type="dynamic"], [has-help]):hover > .urlbarView-row-inner, .urlbarView-row[has-help] > .urlbarView-row-inner:not([selected]):hover {
                background-color: transparent !important;
            }
            .urlbarView-row:not([type="tip"], [type="dynamic"], [has-help]):hover > .urlbarView-row-inner, .urlbarView-row[has-help] > .urlbarView-row-inner:not([selected]) {
                background-color: transparent !important;
            }
            .urlbarView-row:not([type="tip"], [type="dynamic"])[selected] > .urlbarView-row-inner, .urlbarView-row-inner[selected] {
                background-color: transparent !important;
                color: #${theme.color.red} !important;
            }
            .searchbar-engine-one-off-item:not([selected]):hover {
                background-color: transparent !important;
                color: inherit;
            }
            :root:not(:-moz-lwtheme) #urlbar:not([focused="true"]) { --urlbar-box-bgcolor: #${theme.color.surface1} !important; }
            #urlbar:is([focused="true"], [open]) > #urlbar-background, #searchbar:focus-within { background-color: #${theme.color.surface1} !important; }
            ::selection {
            	background: #${theme.color.red} !important;
            	color: #${theme.color.base} !important;
            }
            #PlacesToolbarItems{ -moz-box-pack: center }
            #tabbrowser-tabs { background-color: #none !important; }
            #tabbrowser-arrowscrollbox::part(scrollbutton-up), #tabbrowser-arrowscrollbox::part(scrollbutton-down) { fill: #${theme.color.red} !important; }
            #star-button { fill: #${theme.color.red} !important; }
            #star-button[starred][animate] + #star-button-animatable-box > #star-button-animatable-image {
              stroke: #${theme.color.red} !important;
              fill: #${theme.color.red} !important;
              color: #${theme.color.red} !important;
            }
            /* .tab-close-button { display: none !important; } */
            .titlebar-buttonbox-container { display: none !important; }
            #firefox-view-button { display: none !important; }
            #unified-extensions-button { display: none !important; }
            #ublock0_raymondhill_net-browser-action .toolbarbutton-badge-stack { 
              filter: grayscale(100%) invert(71%) sepia(9%) saturate(2979%) hue-rotate(300deg) brightness(98%) contrast(94%) !important;
            }
            .toolbarbutton-badge { display: none !important; }
            .tabbrowser-tab .tab-loading-burst { display: none !important; }
            .tab-content[selected="true"] {
              border-radius: 9px !important;
              border: solid #${theme.color.crust} !important;
            	background-color: #${theme.color.surface1} !important;
            	font-weight: bold !important;
            	color: #${theme.color.red} !important;
            }
            #tabbrowser-tabs { --tab-loading-fill: #${theme.color.red} !important; }
            .titlebar-buttonbox {
              margin-left: 12px !important;
              margin-right: 12px !important;
            }
            toolbar#TabsToolbar {
            	-moz-appearance: none !important;
            	background-color: #${theme.color.crust} !important;
            }
            #TabsToolbar .toolbarbutton-1 {
                margin: 0 0 var(--tabs-navbar-shadow-size) !important;
                padding: 2px !important;
            }
            #TabsToolbar .toolbarbutton-1:hover {
                margin: 0 0 var(--tabs-navbar-shadow-size) !important;
                padding: 2px !important;
                background-color: #${theme.color.crust} !important;
            }
            .titlebar-spacer[type="pre-tabs"], .titlebar-spacer[type="post-tabs"] {
            	display: none !important;
            	width: 0px !important;
            	max-width: 0px !important;
            }
            #urlbar {
            	box-shadow: none !important;
            	background-color: #${theme.color.red} !important;
            	background: #${theme.color.surface1} !important;
            	border: none !important;
            	color : #${theme.color.red} !important;
            	font-weight: bold !important;
            }
            #nav-bar {
            	box-shadow: none !important;
            	border-top: none !important;
            }
            .tabbrowser-tab[label^="New Tab"] .tab-icon-image {
            	list-style-image: none !important;
            	width: 0 !important;
            	padding-left: 16px !important;
            	background-size: 16px 16px !important;
            	background-repeat: no-repeat !important;
            }
            .tabbrowser-tab[label^="Private Browsing"] .tab-icon-image {
            	list-style-image: none !important;
            	width: 0 !important;
            	padding-left: 16px !important;
            	background-size: 16px 16px !important;
            	background-repeat: no-repeat !important;
            }
            #PersonalToolbar {
              background-color: #${theme.color.surface1} !important;
              color: #${theme.color.red} !important;
            }
            #PersonalToolbar .toolbarbutton-1:not([disabled="true"], [checked], [open], :active):hover, #tabbrowser-arrowscrollbox:not([scrolledtostart="true"])::part(scrollbutton-up):hover, #tabbrowser-arrowscrollbox:not([scrolledtoend="true"])::part(scrollbutton-down):hover, toolbarbutton.bookmark-item:not(.subviewbutton, [disabled="true"], [open]):hover, toolbar .toolbarbutton-1:not([disabled="true"], [checked], [open], :active):hover > .toolbarbutton-icon, toolbar .toolbarbutton-1:not([disabled="true"], [checked], [open], :active):hover > .toolbarbutton-text, toolbar .toolbarbutton-1:not([disabled="true"], [checked], [open], :active):hover > .toolbarbutton-badge-stack {
              background-color: #${theme.color.green};
              color: inherit;
            }
            #PersonalToolbar .toolbarbutton-1:not([disabled="true"], [checked], [open], :active):hover, #tabbrowser-arrowscrollbox:not([scrolledtostart="true"])::part(scrollbutton-up):hover, #tabbrowser-arrowscrollbox:not([scrolledtoend="true"])::part(scrollbutton-down):hover, toolbarbutton.bookmark-item:not(.subviewbutton, [disabled="true"], [open]):hover, toolbar .toolbarbutton-1:not([disabled="true"], [checked], [open], :active):hover > .toolbarbutton-icon, toolbar .toolbarbutton-1:not([disabled="true"], [checked], [open], :active):hover > .toolbarbutton-text, toolbar .toolbarbutton-1:not([disabled="true"], [checked], [open], :active):hover > .toolbarbutton-badge-stack {
              background-color: #${theme.color.surface1} !important;
              color: #${theme.color.red} !important;
            }
            #PersonalToolbar .toolbarbutton-1:not([disabled="true"]):is([open], [checked], :hover:active), #tabbrowser-arrowscrollbox:not([scrolledtostart="true"])::part(scrollbutton-up):hover:active, #tabbrowser-arrowscrollbox:not([scrolledtoend="true"])::part(scrollbutton-down):hover:active, toolbarbutton.bookmark-item:hover:active:not(.subviewbutton, [disabled="true"]), toolbarbutton.bookmark-item[open="true"], toolbar .toolbarbutton-1:not([disabled="true"]):is([open], [checked], :hover:active) > .toolbarbutton-icon, toolbar .toolbarbutton-1:not([disabled="true"]):is([open], [checked], :hover:active) > .toolbarbutton-text, toolbar .toolbarbutton-1:not([disabled="true"]):is([open], [checked], :hover:active) > .toolbarbutton-badge-stack {
              background-color: #${theme.color.surface1} !important;
              color: #${theme.color.red} !important;
            }
            .urlbarView-row[type=bookmark] > .urlbarView-row-inner > .urlbarView-no-wrap > .urlbarView-type-icon { fill: #${theme.color.red} !important; }
            #browser vbox#appcontent tabbrowser, #content, #tabbrowser-tabpanels, browser[type=content-primary], browser[type=content] > html{ background: #${theme.color.surface1} !important; }
            #PanelUI-button {
            	border:none !important;
            	margin-inline-start: 0px !important;
            	padding-inline-start: 0px !important;
            }
            .urlbar-icon, .urlbar-icon-wrapper, #tabbrowser-tabs toolbarbutton, toolbar toolbarbutton > .toolbarbutton-icon, toolbar toolbarbutton > .toolbarbutton-badge-stack,
            .titlebar-button, #identity-box, #tracking-protection-icon-container, .findbar-textbox~toolbarbutton, toolbarbutton.scrollbutton-up,
            toolbarbutton.scrollbutton-down { background-color: transparent !important; }
            #navigator-toolbox { border: none !important; }
            #urlbar-background { background-color: #${theme.color.surface1} !important; border-color:#${theme.color.red} !important; }
            #urlbar-input-container { color: #${theme.color.red} !important; }
            #urlbar { background-color: #${theme.color.surface1} !important; }
            .toolbarbutton-animatable-box, .toolbarbutton-1 { fill: #${theme.color.red} !important; }
            .tab-background { display: none !important; }
            .tabbrowser-tab::before, .tabbrowser-tab::after{ display: none !important; }
            :root:not([lwtheme-mozlightdark]) #TabsToolbar:not([brighttext]) #tabbrowser-tabs:not([noshadowfortests]) .tabbrowser-tab:is([visuallyselected="true"], [multiselected]) > .tab-stack > .tab-background:-moz-lwtheme {
              display: none;
            }
            #TabsToolbar:not([brighttext]) #tabbrowser-tabs:not([noshadowfortests]) .tabbrowser-tab:is([visuallyselected="true"], [multiselected]) > .tab-stack > .tab-background {
              display: none;
            }
            .tabbrowser-tab { padding-inline: 0 !important; }
            .tabbrowser-tab {
            	--tab-line-color: #${theme.color.red} !important; 
            	color: #${theme.color.red} !important;
            }
            #tabbrowser-tabs { background-color: #${theme.color.crust} !important; }
            .toolbarbutton-1 {
            	fill: #${theme.color.red} !important;
            	background-color: #${theme.color.surface1} !important;
            }
            #downloads-button[attention="success"]>.toolbarbutton-badge-stack>#downloads-indicator-anchor>#downloads-indicator-icon,
            #downloads-button[attention="success"]>.toolbarbutton-badge-stack>#downloads-indicator-anchor>#downloads-indicator-progress-outer {
            	fill: #${theme.color.red} !important;
            }
            #downloads-button[notification="start"]>.toolbarbutton-badge-stack>#downloads-indicator-anchor>#downloads-indicator-icon,
            #downloads-notification-anchor[notification="start"]>#downloads-indicator-notification {
            	fill: #${theme.color.red} !important;
            }
            #downloads-button[progress]>.toolbarbutton-badge-stack>#downloads-indicator-anchor>#downloads-indicator-icon,
            #downloads-button[progress]>#downloads-indicator-anchor>#downloads-indicator-progress-outer {
            	fill: #${theme.color.red} !important;
            }
            #downloads-button>.toolbarbutton-badge-stack>#downloads-indicator-anchor>#downloads-indicator-progress-outer>#downloads-indicator-progress-inner {
            	fill: red !important;
            	border: 1px !important;
            	border-color: #${theme.color.red} !important;
            }
            .panel-footer > xul|button {
              border-top: 1px solid none !important;
              color: #${theme.color.red} !important;
            }
            .panel-footer {
              background-color: #${theme.color.surface1} !important;
              font-weight: bold !important;
              color: #${theme.color.red} !important;
            }
            :root {
              --arrowpanel-background: #${theme.color.surface1} !important;
              --arrowpanel-color: #${theme.color.red} !important;
              --arrowpanel-dimmed: none !important;
              --arrowpanel-field-background: #${theme.color.surface1} !important;
              --panel-separator-color: #${theme.color.red} !important;
              --toolbarbutton-icon-fill-attention: var(--lwt-toolbarbutton-icon-fill-attention, #${theme.color.red}) !important; 
            }
            tab {
            	height:3rem;
            	background-color: #${theme.color.crust} !important;
            	font-weight: thin !important;
            	color: #${theme.color.red} !important;
            }
            #nav-bar-customization-target { background-color: #${theme.color.red} !important; }
            #protections-popup[mainviewshowing][side=top]::part(arrow) { fill: #${theme.color.surface1} !important; }
            #protections-popup-mainView-panel-header-section {
              color: #${theme.color.red} !important;
              background: radial-gradient(circle farthest-side at top right, #${theme.color.overlay0}, #${theme.color.surface1}) !important;
            }
            #protections-popup-message {
              color: #${theme.color.red} !important;
            }
            .protections-popup-tp-switch::before { background: #${theme.color.surface1} !important; }
            .protections-popup-tp-switch {
              background-color: #${theme.color.red} !important;
              border: 1px solid #${theme.color.surface1} !important;
            }
            .protections-popup-tp-switch::before {
              background: #${theme.color.surface1} !important;
              outline: 1px solid #${theme.color.red} !important;
            }
            .protections-popup-tp-switch[enabled]:hover { background-color: #${theme.color.red} !important; }
            .protections-popup-tp-switch[enabled]:hover:active { background-color: #${theme.color.red} !important; }
            .protections-popup-tp-switch:not([enabled]):hover { background-color: #${theme.color.red} !important; }
            .protections-popup-tp-switch:not([enabled]):hover:active { background-color: #${theme.color.red} !important; }
            #protections-popup[hasException] #protections-popup-tp-switch-section {
              background: repeating-linear-gradient(-56deg, #${theme.color.overlay0}, #${theme.color.overlay0} 10px, transparent 10px, transparent 20px) !important;
            }
            :root[lwt-popup-brighttext] #protections-popup[hasException] #protections-popup-tp-switch-section {
              background: repeating-linear-gradient(-56deg, #${theme.color.overlay0}, #${theme.color.overlay0} 10px, transparent 10px, transparent 20px) !important;
            }
            #protections-popup-no-trackers-found-description { color: #${theme.color.red}!important; }
            #protections-popup-trackers-blocked-counter-description { color: #${theme.color.red} !important; }
            #protections-popup-footer-protection-type-label { color: #${theme.color.red} !important; }
            #nav-bar-customization-target { background-color: #${theme.color.surface1} !important; }
            .PanelUI-subView, .panel-subview-body {
            	--newtab-search-icon-color: #${theme.color.red};
            	--arrowpanel-background: none !important;
            	--arrowpanel-color: #${theme.color.red} !important;
            	--lwt-accent-color: #${theme.color.red} !important;
            	--lwt-text-color: #${theme.color.red} !important;
            	color: #${theme.color.red} !important;
            	background-color: #${theme.color.surface1} !important;
            	border: 1px solid #${theme.color.red} !important;
            }
            .PanelUI-remotetabs-clientcontainer > label[itemtype="client"] { color: #${theme.color.red} !important; }
            #fxa-menu-header-description { color: #${theme.color.red} !important; }
            #fxa-menu-header-title {
              color: #${theme.color.red} !important;
              font-weight: bold !important;
            }
            .PanelUI-remotetabs-clientcontainer > label[itemtype="client"] { font-weight: bold !important; }
            .subview-subheader {
              color: #${theme.color.red} !important;
              font-weight: bold !important;
            }
            #PanelUI-fxa-menu-syncnow-button[syncstatus="active"] > .toolbarbutton-icon, #PanelUI-remotetabs-syncnow[syncstatus="active"] > .toolbarbutton-icon { fill: #${theme.color.red} !important; }
            .subviewbutton[disabled="true"] { color: #${theme.color.red} !important; }
            #appMenu-zoomReset-button {
              min-height: unset;
              border: none !important;
              border-radius: 10000px;
              padding: 1px 8px;
              background-color: #${theme.color.maroon} !important;
            }
            #personal-bookmarks .bookmark-item > .toolbarbutton-text {
            	text-color: #${theme.color.red} !important;
            	color: #${theme.color.red} !important;
            	background-color: none !important
            }
            .panel-footer > xul|button:not([disabled])[default] {
              color: #${theme.color.surface1} !important;
              background-color: #${theme.color.red} !important;
            }
            .panel-footer > xul|button:not([disabled])[default]:hover { background-color: #${theme.color.red} !important; }
            .panel-footer > xul|button:not([disabled])[default]:hover:active { background-color: #${theme.color.red} !important; }
            #editBookmarkPanelRows > vbox > html|input, #editBookmarkPanelRows > vbox > hbox > html|input {
              background-color: #${theme.color.surface1} !important;
              border: 1px solid #${theme.color.red} !important;
            }
            .private-browsing-indicator { display: none !important; }
          '';
          userContent = ''
            body {
              --main-color: #${theme.color.surface1};
              --main-accent-color: #${theme.color.red};
              --glow-color: #${theme.color.flamingo};
              --newtab-textbox-background-color: var(--main-accent-color);
            }
            @-moz-document url(about:privatebrowsing) {
              #private-browsing-vpn-text { display: none !important; }
              #private-browsing-vpn-link { display: none !important; }
              html.private div.showPrivate div.search-inner-wrapper, html.private div.showPrivate div.info { display: none !important; }
              .info { display: none !important; }
              .wordmark { fill: var(--main-accent-color) !important; }
              .logo-and-wordmark {
                align-items: center !important;
                display: flex !important;
                justify-content: center !important;
                margin-bottom: 49px !important;
              }
              html.private { --in-content-page-background: #261010 !important;}
            }
            @-moz-document url(about:newtab), url(about:home), url(about:blank) { 
              .personalize-button { display: none; }
              .icon { color: var(--main-accent-color) !important; }    
              .search-wrapper .search-handoff-button, .search-wrapper input {
                background: #${theme.color.surface1} !important;
                background-size: 24px;
                padding-inline-start: 52px;
                padding-inline-end: 10px;
                padding-block: 0;
                width: 100%;
                box-shadow: none !important;
                border: 1px solid #${theme.color.red} !important;
                border-radius: 30px !important;
              }
              .search-wrapper .search-handoff-button {
                color: #${theme.color.red} !important;
              }
              .search-handoff-button .fake-textbox {
                opacity: 1 !important;
                text-align: center !important;
             .search-wrapper .search-inner-wrapper:active input, .search-wrapper input:focus {
                border: 3px solid var(--main-accent-color) !important;
                box-shadow: 0 0 7px var(--glow-color) !important;
              }
              #newtab-search-text {
                background-color: var(--main-color) !important;
                color: var(--main-accent-color) !important;
              }
              .prefs-button button { fill: var(--main-accent-color) !important; }
              .prefs-button button:hover, .prefs-button button:focus {
                background-color:  transparent !important; 
              }
              .contentSearchSuggestionTable {display: none !important;}
              body{ background-color: var(--main-color) !important }
              .search-wrapper .logo-and-wordmark {
                align-items: center;
                display: flex;
                justify-content: center;
                margin-bottom: 49px; 
              }
              .search-wrapper .search-button:focus, .search-wrapper .search-button:hover {
                background-color: transparent !important;
                cursor: pointer !important; 
              }
              .search-wrapper .search-button:active { background-color: transparent !important; }
              .wordmark { fill: var(--main-accent-color) !important; }
            }
            #newtab-search-text, #searchSubmit{
              fill: var(--main-accent-color) !important;
              border-radius: 48px !important;
              border-color: var(--main-accent-color) !important;
              box-shadow: none !important;
              background-color: none !important;
              color: none !important;
              font-family: helvetica !important
            }
            .search-wrapper .search-inner-wrapper:active input, .search-wrapper input:focus {
              border: 3px solid var(--main-accent-color) !important;
              box-shadow: 0 0 7px var(--glow-color) !important;
            }
            #newtab-search-text{
              background-color: var(--main-color) !important;
              color: var(--main-accent-color) !important;
            }
            .contentSearchSuggestionTable {display: none !important;}
            .search-wrapper .logo-and-wordmark {
            align-items: center;
            display: flex;
            justify-content: center;
            margin-bottom: 49px; }
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
            border-radius: 10px 0px 0px 10px;
            margin-right: 0;
            padding-right: 12px;
          }
          #cpu {
            color: #${theme.color.yellow};
            border-radius: 0px 10px 10px 0px;
            padding-left: 0;
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

        misc {
          disable_hyprland_logo = true
        }

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
