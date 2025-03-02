{ config, pkgs, lib, ... }:
let
  vim-config = {
    common = ''
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set autoindent
      set number
      set list
      set listchars=tab:→\ ,eol:¬,nbsp:·,trail:•,extends:⟩,precedes:⟨
      set modeline
      set wrap
      set hlsearch
      set incsearch
      set backspace=indent,eol,start
      set termguicolors

      nnoremap <Leader>ff :FZF<CR>

      nnoremap <F5> :NERDTreeToggle<CR>

      colorscheme catppuccin_mocha

      let g:airline_theme = 'catppuccin_mocha'
      if !exists('g:airline_symbols')
        let g:airline_symbols = {}
      endif
      let g:airline_symbols.maxlinenr = '''
      let g:airline_symbols.linenr = 'ln:'
      let g:airline_symbols.colnr = ' co:'
    '';
    vim = ''
      if executable('rust-analyzer')
        au User lsp_setup call lsp#register_server({
          \ 'name': 'rust-analyzer',
          \ 'cmd': {server_info->['rust-analyzer']},
          \ 'allowlist': ['rust'],
          \ })
      endif
      if executable('ocamllsp')
        au User lsp_setup call lsp#register_server({
          \ 'name': 'ocamllsp',
          \ 'cmd': {server_info->['ocamllsp']},
          \ 'allowlist': ['ocaml'],
          \ })
      endif
      function! s:on_lsp_buffer_enabled() abort
        setlocal signcolumn=yes
        if exists('+tagfunc')
          setlocal tagfunc=lsp#tagfunc
        endif
        nmap <buffer> gd <plug>(lsp-definition)
        nmap <buffer> gi <plug>(lsp-implementation)
        nmap <buffer> <leader>rn <plug>(lsp-rename)
        nmap <buffer> [d <plug>(lsp-previous-diagnostic)
        nmap <buffer> ]d <plug>(lsp-next-diagnostic)
        nmap <buffer> K <plug>(lsp-hover)
        nmap <buffer> <leader>ca <plug>(lsp-code-actions)
        nnoremap <buffer> <expr><c-j> lsp#scroll(+4)
        nnoremap <buffer> <expr><c-k> lsp#scroll(-4)
        let g:lsp_format_sync_timeout = 1000
      endfunction
      augroup lsp_install
        au!
        autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
      augroup END
      let g:lsp_diagnostics_virtual_text_prefix = " ‣ "
      let g:lsp_inlay_hints_enabled = 1
    '';
    nvim = ''
      lua require('lean').setup{ mappings = true }
    '';
  };
in
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

      export LANG=en_US.UTF-8
      export PROMPT='%F{120}%n@%m %F{219}$(print -P %~ | iconv -f utf-8-mac -t utf-8) %f%# ';
      setopt PROMPT_SUBST
    '';
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      fzf-vim
      nerdtree
      catppuccin-vim
      vim-airline
      copilot-vim

      lean-nvim
    ];
    extraConfig = "${vim-config.common}\n${vim-config.nvim}";
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      fzf-vim
      nerdtree
      catppuccin-vim
      vim-airline
      copilot-vim

      vim-lsp
      asyncomplete-vim
      asyncomplete-lsp-vim

      vim-nix
      vim-healthcheck
    ];
    extraConfig = "${vim-config.common}\n${vim-config.vim}";
  };
}
