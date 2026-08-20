
export TORCH_BACKENDS_CUDNN_ENABLED=False

export HIP_TARGET="gfx1201"
export PYTORCH_ROCM_ARCH="gfx1201"
export TORCH_HIP_ARCH_LIST="gfx1201"
export HCC_AMDGPU_TARGET="gfx1201"
export PYTORCH_ROCM_ARCH="gfx1201"

export PYTORCH_HIP_ALLOC_CONF="garbage_collection_threshold:0.8,max_split_size_mb:512"

export TORCH_BLAS_PREFER_HIPBLASLT=0
export TORCHINDUCTOR_MAX_AUTOTUNE_GEMM_BACKENDS="CK,TRITON,ROCBLAS"
export TORCHINDUCTOR_MAX_AUTOTUNE_GEMM_SEARCH_SPACE="BEST"
export TORCHINDUCTOR_FORCE_FALLBACK=0

export FLASH_ATTENTION_TRITON_AMD_ENABLE="TRUE"
export FLASH_ATTENTION_BACKEND="flash_attn_triton_amd"
export FLASH_ATTENTION_TRITON_AMD_SEQ_LEN=4096
export USE_CK=ON
export TRANSFORMERS_USE_FLASH_ATTENTION=1
export TRITON_USE_ROCM=ON

export OMP_NUM_THREADS=8
export MKL_NUM_THREADS=8
export NUMEXPR_NUM_THREADS=8

export MIOPEN_FIND_MODE=2
export MIOPEN_ENABLE_CACHE=1

python main.py --highvram --preview-method auto --listen 0.0.0.0 --bf16-vae --enable-manager --force-channels-last --bf16-unet --use-pytorch-cross-attention --bf16-text-enc --enable-dynamic-vram
