{ config, pkgs, ... }:

{
  # specify the kernel
  boot.kernelPackages = pkgs.linuxPackages_3_2 ; 

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

  services.httpd.enable = true ; 
  services.httpd.enableSSL = true;  
  services.httpd.sslServerCert = "/var/ssl/server.crt" ; 
  services.httpd.sslServerKey  = "/var/ssl/server.key" ; 
  services.httpd.adminAddr = "bnordgren@fs.fed.us" ; 
  services.httpd.extraSubservices =  [
    { serviceType = "tomcat-connector" ; 
      stateDir = "/var/run/httpd" ; 
      logDir   = "/var/log/httpd" ; 
    }
  ] ;

  services.mysql.enable = true ;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Mount the NFS share
  fileSystems = [ 
    {
       mountPoint = "/mnt/rxcadre" ; 
       device = "fislstore:/mnt/rxcadre" ; 
       fsType = "nfs"; 
    } 
  ] ;
}
