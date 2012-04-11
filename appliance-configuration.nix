{ config, pkgs, ...  } : 
{
  # specify the kernel
  boot.kernelPackages = pkgs.linuxPackages_3_2 ; 

  # customize the choice of packages for this appliance
  nixpkgs.config = {
    packageOverrides = orig : {
      postgresql = pkgs.postgresql90;
    };
  };

  #
  # List services that you want to enable:
  #

  # Add an OpenSSH daemon.
  services.openssh.enable = true;

  # Add the NixOS Manual on virtual console 8
  services.nixosManual.showManual = false;

  # turn on postgresql with the postgis extension
  services.postgresql = {
    enable = true ;
    enableTCPIP = true ; 
    authentication = ''
     # generated file, do not edit!
     local all all trust
     host  all all 127.0.0.1/32 md5
     host  all all 0.0.0.0/0    md5
    ''; 
    extraPlugins = [ pkgs.postgis.v_2_0_0b2 ] ;
  } ; 
}
