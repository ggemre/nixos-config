_: {
  programs.helium = {
    enable = true;

    preferences = {
      browser = {
        show_home_button = false;
        custom_chrome_frame = false; # Use system titlebar and borders
      };

      helium = {
        completed_onboarding = true;
        services = {
          schema_version = 1;
          user_consented = true;
        };
      };
    };
  };
}
