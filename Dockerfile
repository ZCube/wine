FROM ubuntu:18.04
#FROM ibmjava:8-sdk
MAINTAINER ZCubeKr <zcube@zcube.kr>

# wine install
RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y software-properties-common wget apt-transport-https && \
    wget https://dl.winehq.org/wine-builds/Release.key && \
    apt-key add Release.key && \
    apt-add-repository 'deb http://dl.winehq.org/wine-builds/ubuntu/ artful main' && \
    apt-get update -y && \
    apt-get install -y cabextract redis-server winehq-stable xvfb wget psmisc python-pip python3-pip aptitude net-tools curl vim git sed &&\
    pip2 install supervisor && \
    pip2 install --upgrade pip && \
    pip3 install --upgrade pip && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoclean -y

RUN useradd -u 1001 -d /home/wine -m -s /bin/bash wine
ENV HOME /home/wine
ENV WINEPREFIX /home/wine/.wine
ENV WINEDEBUG -all
ENV WINEARCH win32

RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x winetricks && \
    rm -rf /tmp/.wine* && \
    su -p -l wine -c winecfg && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q mfc40' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q mfc42' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q msvcirt' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q vcrun6' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q vcrun2010' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q vcrun2013' && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q vcrun2015' && \
    rm winetricks && \
    rm -rf /tmp/.wine*

RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x winetricks && \
    rm -rf /tmp/.wine* && \
    su -p -l wine -c 'xvfb-run -a ./winetricks -q dotnet40' && \
    rm winetricks && \
    rm -rf /tmp/.wine*
    
    
# python 2.7
RUN wget https://www.python.org/ftp/python/2.7.15/python-2.7.15.msi &&\
    chmod +x python-2.7.15.msi && \
    rm -rf /tmp/.wine* && \
    su -p -l wine -c 'wine msiexec /i "python-2.7.15.msi" /passive /norestart ADDLOCAL=ALL' && \
    cp /home/wine/.wine/drive_c/Python27/Scripts/pip.exe /home/wine/.wine/drive_c/Python27/Scripts/pip_.exe && \
    su -p -l wine -c 'wine c:/Python27/Scripts/pip_.exe install --upgrade pip' && \
    rm /home/wine/.wine/drive_c/Python27/Scripts/pip_.exe && \
    rm python-2.7.15.msi && \
    rm -rf /tmp/.wine*
    
# python 3.4
RUN wget https://www.python.org/ftp/python/3.4.3/python-3.4.3.msi &&\
    chmod +x python-3.4.3.msi && \
    rm -rf /tmp/.wine* && \
    su -p -l wine -c 'wine msiexec /i "python-3.4.3.msi" /passive /norestart ADDLOCAL=ALL' && \
    cp /home/wine/.wine/drive_c/Python34/Scripts/pip.exe /home/wine/.wine/drive_c/Python34/Scripts/pip_.exe && \
    su -p -l wine -c 'wine c:/Python34/Scripts/pip_.exe install --upgrade pip' && \
    rm /home/wine/.wine/drive_c/Python34/Scripts/pip_.exe && \
    rm python-3.4.3.msi && \
    rm -rf /tmp/.wine*
    
# clean
RUN apt-get purge -y software-properties-common && \
    apt-get autoclean -y

ENV PYTHOHN_LIBRARIES tornado zmq redis sqlalchemy jinja2 PyMySQL pika grpcio-tools googleapis-common-protos

# python packages
RUN rm -rf /tmp/.wine* && \
    su -p -l wine -c 'wine c:/Python27/Scripts/pip.exe install $PYTHOHN_LIBRARIES' && \
    su -p -l wine -c 'wine c:/Python34/Scripts/pip.exe install $PYTHOHN_LIBRARIES' && \
    pip2 install $PYTHOHN_LIBRARIES && \
    pip3 install $PYTHOHN_LIBRARIES && \
    rm -rf /tmp/.wine*

# volume

#USER wine
CMD ["/bin/bash"]
