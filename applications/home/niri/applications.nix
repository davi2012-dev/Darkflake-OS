{
  pkgs,
}:

{
  #  browser = "${pkgs.firefox}/bin/firefox";
  browser = "librewolf";
  terminal = "ghostty";
  fileManager = "dolphin";
  appLauncher = "${pkgs.walker}/bin/walker";

  screenshotArea = "${pkgs.bash}/bin/bash -c '${pkgs.grim}/bin/grim -g \"\\\$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy'";
  screenshotWindow = "${pkgs.bash}/bin/bash -c '${pkgs.grim}/bin/grim -g \"\\\$(${pkgs.slurp}/bin/slurp -w)\" - | ${pkgs.wl-clipboard}/bin/wl-copy'";
  screenshotOutput = "${pkgs.bash}/bin/bash -c '${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy'";
}
