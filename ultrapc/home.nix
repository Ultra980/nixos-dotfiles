{ pkgs, inputs, lib, ... }: 
let
  nix-software-center = inputs.nix-software-center.packages.${pkgs.system}.nix-software-center;
  doom-emacs = inputs.nix-doom-emacs.packages.${pkgs.system}.default.override {
      doomPrivateDir = ./doom.d;
  };
in {
    imports = [ inputs.nix-doom-emacs.hmModule ];
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    home = {
      username = "ultra";
      homeDirectory = "/home/ultra/";
      stateVersion = "22.11";
      packages = with pkgs; [
        firefox
        kate
        distrobox
        fish
        nushell
        git
        bat
        gnupg1
        zoom-us
        google-chrome
        zoxide
        starship
        atuin
        clang
        (lib.hiPrio gcc)
        exa
        gnumake
        plasma-browser-integration
        libsForQt5.bismuth
        whatsapp-for-linux
        signal-desktop
        nodejs
        onlyoffice-bin
        drawio
        xclip
        steam
        packagekit
        armcord
        rnote
        obsidian
        gnome-obfuscate
        microsoft-edge
        # doom-emacs
        ripgrep
        w3m
        github-cli
        mc
        zellij
        lsd
        tealdeer
        fd
        broot
        fzf
        bottom
        hyperfine
        procs
        httpie
        curlie
        xh
        du-dust
        duf
        virtualbox
        spotify
      ];
    };
    programs = {
      home-manager.enable = true;
      doom-emacs = {
        enable = true;
        doomPrivateDir = ./doom.d;
      };
      # fish.enable = true;
    };
}
