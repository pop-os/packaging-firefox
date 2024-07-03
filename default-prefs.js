// Copyright 2022 System76 <info@system76.com>
// SPDX-License-Identifier: MPL-2.0

pref("app.update.auto", false, locked);
pref("app.update.enabled", false, locked);
pref("dom.ipc.forkserver.enable", true);

// This setting allows the desktop environment to define its own file picker
pref("widget.use-xdg-desktop-portal.file-picker", 1);
