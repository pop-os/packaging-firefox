# Manual variables
VERSION = "102.0"
VERSION_DEB = "102.0-1"
SHASUM  = "2673d387d22ae6e21c20f091dc4811197aaa516110d44133e4d14c91d5568f87"
SHASUM_ARM64 = "4d03d5e1cb58f7d4247c144ae693900a521cb9b8284ce0c388042d71c7862507"

# Automatic variables
ARCH    = "$(shell uname -m)"
TARBALL = "firefox-$(VERSION).tar.bz2"
DEB     = "firefox_$(VERSION_DEB)_arm64.deb"
URL     = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/$(VERSION)/linux-$(ARCH)"
DEB_URL = "http://ftp.us.debian.org/debian/pool/main/f/firefox/$(DEB)"

all:
	true

clean:
	true

distclean:
	rm -rf vendor

install:
	# test "x86_64" = "$(ARCH)" && make install_tarball || make install_deb
	make install_deb
	install -Dm0644 default-prefs.js $(DESTDIR)/usr/lib/firefox/defaults/pref/default-prefs.js
	install -Dm0644 policies.json $(DESTDIR)/usr/lib/firefox/distribution/policies.json

install_tarball:
	tar \
		--extract \
		--file="vendor/$(TARBALL)" \
		--one-top-level="$(DESTDIR)/usr/lib/firefox" \
		--strip-components=1 \
		--verbose

install_deb:
	dpkg-deb -x "vendor/$(DEB)" .

vendor:
	rm -rf "$@.partial" "$@"
	mkdir "$@.partial"

	curl -o "$@.partial/$(DEB)" "$(DEB_URL)"
	test "$(SHASUM_ARM64)" = "$$(sha256sum $@.partial/$(DEB) | cut -d' ' -f1)"

	curl \
		-o "$@.partial/$(TARBALL)" \
		"$(URL)/en-US/$(TARBALL)"
	test "$(SHASUM)" "=" "$$(sha256sum $@.partial/$(TARBALL) | cut -d' ' -f1)"

	ls -1 langpacks | while read pkg_lang; do \
		cat "langpacks/$${pkg_lang}" | while read xpi_lang; do \
			curl \
				-o "$@.partial/langpack-$${xpi_lang}@firefox.mozilla.org.xpi" \
				"$(URL)/xpi/$${xpi_lang}.xpi"; \
		done \
	done

	touch "$@.partial"
	mv -T "$@.partial" "$@"

.PHONY: all clean distclean install
