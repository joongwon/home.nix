{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "joongwon";
  home.homeDirectory = "/home/joongwon";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    coq
    imagemagick
    lean4
    pavucontrol
    python3
    zip
  ];

  home.file = {
    ".uim" = {
      source = ./uim;
      executable = false;
    };
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;

  home.keyboard = null;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  xresources.properties = {
    "xterm*Background" = "black";
    "xterm*Foreground" = "grey";
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      set -o vi
    '';
  };

  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;

    plugins = {
      airline = {
        enable = true;
        settings.symbols = {
          colnr = " co:";
          linenr = " ln:";
        };
      };
      web-devicons.enable = false;
      neo-tree.enable = true;
      fzf-lua.enable = true;
      lean.enable = true;
      copilot-vim.enable = true;
    };

    opts = {
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      autoindent = true;
      number = true;
      list = true;
      listchars = "tab:→\\ ,eol:¬,nbsp:·,trail:•,extends:⟩,precedes:⟨";
      modeline = true;
      wrap = true;
      hlsearch = true;
      incsearch = true;
      backspace="indent,eol,start";
    };

    keymaps = [
      { mode = "n"; key = "<Leader>ff"; action = ":FzfLua files<CR>"; }
      { key = "<F5>"; action = ":Neotree<CR>"; }
    ];
  };

  programs.i3status = {
    enable = true;
    enableDefault = false;
    modules = {
      "memory" = {
        position = 0;
        settings = {
          format = "%used / %total";
          threshold_degraded = "10%";
          threshold_critical = "5%";
        };
      };
      "cpu_usage" = {
        position = 1;
        settings = {
          format = "CPU: %usage";
          max_threshold = 95;
          degraded_threshold = 90;
        };
      };
      "volume master" = {
        position = 2;
        settings = {
          format = "♪: %volume";
          format_muted = "♪: muted (%volume)";
          device = "default";
          mixer = "Master";
          mixer_idx = 0;
        };
      };
      "ethernet _first_" = {
        position = 3;
        settings = {
          format_up = "E: %ip (%speed)";
          format_down = "E: down";
        };
      };
      "time" = {
        position = 4;
        settings = {
          format = "%Y-%m-%d %H:%M:%S";
        };
      };
    };
  };
}
