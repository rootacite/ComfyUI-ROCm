# amdfq

The HIP allocation interposer ComfyUI runs under here. It is the `vmm` hook from the Chromatrix
(AxlTrainer) repo's `amdfq/amdfq-vmm-rs/`, vendored so this checkout starts without that repo.

| Path | What |
| --- | --- |
| `lib/libamdfq_vmm_rs.so` | the object `../start_patched.sh` preloads |
| `amdfq-vmm-rs/` | its Rust source; rebuild with `cargo build --release --manifest-path amdfq-vmm-rs/Cargo.toml` and copy `amdfq-vmm-rs/target/release/libamdfq_vmm_rs.so` over `lib/` |

`start_patched.sh` exports the same knobs the trainer's `start_hook.sh` read from `[environment]` in
`config.toml` — `amdfq = "vmm"`, `amdfq_vram_reserve_gib = 0.128` (`AMDFQ_VRAM_RESERVE=137438953`),
`amdfq_va_never_reuse = false`, `amdfq_pool_mib = 0`. `AMDFQ_VA_STATUS` is left to the hook's default,
`$XDG_RUNTIME_DIR/axltrainer/amdfq_vmm_va.<pid>.json`. Design notes are in
[`amdfq-vmm-rs/DESIGN.md`](amdfq-vmm-rs/DESIGN.md).
