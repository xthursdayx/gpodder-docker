<p align="center">
    <img src="https://raw.githubusercontent.com/xthursdayx/docker-templates/master/images/gpodder-icon.png" alt="" width="150"/>  
</p>

# gPodder Docker

A dockerized version of the [gPodder](https://gpodder.github.io/) podcast client with a built-in browser-based GUI.

[gPodder](https://gpodder.github.io/) is a simple, open source podcast client written in Python using GTK+. In development since 2005 with a proven, mature codebase.

### Install:

You can run this docker with the following command:

````
docker run -d \
  --name="gPodder" \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ="America/New_York" \
  -e GUAC_USER="Username for the gPodder desktop GUI" `#optional` \
  -e GUAC_PASS="md5 hash for gPodder desktop GUI" `#optional` \
  -v /path/to/config:/config:rw \
  -v /path/to/downloads:/downloads:rw \
  -p <port>:8080 \
  -p <port>:3389 \
  --restart unless-stopped \
  xthursdayx/gpodder-docker
 ```` 
  
### Setup and Usage Instructions:

- Replace "/path/to/config" with your choice of folder location. This directory is where all of gPodder's configuration and database files will reside, so you won't lose data when you update, reinstall, etc.
- Replace "/path/to/downloads" with your chosen downloads folder location. This is the directory gPodder will download your podcasts to. 
- Replace <port> with your choice of ports on your host machine.
- If you want to use authentication, replace GUAC_USER with the user name of your choice and GUAC_PASS with the md5 hash of your chosen password. You can do this by running the command: `echo -n <your_password> | md5sum`. If GUAC_USER and GUAC_PASS are not set, there will be no authentication. Please beware this image is not hardened for internet usage. Use a reverse ssl proxy to increase security.
- To access the GUI, point your web browser to http://SERVERIP:8080/#/client/c/gPodder (Replace SERVERIP with the correct value). To access gPodder via RDP use port 3389. 
- Ctrl-Alt-Shft will bring up the menu that allows changing input options, as well as controlling the clipboard.

If you appreciate my work please consider buying me a coffee, cheers! 😁

<a href="https://www.buymeacoffee.com/xthursdayx"><img src="https://www.paypal.com/en_US/i/btn/btn_donate_SM.gif" alt="Donate" style="width:74px;height:auto;" width="74"></a>
