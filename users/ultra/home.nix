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
  hypr-contrib = inputs.hypr-contrib.packages.${pkgs.system};
in {
    imports = [ 
      inputs.nix-doom-emacs.hmModule
      # inputs.hyprland.homeManagerModules.default
    ];
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
        wofi
        hyprpaper
        alacritty
        tofi
        dunst
        wl-clipboard
        polkit-kde-agent
        grim
        hypr-contrib.grimblast
        hypr-contrib.scratchpad
        kitty
        waybar
        eww-wayland
        notify-desktop
        libnotify
        xdg-desktop-portal-hyprland
        jq
      ];
    };

    # ${config.xdg.configFile}."hypr/hyprland.conf".source = ./configs/hyprland/hyprland.conf;
    programs = {
      home-manager.enable = true;
      doom-emacs = {
        enable = false; # takes a lot of time to compile
        doomPrivateDir = ./doom.d;
      };
      # fish.enable = true;

      # Helix config
      helix = {
        enable = true;
        package = helix;
        languages = {
          language-server = with pkgs; {
            cpp.command = "${clang-tools}/bin/clangd";
            c.command = "${clang-tools}/bin/clangd";
            nix.command = "${nil}/bin/nil";
          };
          language = [
            {
              name = "cpp";
              scope = "source.cpp";
              indent = {
                tab-width = 4;
                unit = " ";
              };
              # language-server.command = "clangd";
              file-types = [ "cpp" ];
            }
            {
              name = "c";
              scope = "source.c";
              indent = {
                tab-width = 4;
                unit = " ";
              };
              # language-server.command = "clangd";
              file-types = [ "c" ];
            }
            {
              name = "nix";
              scope = "source.nix";
              indent = {
                tab-width = 4;
                unit = " ";
              };
              # language-server.command = "nil";
              file-types = [ "nix" ];
            }
          ];
        };
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
            auto-save = true;
            true-color = true;
          };
        };
      };
      /*
     hyprland = {
        enable = true;
        extraConfig = builtins.readFile ./configs/hyprland/hyprland.conf;
      };
      */ 
    };
    
  }
