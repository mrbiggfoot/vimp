let g:ale_linters = {'cpp': ['cc']}
let g:ale_cpp_cc_executable = '/opt/cross/clang-6.0.1/bin/clang++'
let g:ale_cpp_cc_options = '
\ -fsyntax-only
\ -xc++
\ -I/home/andrew/projects/ltss/ltss_client
\ -I/home/andrew/projects/ltss/build/ltss_client
\ -I/home/andrew/projects/ltss/ltss_server
\ -I/home/andrew/projects/ltss/build/ltss_server
\ -I/home/andrew/projects/ltss
\ -isystem /home/andrew/projects/ltss/build
\ -isystem /home/andrew/projects/ltss/build/toolchain/include
\ -I/home/andrew/projects/ltss/build/ntnxdb_client
\ -I/home/andrew/projects/ltss/build/build/ntnxdb_client
\ -I/home/andrew/projects/ltss/build/ntnxdb_server
\ -I/home/andrew/projects/ltss/build/build/ntnxdb_server
\ -Wall
\ -Wextra
\ -Werror
\ -Wno-enum-compare
\ -Wno-ignored-qualifiers
\ -Wno-unused-parameter
\ -D_GNU_SOURCE
\ -D__STDC_FORMAT_MACROS
\ -DFUNCTION_REFLECTION
\ -DARENA_LSAN_LEVEL=1
\ -std=c++14
\ -Wno-invalid-offsetof
\ -fvisibility-inlines-hidden
\ -Wno-noexcept-type
\ -Wno-format
\ -fno-omit-frame-pointer
\ -gcc-toolchain /opt/cross/el7.5-x86_64/gcc-7.3.0
\ -B /opt/cross/el7.5-x86_64/gcc-7.3.0/bin
\ -target x86_64-redhat-linux
\ --sysroot /opt/cross/el7.5-x86_64/sysroot
\ -Qunused-arguments
\ -Wno-deprecated-register
\ -Wno-unused-local-typedef
\ -ftemplate-depth=512
\ -fno-color-diagnostics
\ '
