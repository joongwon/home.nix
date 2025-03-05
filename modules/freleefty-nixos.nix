{ config, pkgs, lib, ... }:
let
  mkI3Keybindings = input: lib.mkOptionDefault (input config.xsession.windowManager.i3.config.modifier);
in
{
  imports = [ ./common.nix ];

  home.stateVersion = "24.11";
  home.username = "joongwon";
  home.homeDirectory = "/home/joongwon";
  nixpkgs.config.permittedInsecurePackages = [ "xpdf-4.05" ];
  home.packages = with pkgs; [
    coq
    imagemagick
    lean4
    pavucontrol
    python3
    zip
    unzip
    discord
    xpdf
  ];

  home.file = {
    ".uim" = {
      source = ./uim;
      executable = false;
    };
    ".xpdfrc" = {
      executable = false;
      text =
        let
          ghostscriptDir = "${pkgs.ghostscript}/share/ghostscript/fonts";
        in
        ''
          fontFile Times-Roman        ${ghostscriptDir}/n021003l.pfb
          fontFile Times-Italic       ${ghostscriptDir}/n021023l.pfb
          fontFile Times-Bold         ${ghostscriptDir}/n021004l.pfb
          fontFile Times-BoldItalic   ${ghostscriptDir}/n021024l.pfb
          fontFile Helvetica              ${ghostscriptDir}/n019003l.pfb
          fontFile Helvetica-Oblique      ${ghostscriptDir}/n019023l.pfb
          fontFile Helvetica-Bold         ${ghostscriptDir}/n019004l.pfb
          fontFile Helvetica-BoldOblique  ${ghostscriptDir}/n019024l.pfb
          fontFile Courier              ${ghostscriptDir}/n022003l.pfb
          fontFile Courier-Oblique      ${ghostscriptDir}/n022023l.pfb
          fontFile Courier-Bold         ${ghostscriptDir}/n022004l.pfb
          fontFile Courier-BoldOblique  ${ghostscriptDir}/n022024l.pfb
          fontFile Symbol         ${ghostscriptDir}/s050000l.pfb
          fontFile ZapfDingbats   ${ghostscriptDir}/d050000l.pfb
        '';
    };
  };

  home.keyboard = null;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  xresources.properties = {
    "xterm*Background" = "black";
    "xterm*Foreground" = "grey";
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      # focus.followMouse = false;
      modifier = "Mod4";
      fonts.size = 10.0;
      keybindings = mkI3Keybindings (mod: {
        XF86AudioRaiseVolume = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status";
        XF86AudioLowerVolume = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status";
        XF86AudioMute = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status";
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
        "${mod}+Shift+v" = "split h";

        "${mod}+0" = "workspace 0";
        "${mod}+Shift+0" = "move container to workspace 0";
      });
      modes.resize = mkI3Keybindings (mod: {
        "${mod}+h" = "resize shrink width 10 px or 10 ppt";
        "${mod}+j" = "resize grow height 10 px or 10 ppt";
        "${mod}+k" = "resize shrink height 10 px or 10 ppt";
        "${mod}+l" = "resize grow width 10 px or 10 ppt";
        "${mod}+r" = "mode \"default\"";
      });
    };

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
