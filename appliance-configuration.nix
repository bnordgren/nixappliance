{ config, pkgs, ...  } : 
{
  # specify the kernel
  boot.kernelPackages = pkgs.linuxPackages_3_2 ; 

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

  # Add an NFS export to the rxdata front end.
  services.nfs.server = { 
    enable = true ; 
    exports = ''/mnt/rxcadre 192.168.56.2(rw,all_squash,no_subtree_check)'' ; 
  } ; 
}
