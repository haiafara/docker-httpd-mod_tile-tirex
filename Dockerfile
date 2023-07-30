FROM httpd:2.4-bookworm

# update package list
RUN apt-get update

# install main dependencies
RUN apt-get install -y --no-install-recommends \
  apache2-dev \
  build-essential \
  cmake \
  devscripts \
  git \
  libapache2-mod-tile \
  libgd-gd2-perl \
  libipc-sharelite-perl \
  libjson-perl \
  libmapnik-dev \
  make \
  tirex

# RUN cp /etc/apache2/conf-available/tirex.conf /usr/local/apache2/conf/extra/tirex.conf

COPY fs /

RUN cp /usr/lib/apache2/modules/mod_tile.so /usr/local/apache2/modules/mod_tile.so

RUN echo "Include conf/extra/tirex.conf" >> /usr/local/apache2/conf/httpd.conf

RUN echo "LoadModule tile_module modules/mod_tile.so" >> /usr/local/apache2/conf/httpd.conf

RUN apt-get install -y mc

# modify the _tirex user created by apt to be able to run tirex from the command line
RUN mkdir /home/tirex && \
  chown _tirex /home/tirex && \
  usermod -d /home/tirex _tirex && \
  usermod -s /bin/bash _tirex && \
  mkdir /run/tirex && \
  chown _tirex /run/tirex

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 8082
