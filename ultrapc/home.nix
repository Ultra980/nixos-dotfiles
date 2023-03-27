{pkgs, ...}: {
    home = {
      username = "ultra";
      homeDirectory = "/home/ultra/";
      stateVersion = "22.11";
      packages = with pkgs; [
        # neovim
        # bat
      ];
    };
    programs.home-manager.enable = true;
}
