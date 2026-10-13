# `xsd/` — reconstructed schemas (REFERENCE ONLY, NOT AUTHORITATIVE)

These XSDs are a **reverse-engineered map** of the bankfe / device / evolution XML
messages. They are documentation, nothing more:

- **Nothing reads, serves, or validates against them at runtime.** The server builds
  and parses XML by hand; the one `/xsd/...` route in `NanoServ.js` serves an inline
  string, not a file from this folder. The `xmlns="http://smithandtinker.com/.../*.xsd"`
  labels in responses are just namespace strings the client strips — never fetched.
- **The real spec is the decompiled AS3 client** (`../Decompiled Client SWF/`) and the
  **live server**. When an `.xsd` here disagrees with the AS3, the **AS3 wins**.
- **Some of these are known to be WRONG** — do not trust them blindly:
  - `device-manifest/device-manifest.xsd` — describes a *different* document than the
    client actually parses (the client wants `<firmware-version>` + flat `<file>` /
    `<minigame-file>` lists).
  - `retail/*` and `evolution/evolution-list.xsd` — inaccurate.

**Don't maintain or expand these.** They're disposable reference; verify any shape
against the AS3 or a live request before relying on it.
