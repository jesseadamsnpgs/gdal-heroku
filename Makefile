default: heroku-16

heroku-16: dist/heroku-16/gdal-2.3.1-1.tar.gz dist/heroku-16/proj-5.1.0-1.tar.gz

dist/heroku-16/gdal-2.3.1-1.tar.gz: gdal-heroku-16
	docker cp $<:/tmp/gdal-heroku-16.tar.gz .
	mkdir dist
	mv gdal-heroku-16.tar.gz $@

dist/heroku-16/proj-5.1.0-1.tar.gz: gdal-heroku-16
	docker cp $<:/tmp/proj-heroku-16.tar.gz .
	mkdir dist
	mv proj-heroku-16.tar.gz $@

clean:
	rm -rf src/ heroku*/*.sh dist/ gdal-heroku*/*.tar.gz
	# -docker rm gdal-heroku
	-docker rm gdal-heroku-16

src/gdal.tar.gz:
	mkdir src
	curl -sL http://download.osgeo.org/gdal/2.3.1/gdal-2.3.1.tar.gz -o $@
	copy src/gdal.tar.gz gdal-heroku-16

src/proj-datumgrid.tar.gz:
	mkdir src
	curl -sL http://download.osgeo.org/proj/proj-datumgrid-1.8.tar.gz -o $@

src/proj.tar.gz:
	mkdir src
	curl -sL http://download.osgeo.org/proj/proj-5.1.0.tar.gz -o $@

.PHONY: heroku-16-stack

heroku-16-stack: heroku-16-stack/heroku-16-build.sh
	@(docker images -q npgs/$@ > /dev/null) || \
		docker build --rm -t npgs/$@ $@

heroku-16-stack/heroku-16-build.sh:
	curl -sLR https://raw.githubusercontent.com/heroku/stack-images/master/heroku-16-build/bin/heroku-16-build.sh -o $@

.PHONY: gdal-heroku-16

gdal-heroku-16: heroku-16-stack gdal-heroku-16/gdal.tar.gz gdal-heroku-16/proj-datumgrid.tar.gz gdal-heroku-16/proj.tar.gz
	docker build --rm -t npgs/$@ $@
	-docker rm $@
	docker run --name $@ npgs/$@ /bin/echo $@
