_: {
  # Prevent shutdown on short power key press.
  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
  };
}
