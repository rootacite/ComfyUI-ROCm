#!/usr/bin/env bash
#
# Starts ComfyUI with the amdfq VMM hook in amdfq/ preloaded, inside the comfy_ui conda env.
#
#   ./start_patched.sh                        # hook quiet (AMDFQ_LOG_LEVEL=off), start.sh as usual
#   AMDFQ_LOG_LEVEL=info ./start_patched.sh   # keep the hook's per-call lines on stderr
#
# Replaces the hand-rolled command this checkout used before:
#
#   cd ~/Deeppin/AxlTrainer && conda activate comfy_ui && export AMDFQ_LOG_LEVEL=off \
#       && ./start_hook.sh --workd "$HOME/comfyui/" "$HOME/comfyui/start.sh"
#
# with the knobs that command read from the trainer's config.toml: amdfq = "vmm",
# amdfq_vram_reserve_gib = 0.128, amdfq_va_never_reuse = false, amdfq_pool_mib = 0.
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
hook=$root/amdfq/lib/libamdfq_vmm_rs.so

if [[ ! -f $hook ]]; then
    echo "start_patched.sh: hook library missing: $hook" >&2
    echo "start_patched.sh: build it with: cargo build --release --manifest-path $root/amdfq/amdfq-vmm-rs/Cargo.toml" >&2
    exit 1
fi

# start.sh runs a bare `python`, so the comfy_ui env has to be active when it starts.
conda_bin=${CONDA_EXE:-}
if [[ -z $conda_bin ]]; then
    conda_bin=$(command -v conda || true)
fi
if [[ -z $conda_bin ]]; then
    for candidate in "$HOME/miniconda3/bin/conda" "$HOME/anaconda3/bin/conda" /opt/conda/bin/conda; do
        if [[ -x $candidate ]]; then
            conda_bin=$candidate
            break
        fi
    done
fi
if [[ -z $conda_bin ]]; then
    echo "start_patched.sh: conda not found; activate the comfy_ui environment yourself" >&2
    exit 1
fi
eval "$("$conda_bin" shell.bash hook)"
conda activate comfy_ui

export AMDFQ_LOG_LEVEL=${AMDFQ_LOG_LEVEL:-off}
export AMDFQ_VRAM_RESERVE=137438953 # amdfq_vram_reserve_gib = 0.128
export AMDFQ_VA_NEVER_REUSE=0       # amdfq_va_never_reuse = false
export AMDFQ_POOL_SIZE=0            # amdfq_pool_mib = 0

if [[ -n ${LD_PRELOAD:-} ]]; then
    export LD_PRELOAD="$hook:$LD_PRELOAD"
else
    export LD_PRELOAD="$hook"
fi

cd "$root"
echo "start_patched.sh: hook=$hook level=$AMDFQ_LOG_LEVEL reserve=$AMDFQ_VRAM_RESERVE never_reuse=$AMDFQ_VA_NEVER_REUSE pool=$AMDFQ_POOL_SIZE" >&2
exec bash start.sh
