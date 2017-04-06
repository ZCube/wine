FROM ubuntu:16.04
MAINTAINER ZCubeKr <zcube@zcube.kr>

# wine install
RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y software-properties-common && \
    apt-get install -y python-software-properties && \
    add-apt-repository -y ppa:ubuntu-wine/ppa && \
    apt-get update -y && \
    apt-get install -y redis-server && \
    apt-get install -y wine1.8 xvfb wget psmisc nodejs-legacy nodejs npm python-pip &&\
    pip install tornado zmq supervisor redis && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoclean -y

RUN useradd -u 1001 -d /home/wine -m -s /bin/bash wine
ENV HOME /home/wine
ENV WINEPREFIX /home/wine/.wine
ENV WINEDEBUG -all
ENV WINEARCH win32

RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x winetricks && \
    su -p -l wine -c winecfg && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q mfc40' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q mfc42' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q msvcirt' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q vcrun6' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q vcrun2010' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q vcrun2013' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q vcrun2015' && \
    rm winetricks

RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x winetricks && \
    su -p -l wine -c 'wineboot' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q dotnet40' && \
    rm winetricks
    
# python 2.7
RUN wget https://www.python.org/ftp/python/2.7.13/python-2.7.13.msi &&\
    chmod +x python-2.7.13.msi && \
    su -p -l wine -c 'wine msiexec /i "python-2.7.13.msi" /passive /norestart ADDLOCAL=ALL' && \
    su -p -l wine -c 'wine c:/Python27/Scripts/pip.exe install tornado zmq redis' && \
    rm python-2.7.13.msi
    
# clean
RUN apt-get purge -y software-properties-common && \
    apt-get autoclean -y

# volume

USER wine
CMD ["/bin/bash"]
