FROM httpd:2.4-bookworm

# update package list
RUN apt-get update

# install main dependencies
RUN apt-get install -y --no-install-recommends \
  apache2-dev=2.4.57-2 \
  build-essential=12.9 \
  cmake=3.25.1-1 \
  devscripts=2.23.4 \
  git=1:2.39.2-1.1 \
  libapache2-mod-tile=0.6.1-2 \
  libgd-perl=2.76-4+b1 \
  libipc-sharelite-perl=0.17-5 \
  libjson-perl=4.10000-1 \
  libmapnik-dev=3.1.0+ds-3+b1 \
  make=4.3-4.1 \
  tirex=0.7.0-3

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
