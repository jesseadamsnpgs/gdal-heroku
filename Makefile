default: heroku-16

# heroku: dist/heroku/gdal-2.3.1-1.tar.gz dist/heroku/proj-4.8.0-1.tar.gz

heroku-16: dist/heroku-16/gdal-2.3.1-1.tar.gz dist/heroku-16/proj-5.1.0-1.tar.gz

# dist/heroku/gdal-2.3.1-1.tar.gz: gdal-heroku
# 	docker cp $<:/tmp/gdal-heroku.tar.gz .
# 	mkdir -p $$(dirname $@)
# 	mv gdal-heroku.tar.gz $@
#
# dist/heroku/proj-4.8.0-1.tar.gz: gdal-heroku
# 	docker cp $<:/tmp/proj-heroku.tar.gz .
# 	mkdir -p $$(dirname $@)
# 	mv proj-heroku.tar.gz $@

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

# .PHONY: heroku-stack

# heroku-stack: heroku-stack/heroku.sh
# 	@(docker images -q npgs/$@ | wc -l | grep 1 > /dev/null) || \
# 		docker build --rm -t npgs/$@ $@
#
# heroku-stack/heroku.sh:
# 	curl -sLR https://raw.githubusercontent.com/heroku/stack-images/master/bin/heroku.sh -o $@

.PHONY: heroku-16-stack

heroku-16-stack: heroku-16-stack/heroku-16.sh
	@(docker images -q npgs/$@ > /dev/null) || \
		docker build --rm -t npgs/$@ $@

heroku-16-stack/heroku-16.sh:
	curl -sLR https://raw.githubusercontent.com/heroku/stack-images/master/heroku-16-build/bin/heroku-16-build.sh -o $@

# .PHONY: gdal-heroku
#
# gdal-heroku: heroku-stack gdal-heroku/gdal.tar.gz gdal-heroku/proj-datumgrid.tar.gz gdal-heroku/proj.tar.gz
# 	docker build --rm -t npgs/$@ $@
# 	-docker rm $@
# 	docker run --name $@ npgs/$@ /bin/echo $@
#
# gdal-heroku/gdal.tar.gz: src/gdal.tar.gz
# 	ln -f $< $@
#
# gdal-heroku/proj-datumgrid.tar.gz: src/proj-datumgrid.tar.gz
# 	ln -f $< $@
#
# gdal-heroku/proj.tar.gz: src/proj.tar.gz
# 	ln -f $< $@

.PHONY: gdal-heroku-16

gdal-heroku-16: heroku-16-stack gdal-heroku-16/gdal.tar.gz gdal-heroku-16/proj-datumgrid.tar.gz gdal-heroku-16/proj.tar.gz
	docker build --rm -t npgs/$@ $@
	-docker rm $@
	docker run --name $@ npgs/$@ /bin/echo $@

# gdal-heroku-16/gdal.tar.gz: src/gdal.tar.gz
# 	copy -f $< $@
#
# gdal-heroku-16/proj-datumgrid.tar.gz: src/proj-datumgrid.tar.gz
# 	copy -f $< $@
#
# gdal-heroku-16/proj.tar.gz: src/proj.tar.gz
# 	copy -f $< $@
