{
  config,
  lib,
  ...
}: {
  programs.kwm.settings = {
    bindings = {
      key = [
        {
          keysym = "t";
          modifiers = {
            mod4 = true;
          };
          event.click.pressed = {
            spawn.argv = [ (lib.getExe config.programs.foot.package) ];
          };
        }
        {
          keysym = "m";
          modifiers = {
            mod4 = true;
            shift = true;
          };
          event.click.pressed = {
            quit.exit_session = true;
          };
        }
      ];
    };
  };
}
