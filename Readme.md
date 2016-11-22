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
`wget https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe`
`wine NDP461-KB3102436-x86-x64-AllOS-ENU.exe /q`

# XQuartz
`defaults write org.macosforge.xquartz.X11 enable_iglx -bool true`

# Credits
- https://github.com/suchja/wine

