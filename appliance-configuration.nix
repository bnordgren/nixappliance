{ config, pkgs, ... }:

{
  # specify the kernel
  boot.kernelPackages = pkgs.linuxPackages_3_2 ; 

  environment.systemPackages =  [ 
    pkgs.openssl 
    pkgs.vim
  ];

  # time
  time.timeZone = "America/Denver" ; 
  services.ntp.enable = true ; 

  # List services that you want to enable:
  services.geonetwork.enable = true ; 
  services.geonetwork.extent = "-130,23,-65,50" ; 
  services.geonetwork.databaseConfig = ''
                <resource enabled="true">
                        <name>main-db</name>
                        <provider>jeeves.resources.dbms.DbmsPool</provider>
                        <config>
                                <user>geonetwork</user>
                                <password>bigdisk</password>
                                <driver>com.mysql.jdbc.Driver</driver>
                                <url>jdbc:mysql://localhost/geonetwork</url>
                                <poolSize>10</poolSize>
                                <reconnectTime>3600</reconnectTime>
                        </config>
                </resource>
'' ;
  services.geonetwork.baseDir = "/mnt/rxcadre/geonetwork" ; 
  services.geonetwork.geoserverUrl = "https://rxdata.usfs-i2.umt.edu/geoserver/wms" ; 
  services.geoserver.enable  = true ; 
  services.geoserver.pyramids = true ; 
  services.tomcat.javaOpts = "-Xms256m -Xmx1256m -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512m -XX:CompileCommand=exclude,net/sf/saxon/event/ReceivingContentHandler.startElement" ;
  services.tomcat.sharedLibs = [ "${pkgs.xercesJava}/lib/java/xercesImpl.jar"
  "${pkgs.mysql_jdbc}/share/java/mysql-connector-java.jar" ] ; 

  services.httpd = {
    enable = true ; 
    hostName = config.networking.hostName ; 
    adminAddr = "bnordgren@fs.fed.us" ; 
    documentRoot = "/var/httpd"; 

    virtualHosts = [
      { hostName = config.networking.hostName ;
        extraConfig = ''
          Redirect / https://${config.networking.hostName}/
        '';

      } 
      { hostName = config.networking.hostName ;
        enableSSL = true;  
        sslServerCert = "/var/ssl/server.crt" ; 
        sslServerKey  = "/var/ssl/server.key" ; 
      }
    ];

    extraSubservices =  [
      { serviceType = "tomcat-connector" ; 
        stateDir = "/var/run/httpd" ; 
        logDir   = "/var/log/httpd" ; 
      }
      { serviceType = "rxdrupal" ; 
        publicUploadDir = "/mnt/rxcadre/drupal/public" ; 
        privateUploadDir = "/mnt/rxcadre/drupal/private" ; 
        tmpUploadDir = "/mnt/rxcadre/drupal/tmp" ; 
        urlPrefix = "/working";   
        dbuser = "drupal" ;
        dbname = "rxdata" ;
        dbpassword = "dr00pa!";
        maxFileUploads = "20" ; 
        maxUploadSize = "256M";
        postMaxSize = "1024M" ;
      }
      { serviceType = "rxdrupal" ; 
        publicUploadDir = "/mnt/rxcadre/drupal-sandbox/public" ; 
        privateUploadDir = "/mnt/rxcadre/drupal-sandbox/private" ; 
        tmpUploadDir = "/mnt/rxcadre/drupal-sandbox/tmp" ; 
        urlPrefix = "/working-sandbox";   
        dbuser = "drupal" ;
        dbname = "rxdata_sandbox" ;
        dbpassword = "dr00pa!";
        maxFileUploads = "20" ; 
        maxUploadSize = "256M";
        postMaxSize = "1024M" ;
      }
    ] ;
  };

  

  # using logrotate to make backups and keep them for a week
  services.logrotate = { 
    enable = true ; 
    config = ''
      nocompress
      rotate 5
      daily

      /mnt/rxcadre/drupal/backups/rxdata-db.dump.gz { 
        postrotate
          mysqldump -u drupal -pdr00pa\! rxdata | gzip > /mnt/rxcadre/drupal/backups/rxdata-db.dump.gz
        endscript
      }

      /mnt/rxcadre/drupal/backups/rxdata-files.tar.gz { 
        postrotate
          cd /mnt/rxcadre/drupal
          tar zcf backups/rxdata-files.tar.gz public private
        endscript
      } 
    '' ;
  } ; 

  # reset the sandbox to "empty" every night
  services.cron.systemCronJobs = [
    "10 0 * * * root /mnt/rxcadre/drupal-sandbox/bin/reset_sandbox.sh /mnt/rxcadre/drupal-sandbox/bin/rxdata_sandbox_empty.dump.gz"
  ] ;

  services.mysql.enable = true ;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  security.sudo = { 
    enable = true ; 
    wheelNeedsPassword = false ; 
  } ;

  # Mount the NFS share
  fileSystems = [ 
    {
       mountPoint = "/mnt/rxcadre" ; 
       device = "fislstore:/mnt/rxcadre" ; 
       fsType = "nfs"; 
    } 
  ] ;
}
