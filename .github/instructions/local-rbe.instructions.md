# Local RBE Quick Paths (Siso + NativeLink)

Use this file as the first stop when diagnosing local remote-execution issues in this repository.

## Check these files first

- `.vscode/tasks.json` - local launch tasks (including NativeLink Docker task).
- `native_link/basic_cas.json5` - NativeLink scheduler/worker/CAS setup.
- `README.md` - top-level setup commands used in this repo.
- `docs/siso-vs-reclient.md` - architecture notes for Siso vs reclient in this repo.
- `src/build/config/siso/mojo.star` - mojo remote rules (`remote_command`, `platform_ref`).
- `src/build/config/siso/backend_config/backend.star` - backend platform properties and local-backend behavior.
- `src/docs/linux/build_instructions.md` - Chromium-side remote execution setup for non-Google REAPI.
- `src/docs/siso_tips.md` - useful Siso flags (`--strict_remote`, `.sisorc`, verbosity).

## Fast triage rule

For ENOENT-style action failures (`No such file or directory`) during action start,
check worker runtime binaries first (for example, missing `python3`) before assuming CAS prefetch/input materialization issues.
