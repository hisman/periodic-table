COMPRESS=java -jar $(HOME)/lib/htmlcompressor-1.5.3.jar --compress-js --compress-css --remove-surrounding-spaces all -r -m '*.html' -o
MSI=msi/pt.kle.cz
VERSION=$(shell perl version.pl)

help:
	@echo "help         - this help"
	@echo "web          - generate pt.kle.cz"
	@echo "upload       - upload files on web"
	@echo "beta         - upload files on test web"
	@echo "msiprep      - prepare files for msi packages"
	@echo "pt.zip       - hosted app for Chrome store"
	@echo "xz           - xz archive"
	@echo "clean        - remove generated files"


web:
	cd po ; $(MAKE)
	./generate.pl --location https://pt.kl.cz --out www
	./sitemap.sh
	$(COMPRESS) www www

upload:
	./upload.sh

beta:
	./upload-beta.sh

xz:
	./generate.pl --out pt.kle.cz
	$(COMPRESS) pt.kle.cz pt.kle.cz
	tar Jcf www/pt.kle.cz.$(VERSION).tar.xz pt.kle.cz

msiprep:
	cd po ; $(MAKE)
	./generate.pl --out $(MSI)
	./msiprep.pl
	$(COMPRESS) $(MSI) $(MSI)

pt.zip: chrome/manifest.json
	zip -r pt.zip chrome

clean:
	rm -rf locale www msi/pt.kle.cz msi/build.bat msi/*.wxl msi/*.conf msi/components* msi/Makefile* msi/pt.kle.cz-*.wxs msi/shortcuts*.xsl msi/files*.xsl msi/*.msi msi/*.exe msi/files*.wxs msi/*.7z msi/*.wixpdb msi/*.wixobj pt.zip pt.kle.cz
