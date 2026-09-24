# evoke-visual-workplace

[![verify](https://github.com/SNAPKITTYAGENT9NOVA/evoke-visual-workplace/actions/workflows/verify.yml/badge.svg)](https://github.com/SNAPKITTYAGENT9NOVA/evoke-visual-workplace/actions/workflows/verify.yml)

Portable **offline** build of the Visual Workplace: ColorForth vocabulary,
an Open Dylan–style library, and the Evoke BEAM (Elixir/OTP) agent mesh.
Zero network. No HTTP server. Raw code is the product.

Delivered as `evoke-visual-workplace-raw.zip` on 2026-09-23. This repository
is that tree, verbatim, plus this README.

## Quick start

```bash
./evoke
```

Copies/assembles sources into `build/out/`, writes `MANIFEST.txt`,
`colorforth/WORKPLACE.CF`, the Dylan library, `beam/`, `bridge-map.json`,
and the standalone HTML viewer. Exit 0 on success. Verified: a fresh
`./evoke` run reproduces the shipped `build/out/` byte-for-byte.

## Verify

```bash
make verify
```

Runs `./evoke`, the DYLN frame smoke test, then re-runs the build and diffs
`build/out/` to prove the output is reproducible byte-for-byte. CI runs the
same checks on every push to `main`.

## Layout

```
evoke-visual-workplace/
├── README.md              ← this file
├── RAW.md                 ← full build notes (colors, Dylan, BEAM, bridge)
├── evoke                  ← build script (bash, offline)
├── raw/                   ← the product
│   ├── colorforth/        ← .cf vocabulary (00-boot … 05-screen-termux-agent,
│   │                        blocks.cf, WORKPLACE.CF stream)
│   ├── dylan/             ← Open Dylan–style library (visual-workplace.lid,
│   │                        library/module/events/ui/app/evoke-bridge/evoke-build)
│   ├── beam/              ← Evoke BEAM mesh (Elixir/OTP: agent_node,
│   │                        backpressure, dylan_protocol, workplace_bridge, …)
│   └── bridge-map.template.json  ← ColorForth ↔ Dylan ↔ BEAM map
├── scripts/
│   ├── embed_standalone.py
│   └── frame_smoke.py     ← pure-Python DYLN encode/decode smoke (no Elixir needed)
├── optional/preview/      ← HTML preview inlined into the standalone build
└── build/out/             ← filled by ./evoke (do not hand-edit; re-run evoke)
```

## Toolchains

| Stack | Build / check |
|---|---|
| ColorForth | Load `build/out/colorforth/WORKPLACE.CF` on a CF machine |
| Dylan | `cd build/out/dylan && dylan-compiler -build visual-workplace.lid` |
| BEAM | `cd build/out/beam && mix test` (Elixir ~> 1.16 + OTP, zero Hex deps) |
| Smoke (no Elixir) | `python3 scripts/frame_smoke.py` |

Real Termux / gcc / kernel are **not** included — command and syscall traces
are simulated/didactic, as labeled in the preview.

## Bridge

`build/out/bridge-map.json` triples ColorForth words ↔ Dylan methods ↔ BEAM
modules, e.g. `do-gcc` ↔ `compile-c!` ↔ `Evoke.WorkplaceBridge.fan_event(:compile_c)`.
UI events ride the mesh as DYLN frames (`magic "DYLN"`, opcodes `0x01`–`0x07`,
CRC32-IEEE) — see `raw/dylan/evoke-bridge.dylan` and `RAW.md`.
