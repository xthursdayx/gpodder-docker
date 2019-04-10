### gPodder

My attempt to create a gPodder docker container with a built-in browser-based GUI.

#### Install:

You can run this docker with the following command:

````
docker run -d \
  --name="gPodder" \
  -e HEIGHT="720" \
  -e WIDTH="1280" \
  -e "TZ=America/New_York"
  -v /path/to/config:/config:rw \
  -v /path/to/downloads:/downloads:rw \
  -p XXXX:8080 \
  -p XXXX:3389
  xthursdayx/docker-gpodder
  
#### Setup Instructions:

- Replace "/path/to/config" with your choice of folder location. That is where all of your configuration and database files will reside, so you won't lose data when you update, reinstall, etc.
- Replace "XXXX" with your choice of ports.
- You can change the screen resolution by modifying the WIDTH and HEIGHT variables.
- Ctrl-Alt-Shft will bring up the menu that allows changing input options, as well as controlling the clipboard

To access the GUI, point your web browser to http://SERVERIP:8080/#/client/c/gPodder (Replace SERVERIP with the correct value),
