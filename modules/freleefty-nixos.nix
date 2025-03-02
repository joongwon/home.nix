{ config, pkgs, lib, ... }:
let
  mkI3Keybindings = input: lib.mkOptionDefault (input config.xsession.windowManager.i3.config.modifier);
in
{
  imports = [ ./common.nix ];

  home.stateVersion = "24.11";
  home.username = "joongwon";
  home.homeDirectory = "/home/joongwon";
  home.packages = with pkgs; [
    coq
    imagemagick
    lean4
    pavucontrol
    python3
    zip
    unzip
    discord
  ];

  home.file = {
    ".uim" = {
      source = ./uim;
      executable = false;
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
