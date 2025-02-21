{ config, pkgs, lib, ... }:
{
  imports = [ ./common.nix ];

  home.stateVersion = "24.11";
  home.username = "joongwon";
  home.homeDirectory = "/Users/joongwon";
  home.packages = with pkgs; [
    coreutils-prefixed
  ];

  programs.zsh.initExtra = ''
    alias oldls='/bin/ls'
    function ls() {
      gls --color=always -C $@ | iconv -f utf-8-mac -t utf-8
    }
  '';
}
