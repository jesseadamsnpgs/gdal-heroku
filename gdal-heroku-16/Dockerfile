FROM heroku/heroku:16-build

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get upgrade -y

ADD ./proj.tar.gz /tmp
ADD ./proj-datumgrid.tar.gz /tmp/proj-5.1.0/nad/
RUN \
  cd /tmp/proj-* && \
  ./configure --without-mutex --prefix=/app/vendor/proj && \
  make install && \
  cd /app/vendor/proj && \
  tar zcf /tmp/proj-heroku-16.tar.gz .

ADD ./gdal.tar.gz /tmp
RUN \
  cd /tmp/gdal-* && \
  ./configure --prefix=/app/vendor/gdal \
              --with-static-proj4=/app/vendor/proj \
              --with-pcraster=no \
              --with-jasper=no \
              --with-grib=no \
              --with-vfk=no \
              --with-hide-internal-symbols && \
  make install && \
  cd /app/vendor/gdal && \
  tar zcf /tmp/gdal-heroku-16.tar.gz .
