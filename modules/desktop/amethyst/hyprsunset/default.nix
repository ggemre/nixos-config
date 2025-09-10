{self, ...}: {
  imports = [
    self.nixosModules.services.hyprsunset
  ];

  services.hyprsunset = {
    enable = true;

    settings = {
      profile = [
        {
          time = "6:30";
          identity = true;
        }
        {
          time = "0:00";
          temperature = 4000;
          gamma = 0.8;
        }
      ];
    };
  };
}
