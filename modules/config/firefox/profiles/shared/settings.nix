{config}: {
  # General settings
  "general.smoothScroll" = true;
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  "browser.download.folderList" = 2;
  "browser.download.useDownloadDir" = true;
  "browser.in-content.dark-mode" = true;
  "browser.tabs.inTitlebar" = 0;
  "browser.toolbars.bookmarks.visibility" = "never";
  "widget.use-xdg-desktop-portal.file-picker" = 1;
  "widget.use-xdg-desktop-portal.mime-handler" = 1;
  "extensions.autoDisableScopes" = 0;
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
  "browser.newtabpage.activity-stream.showWeather" = false;
  # Language settings
  "intl.accept_languages" = "en-US, en";
  "javascript.use_us_english_locale" = true;
  # Disable auto-updates and recommendations
  "app.update.background.scheduling.enabled" = true;
  "app.update.auto" = true;
  "extensions.getAddons.showPane" = false;
  "extensions.htmlaboutaddons.recommendations.enabled" = false;
  "browser.discovery.enabled" = false;
  # Search settings
  "browser.search.suggest.enabled" = false;
  "browser.urlbar.suggest.searches" = false;
  "browser.urlbar.trimURLs" = false;
  "browser.urlbar.speculativeConnect.enabled" = false;
  "browser.formfill.enable" = false;
  "extensions.formautofill.addresses.enabled" = false;
  "extensions.formautofill.available" = "off";
  "extensions.formautofill.creditCards.available" = false;
  "extensions.formautofill.creditCards.enabled" = false;
  "extensions.formautofill.heuristics.enabled" = false;
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
  # Disable AI
  "browser.ai.control.default" = "blocked";
  "browser.ai.control.linkPreviewKeyPoints" = "blocked";
  "browser.ai.control.pdfjsAltText" = "blocked";
  "browser.ai.control.sidebarChatbot" = "blocked";
  "browser.ai.control.smartTabGroups" = "blocked";
  "browser.ai.control.translations" = "blocked";
  "browser.ml.enable" = false;
  "browser.ml.chat.enabled" = false;
  "browser.ml.chat.page" = false;
  "browser.ml.linkPreview.enabled" = false;
  "browser.tabs.groups.smart.enabled" = false;
  "browser.tabs.groups.smart.userEnabled" = false;
  "browser.translations.enable" = false;
  "extensions.ml.enabled" = false;
  "pdfjs.enableAltText" = false;
}
