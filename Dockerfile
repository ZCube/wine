FROM ubuntu:14.04
MAINTAINER ZCubeKr <zcube@zcube.kr>

# wine install
RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ubuntu-wine/ppa && \
    apt-get update -y && \
    apt-get install -y wine1.7 xvfb wget psmisc &&\
    rm -rf /var/lib/apt/lists/*

RUN useradd -u 1001 -d /home/wine -m -s /bin/bash wine
ENV HOME /home/wine
ENV WINEPREFIX /home/wine/.wine
ENV WINEDEBUG -all

RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x winetricks && \
    su -p -l wine -c winecfg && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q mfc40' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q mfc42' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q msvcirt' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q python26' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q vcrun6' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q vcrun2010' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q vcrun2013' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q vcrun2015' && \
    rm winetricks

# clean

RUN apt-get purge -y software-properties-common && \
    apt-get autoclean -y

# volume

#USER wine
CMD ["/bin/bash"]
