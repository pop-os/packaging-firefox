#!/usr/bin/env bash

set -e

if [ ! -d langpacks ]
then
    rm -rf langpacks.partial langpacks
    mkdir langpacks.partial

    apt-file search /usr/lib/firefox-addons/extensions |
    grep "^firefox-locale-" |
    sort |
    while read line
    do
        pkg="$(echo "$line" | cut -d':' -f1)"
        pkg_lang="$(echo "$pkg" | cut -d'-' -f3-)"
        xpi="$(echo "$line" | cut -d' ' -f2-)"
        xpi_lang="$(basename "${xpi}" | cut -d'-' -f2- | cut -d'@' -f1)"
        echo "${xpi_lang}" >> "langpacks.partial/${pkg_lang}"
    done

    mv -T langpacks.partial langpacks
fi

cp debian/control.in debian/control
rm -f debian/firefox-locale-*.install

ls -1 langpacks | while read pkg_lang
do
    cat >> debian/control <<EOF

Package: firefox-locale-${pkg_lang}
Architecture: amd64 arm64
Depends: firefox (= \${binary:Version})
Replaces: language-pack-${pkg_lang}-base
Description: Mozilla Firefox language pack for ${pkg_lang}
EOF

    cat "langpacks/${pkg_lang}" | while read xpi_lang
    do
        echo \
            "usr/lib/firefox/distribution/extensions/langpack-${xpi_lang}@firefox.mozilla.org.xpi" \
            >> "debian/firefox-locale-${pkg_lang}.install"
    done
done
