FROM ubuntu:17.04
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN sed -e 's/archive.ubuntu.com/old-releases.ubuntu.com/g' -i /etc/apt/sources.list 
RUN  sed -e 's/security.ubuntu.com/old-releases.ubuntu.com/g' -i /etc/apt/sources.list

LABEL maintainer="info@samsasoftware.nl"
RUN apt-get -y update
RUN apt-get -y dist-upgrade
RUN apt-get install -y git
RUN apt-get install -y curl
RUN apt-get install -y automake
RUN apt-get install -y build-essential libtool
RUN apt-get install -y gtk-doc-tools
RUN apt-get install -y autopoint
RUN apt-get install -y bison
RUN apt-get install -y libxml2
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libraptor2-0
RUN apt-get install -y libperl-dev
RUN apt-get install -y libgtk2.0-dev
RUN apt-get install -y libglib2.0-dev
WORKDIR /
RUN curl -L https://github.com/westes/flex/releases/download/v2.6.3/flex-2.6.3.tar.gz > flex.tar.gz
RUN tar -xzvf flex.tar.gz
WORKDIR flex-2.6.3
RUN ./autogen.sh
RUN ./configure && make && make install

# CMD flex -h

#install rapper
WORKDIR /
RUN git clone git://github.com/dajobe/raptor.git
WORKDIR raptor
RUN ./autogen.sh
RUN make
RUN make check
RUN make install

RUN  git clone git://github.com/dajobe/rasqal.git
WORKDIR rasqal
RUN ./autogen.sh
RUN make
RUN make check
RUN make install

RUN git clone git://github.com/dajobe/librdf.git
WORKDIR librdf
RUN ./autogen.sh
RUN make
RUN make install

COPY ./redstore /redstore
RUN apt-get install -y pkg-config

WORKDIR /redstore
RUN ./configure
RUN make
RUN make install
