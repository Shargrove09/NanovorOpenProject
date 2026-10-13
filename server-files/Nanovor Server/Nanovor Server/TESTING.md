# Testing the gameplay loop

Everything runs through one CLI: `node tools/dev.js <command>` (or the
double-clickable `dev-*.bat` shims). Account ids are derived from the username,
so every command takes a **name** — you never type `2072745562`.

## Quick start

```
dev-up.bat                       # server (waits until it answers) -> debuglog -> client
node tools/dev.js status         # what's running, which accounts exist
node tools/dev.js down           # graceful stop (saves every account first)
```

`up` starts the DebugLog viewer **before** the client on purpose: the client
broadcasts its internal narration over a LocalConnection once, and a viewer
started afterwards misses it.

## Accounts

| Account | Role |
|---|---|
| `n` | **test / throwaway** — reset it freely |
| anything else | **protected** — `reset`/`delete` refuse without `--force` |

A real progress account is created just by logging in with a new username (any
password). It's protected automatically.

```
node tools/dev.js account list
node tools/dev.js account id n                     # -> 2072745562
node tools/dev.js account snapshot n --as midgame  # bookmark a state
node tools/dev.js account reset n                  # back to the pristine baseline
node tools/dev.js account reset n --fresh          # brand-new-user flow (400 nanocash)
node tools/dev.js account reset n --from midgame   # restore a snapshot
```

**Reset works while the server is running** — it rebuilds the account in memory
*and* on disk. The client keeps its token but its cached UI is stale, so
**re-login (or relaunch) the client after a reset**.

> While the server runs, memory is authoritative and `UserData/*.json` is stale
> until a save. That's why these commands go through the server when it's up.
> Don't hand-edit `UserData/` with the server running — it overwrites on exit.

## Automated checks

```
node tools/dev.js smoke
```

Runs the offline suites (parsers, battle engine, corpus KAT) and, if the server
is up, the server-dependent ones against a throwaway account — never `n`.

## Manual gameplay-loop pass

Watch `server.log` and the DebugLog window as you go. **A request that never
appears in the log means the client decided not to make it** — that's usually the
real bug.

1. **Login** as `n`, any password. → home screen loads.
2. **Home tabs** are enabled (not greyed). → tabs come from `<Packages>` in the
   served `AppManifest.xml`; all-grey-but-NANOLOG means an empty/placeholder manifest.
3. **Collection / EvoTree** render. → a *blank screen with no log line* means a
   tree lacks a valid root nanovor (`TreeViewMenu` has logging compiled off).
4. **NanoMall**: open, buy a pack. → store must list SKUs (empty = wrapper element
   problem); purchase should play the open animation and the item must appear.
   The mall won't open at all if `GET /account/{id}` fails.
5. **Evolution**: run the puzzle. → wrong guess returns a hint (green/yellow),
   correct returns exactly `success`. EMs are consumed only on success, and
   evolving **resets the nanovor's stats to the new form's base**.
6. **Jolts**: Collection → a nanovor → Spend Jolts. → costs come from the
   `buff-formula-*` ladders and are steep (Electropod's first armor point is
   66,150), so a fresh jolt pool often can't afford anything — that's authentic.
7. **Nanoscope** (see below).
8. **Sensei battle**: runs entirely client-side and deliberately shows no rewards —
   nothing reaches the server.

## Nanoscope testing — read first

