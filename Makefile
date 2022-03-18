# Manual variables
VERSION = 98.0.1
SHASUM  = 1621d6f08773bf1f0f7f654df0a3b77943ec03a2579c2fc718f532a3c78d3552

# Automatic variables
ARCH    = $(shell uname -m)
TARBALL = firefox-$(VERSION).tar.bz2
URL     = https://download-installer.cdn.mozilla.net/pub/firefox/releases/$(VERSION)/linux-$(ARCH)/en-US/$(TARBALL)

all:
	true

clean:
	true

distclean:
	rm -rf vendor*

install:
	tar --extract --file=vendor/$(TARBALL) --one-top-level=$(DESTDIR)/usr/lib/firefox --strip-components=1 --verbose

vendor:
	rm -f $@.partial $@
	curl --create-dirs -o $@.partial/$(TARBALL) $(URL)
	test $(SHASUM) "=" $$(sha256sum $@.partial/$(TARBALL) | cut -d' ' -f1)
	touch $@.partial
	mv -T $@.partial $@

.PHONY: all clean distclean install
