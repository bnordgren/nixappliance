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

  # Add the FTP server.
  services.vsftpd = {
    enable = true ; 
    anonymousUser = true ; 
    anonymousUserHome = "/var/ftp" ; 
    anonymousMkdirEnable = false ; 
    localUsers = false ;

    # enable uploads
    anonymousUploadEnable = true ; 
    writeEnable = true ;

    # turn off ability to list directories
    additionalConfig = ''
      dirlist_enable=NO
    '' ;

  } ;
}
