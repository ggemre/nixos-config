{
  config,
  selfLib,
  ...
}: {
  programs.kwm.settings = {
    border = {
      width = 2;
      color = {
        focus = selfLib.colors.u32 config.theme.colors.base0D "FF";
        unfocus = selfLib.colors.u32 config.theme.colors.base03 "FF";
      };
    };
  };
}
