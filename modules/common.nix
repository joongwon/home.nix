{ config, pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    tmux
  ];

  programs.bash = {
    enable = true;
    initExtra = ''
      set -o vi
    '';
  };

  programs.zsh = {
    enable = true;
    initExtra = ''
      bindkey -v
      bindkey -v '^?' backward-delete-char
      export PROMPT="%F{120}%n@%m %F{219}$(print -P %~ | iconv -f utf-8-mac -t utf-8) %f%# ";
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
      web-devicons.enable = true;
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
}