> ### Run this before the client ever sees a device
> ```
> node tools/nanoscope-cli.js preflight E: --account <id|name>
> ```
> It refuses (exit 2) unless the device is **backed up**, **imported**, and
> **registered to the account you are about to log in as**. Do not open the
> Nanoscope screen until it says `SAFE`.
>
> **Always pass `--account`.** The vault is per *device*, but registration is per
> *account* — a fully imported device can still be unregistered for a different
> account, and then the client shows the "+" prompt and wipes it. Without
> `--account` you only get `PARTIALLY SAFE` (exit 1), because that check wasn't run.
>
> **Syncing a scope to a NEW account** — `import` registers it, so the "+" prompt
> never appears:
> ```
> node tools/nanoscope-cli.js backup E:
> node tools/nanoscope-cli.js import E: --account <new-id>
> node tools/nanoscope-cli.js preflight E: --account <new-id>
> # only now log in as that account in the client
> ```
> You still use the client for the actual syncing (jolts, transfers) — `import` is
> a one-time prerequisite per (device, account), not a replacement for it.
>
> **If the client shows the Associate "+" prompt, the device is NOT imported — back
> out.** The prompt *is* the warning sign. Clicking "+" wipes `v1..v10` and every
> root file *before* the server is consulted; the sync then asks for a signed
> `plyinfo` we don't have, 404s, and leaves the device **unbootable** (its own
> firmware logs `can't find 'a:\ui.v3z'` to `elog.txt`). That happened on
> 2026-10-13 and cost a full restore-from-backup.
>
> **Never let the client see an `elog.txt`.** `DeviceErrorLogCheckChainLoadee`
> responds to it by deleting *every* file on the device and forcing a firmware
> push — worse than the fault it reports. Delete it first (it's hidden+system:
> `attrib -h -s E:\elog.txt` then `del E:\elog.txt`).
>
> Recovering a wiped device (no `deviceid.bbb`):
> ```
> node tools/nanoscope-cli.js import <backup> --account <id>   # vault first, from the BACKUP
> node tools/nanoscope-cli.js restore <backup> E: --bootstrap --yes
> node tools/nanoscope-cli.js verify <backup> E:
> ```

The client's sync is **destructive**.

- **Back up before anything**: `node tools/nanoscope-cli.js backup E:`
- **Never click the Associate "+"** on a device that has nanovor — it wipes
  `v1..v10` immediately.
- A transfer **deletes all ten slots first**, then fetches each nanovor; a failure
  partway leaves the device short (restore with `nanoscope-cli restore`).
- Keep the **1.38 unit client-untouched** (import/backup only). The **1.381** unit
  is the round-trip target.

```
node tools/nanoscope-cli.js backup E:
node tools/nanoscope-cli.js transferable --account 2072745562   # what's safe to pick
node tools/nanoscope-cli.js adopt --account 2072745562 --types 48
node tools/nanoscope-cli.js standins --account 2072745562       # stand-in -> real mapping
node tools/nanoscope-cli.js inspect E:
```

### The client's Sensei cartridge must match the device's (`SEC_VerifySystem`)

On every sync the client byte-compares *its* `Nanovor/Assets/device/s1/game.bin` with
the device's `s1/game.bin`. If they differ it wipes the device's `s1/` and writes its
own. The firmware rejects a cartridge it doesn't own: it deletes `game.bin`, logs
`SEC_VerifySystem: FAILED` to `elog.txt`, and **solo training is greyed out**. This
happened on 2026-10-13: the 1.381 unit's cartridge is `e7e134c5…` (the stock 1.381
package) but the client held `bbe576d1…`, left over from an earlier swap for the 1.38
unit. All 10 vinfos were intact when it fired.

Fixed by overlaying the 8 original files from `Assets/device/s1-v3.3-original/` onto
`Assets/device/s1/` (the old folder is kept as `s1-client-original`). `preflight`
now compares the two and refuses if they differ — **if you ever change the client's
`s1`, run it before the client touches a device.** Repair a damaged cartridge with
`restore <good-backup> E: --only s1 --yes`.

### What the server will and won't write to a device

A device **deletes any vinfo it won't accept**, after the write, leaving the slot with a
sprite and no vinfo. The nanovor then simply never appears on the handheld — it still
boots, with no popup and no `elog.txt`. (The handheld *crash* on 2026-10-13 was the Sensei
cartridge above; both things happened at once the first time, which is why they were
confused.)

What the 1.381 unit actually did with 20 distinct vinfos:

