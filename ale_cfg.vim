let g:ale_linters = {'cpp': ['clang']}
let g:ale_cpp_clang_executable = '/opt/cross/clang-6.0.1/bin/clang++'
let g:ale_cpp_clang_options = '
\ -fsyntax-only
\ -xc++
\ -I/home/andrew/projects/main
\ -isystem /home/andrew/projects/main/build
\ -isystem /home/andrew/projects/main/build/toolchain/include
\ -I/home/andrew/projects/main/rocksdb/include
\ -I/home/andrew/projects/main/rocksdb
\ -Wall
\ -Wextra
\ -Werror
\ -Wno-enum-compare
\ -Wno-ignored-qualifiers
\ -Wno-unused-parameter
\ -D_GNU_SOURCE
\ -D__STDC_FORMAT_MACROS
\ -march=nehalem
\ -mtune=haswell
\ -DFUNCTION_REFLECTION
\ -DARENA_LSAN_LEVEL=1
\ -std=c++14
\ -Wno-invalid-offsetof
\ -fvisibility-inlines-hidden
\ -Wno-noexcept-type
\ -Wno-format
\ -gcc-toolchain /opt/cross/el7.5-x86_64/gcc-7.3.0
\ -B /opt/cross/el7.5-x86_64/gcc-7.3.0/bin
\ -target x86_64-redhat-linux
\ --sysroot /opt/cross/el7.5-x86_64/sysroot
\ -Qunused-arguments
\ -Wno-deprecated-register
\ -Wno-unused-local-typedef
\ -ftemplate-depth=512
\ '
