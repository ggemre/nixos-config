{pkgs, ...}: {
  services.displayManager.ly = {
    enable = true;
    settings = {
      save = true;
      waylandsessions = "${pkgs.niri}/share/wayland-sessions";
      animation = "none";
      session_log = "/tmp/ly-session.log";
    };
  };
}
