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
  services.openssh = {
    enable = true;
    gatewayPorts = "yes" ; 
  };

  # Add the NixOS Manual on virtual console 8
  services.nixosManual.showManual = false;

  # Add an NFS export to the rxdata front end.
  services.nfs.server = { 
    enable = true ; 
    exports = ''/mnt/rxcadre 192.168.56.2(rw,all_squash,no_subtree_check)'' ; 
  } ; 

  # Set up LDAP users
  users.ldap =  { 
    enable = true ; 
    daemon.enable = true ; 
    server = "ldap://localhost/";
    base = "ou=_FOREST_SERVICE,dc=ds,dc=fs,dc=fed,dc=us";
    bind =  {
      distinguishedName = "cn=bnordgren,ou=RMRS,ou=RESEARCH,ou=ENDUSERS,ou=_FOREST_SERVICE,dc=ds,dc=fs,dc=fed,dc=us";
      password = "/etc/ldap/bind.password" ;
    } ; 
    useTLS = true ;

    daemon.extraConfig = ''
      idle_timelimit 300
      filter passwd (objectClass=person)
      map passwd uid cn
      map passwd homeDirectory "''${homeDirectory:-/mnt/store}"
      map passwd loginShell "''${loginShell:-/bin/sh}"
      map passwd gidNumber  "''${gidNumber:-65534}"
      map passwd homeDirectory "/mnt/store"
      map passwd gidNumber     "65534"
      map passwd loginShell    "/run/current-system/sw/bin/rssh"
    '';

  } ;

  programs.rssh = {
    available = true ; 
    #enableRsync = false ;
    umask = "007";
  };

}
