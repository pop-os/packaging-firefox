# Manual variables
VERSION = "108.0.2"
SHASUM  = "d283f522ec219ac78b66909f3c12431ecdbb4fc8ff5c1250e2e6f057b6482e23"

# Automatic variables
ARCH    = "$(shell uname -m)"
TARBALL = "firefox-$(VERSION).tar.bz2"
URL     = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/$(VERSION)/linux-$(ARCH)"

all:
	true

clean:
	true

distclean:
	rm -rf vendor

install:
	tar \
		--extract \
		--file="vendor/$(TARBALL)" \
		--one-top-level="$(DESTDIR)/usr/lib/firefox" \
		--strip-components=1 \
		--verbose
	install -Dm0644 default-prefs.js $(DESTDIR)/usr/lib/firefox/defaults/pref/default-prefs.js
	install -Dm0644 policies.json $(DESTDIR)/usr/lib/firefox/distribution/policies.json

vendor:
	rm -rf "$@.partial" "$@"
	mkdir "$@.partial"

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
