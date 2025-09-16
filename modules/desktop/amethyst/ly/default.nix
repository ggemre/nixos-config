{pkgs, ...}: {
  services.displayManager.ly = {
    enable = true;
    settings = {
      save = true;
      waylandsessions = "${pkgs.hyprland}/share/wayland-sessions";
      animation = "matrix";
      session_log = "/tmp/ly-session.log";
    };
  };
}
