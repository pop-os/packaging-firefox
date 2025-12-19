# TESTING

This file provides a guideline for testing new releases of Firefox.

## Checklist

### 22.04

- [ ] Pop! theme applied (check header bar color) & follows dark/light mode
- [ ] All listed bug fixes for the new release affecting Linux are working correctly
- [ ] Setting > General > Firefox Updates setting is hidden, `app.update.auto` and `app.update.enabled` are set to `false`.
- [ ] Setting > Home > Firefox Home Content > Recommended stories unchecked by default
- [ ] Sync is working
- [ ] Videos services play YouTube, Netflix, Amazon, Vimeo, etc
    - [ ] Sound on video
    - [ ] Picture in picture
    - [ ] Subtitles in player, fullscreen , picture in picture
    - [ ] Keyboard shortcuts in player, fullscreen, picture in picture
- [ ] Files save to Downloads by default
- [ ] Image can be set as background
    - [ ] Dark mode
    - [ ] Light mode
- [ ] At least one language pack (`firefox-locale-xy`) can be installed

### 24.04

24.04 regression testing passed:

- [ ] COSMIC theme applied (check colors against libcosmic app) & follows dark/light mode
- [ ] All listed bug fixes for the new release affecting Linux are working correctly
- [ ] Setting > General > Firefox Updates setting is hidden, `app.update.auto` and `app.update.enabled` are set to `false`.
- [ ] Setting > Home > Firefox Home Content > Recommended stories unchecked by default
- [ ] Sync is working
- [ ] Videos services play YouTube, Netflix, Amazon, Vimeo, etc
    - [ ] Sound on video
    - [ ] Picture in picture
    - [ ] Subtitles in player, fullscreen , picture in picture
    - [ ] Keyboard shortcuts in player, fullscreen, picture in picture
- [ ] Files save to Downloads by default
- [ ] At least one language pack (`firefox-locale-xy`) can be installed
