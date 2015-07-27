FROM ubuntu:trusty
MAINTAINER Markus Kienast <mark@trickkiste.at>
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /tmp
WORKDIR /tmp

# Download all dependencies and build OBE
RUN apt-get update && \
    apt-get install -y git wget curl build-essential && \
    apt-get install -y wget libjpeg62 libgl1-mesa-glx libxml2 && \
    \
    wget --quiet -O /tmp/yasm-1.2.0.tar.gz http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz && \
    cd /tmp && tar -zxvf yasm-1.2.0.tar.gz && \
    cd yasm-1.2.0/ && ./configure --prefix=/usr && make -j5 && make install && \
    \
    apt-get install -y libtwolame-dev autoconf libtool && \
    \
    cd /tmp && git clone https://github.com/ob-encoder/fdk-aac.git && \
    cd /tmp/fdk-aac && autoreconf -i && ./configure --prefix=/usr --enable-shared && make -j5 && make install && \
    \
    cd /tmp && git clone https://github.com/ob-encoder/libav-obe.git && \
    cd /tmp/libav-obe && ./configure --prefix=/usr --enable-gpl --enable-nonfree --enable-libfdk-aac \
    --disable-swscale-alpha --disable-avdevice && make -j5 && make install && \
    \
    cd /tmp && git clone https://github.com/ob-encoder/x264-obe.git && \
    cd /tmp/x264-obe && ./configure --prefix=/usr --disable-lavf --disable-swscale --disable-opencl && \
    make -j5 && make install-lib-static && \
    \
    cd /tmp && git clone https://github.com/ob-encoder/libmpegts-obe.git && \
    cd /tmp/libmpegts-obe && ./configure --prefix=/usr && make -j5 && make install && \
    \
    apt-get install -y libzvbi0 libzvbi-dev libzvbi-common libreadline-dev && \
    \
    wget --quiet -O /tmp/Blackmagic_Desktop_Video_Linux_10.1.1.tar.gz http://software.blackmagicdesign.com/DesktopVideo/Blackmagic_Desktop_Video_Linux_10.1.1.tar.gz && \
    cd /tmp && tar xvfz /tmp/Blackmagic_Desktop_Video_Linux_10.1.1.tar.gz && \
    dpkg --force-depends -i /tmp/DesktopVideo_10.1.1/deb/amd64/desktopvideo_10.1.1a26_amd64.deb && \
    \
    cd /tmp && git clone -b config-file https://github.com/gfto/obe-rt.git && \
    cd /tmp/obe-rt && export PKG_CONFIG_PATH=/usr/lib/pkgconfig && \
    ./configure --prefix=/usr && make -j5 && make install && \
    \
    dpkg -r desktopvideo && \
    \
    rm -rf /tmp && \
    apt-get install -y libtwolame0 && \
    \
    apt-get remove -y libreadline-dev libzvbi-dev libtwolame-dev \
    autoconf libtool git wget curl \
    manpages manpages-dev g++ g++-4.6 build-essential && \
    \
    apt-get autoclean -y && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    dpkg --force-depends -i /tmp/DesktopVideo_10.1.1/deb/amd64/desktopvideo_10.1.1a26_amd64.deb && \
    rm -r /tmp/*

RUN     useradd -m default

WORKDIR /home/default

USER    default
ENV     HOME /home/default

ENTRYPOINT ["/usr/bin/obecli"]
