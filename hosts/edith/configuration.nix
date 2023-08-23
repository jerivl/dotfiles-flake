{ pkgs, ... }: {
  # configuration in this file only applies to edith host.
  systemd.timers."update-edith" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1m";
      OnCalendar = "*-*-* 03:00:00";
      Unit = "update-edith.service";
    };
  };
  
  systemd.services."update-edith" = {
    serviceConfig = {
      Type = "oneshot";
      User = "jer";
      WorkingDirectory= "/home/jer/edith";
    };
    path = [ pkgs.git pkgs.openssh pkgs.docker ];
    script = "git pull; docker stop $(docker ps -a -q); docker compose up -d";
  };

  programs.msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = "/etc/aliases";
      port = 587;
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      tls = "on";
      auth = "login";
      tls_starttls = "on";
    };


    accounts = {
      default = {
        host = "in-v3.mailjet.com";
        passwordeval = "cat /var/lib/private/mailjet.conf";
        user = "1edd038c075938686b231810a8337d03";
        from = "edith@jerivl.com";
      };
    };
  };
  
  # Enable zfs email events 
  services.zfs.zed.settings = {
    ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_EMAIL_ADDR = [ "root" ];
    ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
    ZED_EMAIL_OPTS = "@ADDRESS@";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;

    ZED_USE_ENCLOSURE_LEDS = true;
    ZED_SCRUB_AFTER_RESILVER = true;
  };
  # this option does not work without recompiling the zfs module (slow); will return error
  services.zfs.zed.enableMail = false;

}
