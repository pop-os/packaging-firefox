# Automatic variables
VERSION = "$(shell grep -oP '(?<=firefox-).*(?=.tar.bz)' SHA256SUMS | head -1)"
ARCH    = "$(shell uname -m)"
TARBALL = "firefox-$(VERSION).tar.bz2"
URL     = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/$(VERSION)/linux-$(ARCH)"
all:
	true

clean:
	true

distclean:
	rm -rf vendor
	rm -f invalid_sha

install:
	tar \
		--extract \
		--file="vendor/$(TARBALL)" \
		--one-top-level="$(DESTDIR)/usr/lib/firefox" \
		--strip-components=1 \
		--verbose
	install -Dm0644 default-prefs.js $(DESTDIR)/usr/lib/firefox/defaults/pref/default-prefs.js
	install -Dm0644 is-packaged-app $(DESTDIR)/usr/lib/firefox/is-packaged-app
	install -Dm0644 policies.json $(DESTDIR)/usr/lib/firefox/distribution/policies.json

vendor:
	rm -rf "$@.partial" "$@"
	mkdir "$@.partial"
	rm -f invalid_sha

	curl \
		-o "$@.partial/$(TARBALL)" \
		"$(URL)/en-US/$(TARBALL)"
	test "$$(cat SHA256SUMS | grep linux-x86_64/en-US/firefox-$(VERSION).tar.bz | cut -d ' ' -f1)" "=" "$$(sha256sum $@.partial/$(TARBALL) | cut -d' ' -f1)"

	ls -1 langpacks | while read pkg_lang; do \
		cat "langpacks/$${pkg_lang}" | while read xpi_lang; do \
			curl \
				-o "$@.partial/langpack-$${xpi_lang}@firefox.mozilla.org.xpi" \
				"$(URL)/xpi/$${xpi_lang}.xpi"; \
			correct_shasum=$$(cat SHA256SUMS | grep linux-x86_64/.*/$${xpi_lang}.xpi | cut -d ' ' -f1); \
			download_shasum=$$(sha256sum $@.partial/langpack-$${xpi_lang}@firefox.mozilla.org.xpi | cut -d ' ' -f1); \
			echo "Verifying hash of downloaded locale '$$xpi_lang': $$download_shasum ?= $$correct_shasum"; \
			[ "$$correct_shasum" "=" "$$download_shasum" ] || echo "1" >> invalid_sha; \
		done; \
		if [ -e invalid_sha ]; then exit 1; fi; \
	done \

	touch "$@.partial"
	mv -T "$@.partial" "$@"

.PHONY: all clean distclean install
