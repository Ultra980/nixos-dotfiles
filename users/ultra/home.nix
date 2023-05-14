{ pkgs, inputs, lib, config, ... }: 
let
  nix-software-center = inputs.nix-software-center.packages.${pkgs.system}.nix-software-center;
  doom-emacs = inputs.nix-doom-emacs.packages.${pkgs.system}.default.override {
      doomPrivateDir = ./doom.d;
  };
  helix = inputs.helix.packages.${pkgs.system}.default;
  # nixpkgs-master-pkgs = inputs.nixpkgs-master.legacyPackages.${pkgs.system};
  # nixpkgs-master = inputs.nixpkgs-master;
  nixpkgs-master = import inputs.nixpkgs-master {
      inherit (config.nixpkgs) config overlays;
      inherit (pkgs) system;
  };
in {
    imports = [ inputs.nix-doom-emacs.hmModule ];
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = (pkg: true);
    nixpkgs.config.permittedInsecurePackages = [
      "electron-21.4.0"
    ];
    /*
    nixpkgs-master.config = {
      allowUnfree = true;
      allowUnfreePredicate = (pkg: true);
      permittedInsecurePackages = [
        "electron-21.4.0"
      ];
    };
    */
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
        appimage-run
        # xivlauncher # Still fails to build :(
        nixpkgs-master.xivlauncher # It's fixed on master
        prismlauncher
        ghostwriter
        skypeforlinux
        man-pages
        ckan
        cool-retro-term
        # helix
      ];
    };
    programs = {
      home-manager.enable = true;
      doom-emacs = {
        enable = false; # takes a lot of time to compile
        doomPrivateDir = ./doom.d;
      };
      # fish.enable = true;
      helix = {
        enable = true;
        package = helix;
        languages = [
          {
            name = "cpp";
            scope = "source.cpp";
            indent = {
              tab-width = 4;
              unit = " ";
            };
            language-server.command = "clangd";
            file-types = [ "cpp" ];
          }
          {
            name = "c";
            scope = "source.c";
            indent = {
              tab-width = 4;
              unit = " ";
            };
            language-server.command = "clangd";
            file-types = [ "c" ];
          }
          {
            name = "nix";
            scope = "source.nix";
            indent = {
              tab-width = 4;
              unit = " ";
            };
            language-server.command = "nil";
            file-types = [ "nix" ];
          }
        ];
        settings = {
          theme = "everblush";
          editor = {
            line-number = "relative";
            mouse = true;
            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "underline";
            };
            file-picker.hidden = false;
          };
        };
      };
    };
}
