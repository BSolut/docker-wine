FROM ubuntu:yakkety
RUN dpkg --add-architecture i386 
RUN apt-get update -y \
	&& apt-get install software-properties-common -y \
    && add-apt-repository ppa:wine/wine-builds -y \
    && apt-get update -y \
    && apt-get install --install-recommends winehq-devel -y \
    && apt-get install curl unzip xauth  -y \
    && apt-get install x11-apps telnet nmap mc zenity cabextract wget -y \
    && apt-get install winbind dnsutils iputils-ping mesa-utils  -y \
	&& apt-get upgrade -y -q \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# first create user and group for all the X Window stuff
# required to do this first so we have consistent uid/gid between server and client container
RUN addgroup --system xusers \
  && adduser \
			--home /home/xclient \
			--disabled-password \
			--shell /bin/bash \
			--gecos "user for running an xclient application" \
			--ingroup xusers \
			--quiet \
			xclient

RUN curl -SL 'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks' -o /usr/local/bin/winetricks \
	&& chmod +x /usr/local/bin/winetricks

# Wine really doesn't like to be run as root, so let's use a non-root user
USER xclient
ENV HOME /home/xclient
ENV WINEPREFIX /home/xclient/.wine

# Tell wine to behave like a 32-bit Windows.
# https://wiki.archlinux.org/index.php/Wine#WINEARCH
ENV WINEARCH win32

# We have a development build of wine, which means tons of debug output.
# Thus we should suppress it: https://www.winehq.org/docs/winedev-guide/dbg-control
#ENV WINEDEBUG -all

# Use xclient's home dir as working dir
WORKDIR /home/xclient

RUN echo "alias winegui='wine explorer /desktop=DockerDesktop,1024x768'" > ~/.bash_aliases 

