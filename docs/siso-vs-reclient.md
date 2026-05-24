# Siso vs reclient: how Chromium interacts with remote build execution

## What is RBE

Remote Build Execution (RBE) is a protocol (REAPI) that allows individual
build actions (compiling a single file, linking, etc.) to be offloaded to
remote workers instead of running locally.
NativeLink is the RBE server implementation used in this repo.

---

## reclient / reproxy (legacy approach)

```plaintext
Ninja → reproxy (compiler wrapper) → RBE server (NativeLink)
  ↑              ↑
  local        local daemon that
  build runner intercepts compiler calls
```

- Ninja reads `build.ninja` and runs commands as usual
- reproxy runs as a local proxy daemon; a cc_wrapper redirects each compiler
  invocation through it
- reproxy packages the input files, sends the action to RBE, and returns the result
- Ninja is unaware of remote execution — reproxy just looks like a fast compiler to it

**Downsides:** two separate tools, complex integration, reproxy must be started
explicitly before the build.

---

## Siso (current approach, used here)

```plaintext
autoninja → Siso → RBE server (NativeLink)
               ↑
       single orchestrator:
       reads build.ninja,
       manages the dependency graph,
       sends actions directly via REAPI
```

- Siso fully replaces the Ninja + reclient combination
- It reads `build.ninja` itself, builds the dependency graph, and talks to RBE
  directly via REAPI
- No separate reproxy daemon is needed
- `autoninja` picks Siso automatically when it is available

**Advantages:** one tool instead of two, deeper integration with the build graph,
better control over what gets sent to remote execution.

---

## Platform properties in Siso

Siso tags each build action with a platform type defined in `.siso_config`
(the `platforms` section). This tells the RBE server what resources the action needs.

Chromium defines two types (from `out/Default/.siso_config`):

| Type | Property | Meaning |
|------|----------|---------|
| `default` | `label:action_default: "1"` | Regular actions (most compilations) |
| `large` | `label:action_large: "1"` | Heavy actions (linking, large translation units) |

NativeLink must be aware of these properties. They are listed in
`native_link/basic_cas.json5` under `supported_platform_properties` as `"ignore"`,
because the local worker is a single machine and does not differentiate by action size.

---

## Siso backend configuration

File: `src/build/config/siso/backend_config/backend.star`

Defines which RBE properties (`container-image`, `OSFamily`, etc.) Siso attaches
to actions when sending them to a specific backend.
A starting template is provided in `template.star` in the same directory.
