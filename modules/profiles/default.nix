{
  gaming = import ./gaming;
  graphical = import ./graphical;
  headless = import ./headless;
  laptop = import ./laptop;
  hardware = {
    apple-macbook-air-7 = import ./hardware/apple-macbook-air-7;
    raspberry-pi-4 = import ./hardware/raspberry-pi-4;
  };
}
