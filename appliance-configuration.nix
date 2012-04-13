{ config, pkgs, ...  } : 
{
  # specify the kernel
  boot.kernelPackages = pkgs.linuxPackages_2_6_39 ; 

  # customize the choice of packages for this appliance
  #nixpkgs.config = {
  #  packageOverrides = orig : {
  #  };
  #};

  #
  # List services that you want to enable:
  #

  # Add an OpenSSH daemon.
  services.openssh.enable = true;

  # Add the NixOS Manual on virtual console 8
  services.nixosManual.showManual = false;
}
