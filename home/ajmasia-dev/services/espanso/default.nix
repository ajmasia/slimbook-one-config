{...}: {
  services.espanso = {
    # TODO: review current config
    enable = false;
    matches = [
      {
        trigger = ":gm";
        replace = "antoniojosemasia@gmail.com";
      }
      {
        trigger = ":im";
        replace = "antoniojosemasia@icloud.com";
      }
      {
        trigger = ":dm";
        replace = "ajmasia.dev@icloud.com";
      }
    ];
  };
}
