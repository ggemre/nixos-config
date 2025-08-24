final: prev: {
  alejandra = prev.alejandra.overrideAttrs (old: {
    patches = (old.patches or []) ++ [ ./alejandra/spaced-elements.patch ];
  });
}
