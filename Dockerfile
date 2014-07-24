FROM stackbrew/ubuntu:14.04
MAINTAINER Markus Kienast <mark@trickkiste.at>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y curl wget dkms linux-headers-generic libjpeg62 libgl1 libxml2
RUN wget --quiet -O /tmp/Blackmagic_Desktop_Video_Linux_10.1.1.tar.gz http://software.blackmagicdesign.com/DesktopVideo/Blackmagic_Desktop_Video_Linux_10.1.1.tar.gz
RUN cd /tmp ; tar xvfz /tmp/Blackmagic_Desktop_Video_Linux_10.1.1.tar.gz
RUN dpkg -i /tmp/DesktopVideo_10.1.1/deb/amd64/desktopvideo_10.1.1a26_amd64.deb

RUN apt-get install -y curl wget git
RUN apt-get install -y build-essential

ENV HOME /tmp

RUN wget --quiet -O /tmp/yasm-1.2.0.tar.gz http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz && cd /tmp && tar -zxvf yasm-1.2.0.tar.gz && cd yasm-1.2.0/ && ./configure --prefix=/usr && make -j5 && make install

RUN apt-get install -y libtwolame-dev autoconf libtool 
RUN cd /tmp && git clone https://github.com/ob-encoder/fdk-aac.git && cd /tmp/fdk-aac && autoreconf -i && ./configure --prefix=/usr --enable-shared && make -j5 && make install
RUN cd /tmp && git clone https://github.com/ob-encoder/libav-obe.git && cd /tmp/libav-obe && ./configure --prefix=/usr --enable-gpl --enable-nonfree --enable-libfdk-aac --disable-swscale-alpha --disable-avdevice && make -j5 && make install
RUN cd /tmp && git clone https://github.com/ob-encoder/x264-obe.git && cd /tmp/x264-obe && ./configure --prefix=/usr --disable-lavf --disable-swscale --disable-opencl && make -j5 && make install-lib-static
RUN cd /tmp && git clone https://github.com/ob-encoder/libmpegts-obe.git && cd /tmp/libmpegts-obe && ./configure --prefix=/usr && make -j5 && make install
RUN apt-get install -y libzvbi0 libzvbi-dev libzvbi-common
RUN apt-get install -y libreadline-dev

# finally compile OBE
RUN cd /tmp && git clone https://github.com/ob-encoder/obe-rt.git && cd /tmp/obe-rt && export PKG_CONFIG_PATH=/usr/lib/pkgconfig && ./configure --prefix=/usr && make -j5 && make install

# Remove things for building modules
RUN rm -r /tmp/*

RUN apt-get install -y libtwolame0
RUN apt-get remove -y libreadline-dev libzvbi-dev libtwolame-dev 
RUN apt-get remove -y autoconf libtool curl wget git
RUN apt-get remove -y manpages manpages-dev g++ g++-4.6 build-essential
RUN apt-get autoclean -y
RUN apt-get autoremove -y
RUN apt-get clean -y

RUN     useradd -m default

WORKDIR /home/default

USER    default
ENV     HOME /home/default

ENTRYPOINT ["/usr/bin/obecli"]

