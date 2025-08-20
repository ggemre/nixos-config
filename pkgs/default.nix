final: prev: {
  custom = {
    hello = prev.callPackage ./hello {};
  };
}
