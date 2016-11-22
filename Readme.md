# Info
Early veryion, not optimized. Tested on OSX.
Make sure your XQuartz is working ok also with glx.
`glxgears` needs to be working in your local, and in the docker. 

# Build Docker
`docker build .`

# Commands Local
Enable x11 foward to a tcp port, socket forward not possible on osx (imho).
You can install this via `brew install socat` - yes for that you need brew.
`socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`

# Docker Start
Start the docker container, with display forwarding back to the host (sock)
`ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')`
`docker run --privileged -it -e DISPLAY=$ip:0 bsolut/wine /bin/bash `

# Docker Commands - need privileged - already done on the uploaded image
`winetricks -q --unattended dotnet46`
`wget https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe && wine NDP461-KB3102436-x86-x64-AllOS-ENU.exe /q`
`rm -r .cache && rm NDP461-KB3102436-x86-x64-AllOS-ENU.exe`

# XQuartz
`defaults write org.macosforge.xquartz.X11 enable_iglx -bool true`

# Credits
- https://github.com/suchja/wine

# OLD
- RUN mkdir /opt/wine-devel/share/mono/ && curl -SL 'http://dl.winehq.org/wine/wine-mono/4.6.3/wine-mono-4.6.3.msi' -o /opt/wine-devel/share/mono/wine-mono-4.6.3.msi
- RUN mkdir /opt/wine-devel/share/gecko/ && curl -SL 'http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi' -o /opt/wine-devel/share/gecko/wine_gecko-2.47-x86.msi

# Commit custom build
`docker commit -m "ready for action" 310ceaec77b5 bsolut/wine`
`docker push  bsolut/wine`