| id series | files | verdict |
|---|---|---|
| `157…` — the 9 the device supplied, plus 4 The List files (Gamma Fury, Electropod 3.0, Megadoom 1.0, Spike Spine 3.0) | 13 | **all kept** |
| `147…` — firmware dump `147384601`, The List `147415019` (Plasma Lash) | 2 | **both deleted** |
| 7-digit `4666…` — captured from the 1.38 unit | 5 | **all deleted** |

So **provenance isn't enough** — `147415019` is a The List file and was rejected. The id
series separates all 20 outcomes. We don't know *why* (an id block allotted per device? a
field in `plyinfo`?); it is a correlation on a small sample, so treat it as the best rule
so far. The server therefore only sends:

1. a vinfo **this device supplied** (proven accepted), or
2. a **The List** file whose id is in a **series the device already holds**.

Everything else gets a `409` — a clear "no" beats a nanovor that silently vanishes. A
device with an empty vault holds no series, so it is sent nothing from the corpus.

Transferring a leveled/evolved nanovor serves a same-species **stand-in**, preferring the
device's own copy, then a The List copy in a held series, and records the link in the
ledger. Your real instance's stats are never written to the device, so a round-trip can't
clobber them. `transferable` asks the same resolver a real transfer uses, so it can't
promise something the transfer would refuse. `import` drops ledger entries whose stand-in
isn't actually on the device, so the ledger follows what the scope really holds.

### One entry per nanovor

The client resolves each vinfo on the scope against your collection by id, so the
stand-in's id has to exist there. Minting it as a second entry doubled every nanovor
you sent (40 entries for 25 nanovor). Instead the **real instance is renamed to the scope
file's id** — one entry, every stat, nickname and date kept. The Nanoscope screen then
finds that one nanovor and pre-selects it with the Nanoscope icon, like the original game.
(The PC collection viewer has no "on Nanoscope" marker of its own; only the transfer
chooser does.)

- The old id keeps working for the rest of that client session (`previousAssetIds`).
- **The scope still shows the generic file's stats; the PC keeps the earned ones.** A device
  import never overwrites a folded nanovor's stats (`pcStats`).
- **Instances imported from a device are not renamed** — they carry that device's own signed
  id, and renaming would make the next import recreate them. So a nanovor that lives on two
  scopes (e.g. Megadoom on the 1.38 unit and the 1.381 unit) is two entries, one per scope.
- One scope copy per species (The List has one `157…` file per species). An **evolved** folded
  nanovor leaves the scope showing the old species until the next transfer.
- Tidy an account that already has the old duplicates (dry run unless `--yes`; take a
  snapshot first: `node tools/dev.js account snapshot n --as before`):
  `node tools/nanoscope-cli.js consolidate --account <id> [--remove id,id] [--root E:] --yes`.
  `--root E:` makes the server refuse to remove anything that is on the scope right now.

- Of The List's 96 species, 81 have a `157…` copy and can be sent to the 1.381 unit; 15
  (the `147…` and 7-digit ones) cannot.
- To experiment anyway: `NANOVOR_ALLOW_UNTRUSTED_CORPUS=1` lifts both the provenance and
  the series restriction. Only with a fresh backup, on a unit you can afford to restore;
  the server logs `[UNTESTED …]` for anything it sends that way.
- After any transfer, run `preflight`: a slot with a sprite but no `vinfo.bbb` that the
  last good backup had intact means the firmware rejected that nanovor. Put it back with
  `restore <good-backup> E: --only vN --yes`.
- `device-backups/<id>/<stamp>/DO-NOT-RESTORE.txt` marks a backup as evidence only;
  `restore` refuses it and `preflight` ignores it as "latest good".

## Gotchas worth remembering

- Restart the server after editing it — **nothing hot-reloads**. If a `/dev/...`
  route 404s, you're on a stale server.
- `/dev/*` routes and `/test-login/:username` are loopback-only and
  unauthenticated — delete before any public hosting.
- On Windows + Git Bash, `node -e "…"` with nested quotes often prints nothing —
  write a temp `.js` file instead.
