{
  default = final: prev: {
    custom = import ./custom final prev;
    patched = import ./patched final prev;
  };
}
