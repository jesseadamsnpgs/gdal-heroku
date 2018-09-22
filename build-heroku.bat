mkdir src
mkdir dist
mkdir dist\heroku-16
curl -sL http://download.osgeo.org/gdal/2.3.1/gdal-2.3.1.tar.gz -o src\gdal.tar.gz
curl -sL http://download.osgeo.org/proj/proj-datumgrid-1.8.tar.gz -o src\proj-datumgrid.tar.gz
curl -sL http://download.osgeo.org/proj/proj-5.1.0.tar.gz -o src\proj.tar.gz
copy src\gdal.tar.gz gdal-heroku-16\gdal.tar.gz
copy src\proj-datumgrid.tar.gz gdal-heroku-16\proj-datumgrid.tar.gz
copy src\proj.tar.gz gdal-heroku-16\proj.tar.gz
curl -sLR https://raw.githubusercontent.com/heroku/stack-images/master/heroku-16-build/bin/heroku-16-build.sh -o heroku-16-stack\heroku-16-build.sh
docker build --rm -t npgs/gdal-heroku-16 gdal-heroku-16
docker run --name gdal-heroku-16 npgs/gdal-heroku-16 /bin/echo gdal-heroku-16
docker cp gdal-heroku-16:/tmp/gdal-heroku-16.tar.gz dist\heroku-16\gdal-2.3.1-1.tar.gz
docker cp gdal-heroku-16:/tmp/proj-heroku-16.tar.gz dist\heroku-16\proj-5.1.0-1.tar.gz
