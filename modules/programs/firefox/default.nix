{
  config,
  pkgs,
  ...
}: {
  config = {
    programs.firefox = {
      enable = true;
      preferencesStatus = "locked";
      preferences = {
        # General settings
        "general.smoothScroll" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.download.folderList" = 2;
        "browser.download.useDownloadDir" = true;
        "browser.in-content.dark-mode" = true;
        "browser.theme.content-theme" =
          if config.theme.variant == "dark"
          then 0
          else 1;
        "browser.theme.toolbar-theme" =
          if config.theme.variant == "dark"
          then 0
          else 1;
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
        "app.update.background.scheduling.enabled" = true;
        "app.update.auto" = true;
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
        # TLS-related settings
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_send_http_background_request" = false;
        # UI features
        "extensions.pocket.enabled" = false;
        # Firefox amnesia
        "browser.history_expire_days" = 30;
        "browser.history_expire_days_min" = 30;
        "browser.history_expire_sites" = 30;
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
        # Disable AI
        "browser.ml.enable" = false;
        "browser.ml.chat.enabled" = false;
      };
      policies = {
        DisableAccounts = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never";
        DefaultDownloadDirectory = "$HOME/tmp"; # TODO: link to upcoming xdg module
        DownloadDirectory = "$HOME/tmp";
        PromptForDownloadLocation = true;

        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableFeedbackCommands = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxStudies = true;
        DisableFormHistory = true;
        DisablePocket = true;
        DisableSetDesktopBackground = true;
        DisableTelemetry = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
        SearchSuggestEnable = false;
        UserMessaging = {
          WhatsNew = false;
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          UrlbarInterventions = false;
          SkipOnboarding = true;
          MoreFromMozilla = false;
          FirefoxLabs = false;
          Locked = true;
        };
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };

        ExtensionSettings = {
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };

    # TODO: an XDG common module
    # .config/user-dirs.dirs:
    # XDG_DOWNLOAD_DIR="$HOME/tmp"

    homeless = {
      ".mozilla/firefox/profiles.ini".text = ''
        [Profile0]
        Name=main
        IsRelative=1
        Path=main
        Default=1

        [General]
        StartWithLastProfile=1
        Version=2
      '';

      ".mozilla/firefox/main/search.json.mozlz4".source =
        pkgs.runCommand "search.json.mozlz4"
        {
          nativeBuildInputs = [
            pkgs.mozlz4a
          ];
          json = builtins.readFile ./search.json;
        }
        ''
          mozlz4a <(echo "$json") "$out"
        '';

      ".mozilla/firefox/main/chrome/userChrome.css".text = ''
        .titlebar-buttonbox-container { display: none !important; }
        .titlebar-spacer { display:none !important; }
      '';
    };
  };
}
