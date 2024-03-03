{
  system.stateVersion = "24.05";
  time.timeZone = "America/Toronto";

  nix = {
    settings.auto-optimise-store = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  users.users.root = {
    openssh.authorizedKeys.keys = (import ../keys.nix);
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  programs = {
    git.enable = true;

    ssh.extraConfig = ''
      Host github.com
        IdentityFile /root/.ssh/id_ed25519
        IdentityFile /root/.ssh/id_rsa
        StrictHostKeyChecking accept-new
    '';
  };
}
