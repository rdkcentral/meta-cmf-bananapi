# Ensure Rust and Cargo are available
inherit cargo

DESCRIPTION = "IEEE 1905 Rust Program"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b538373fe584898492d2ad3a91014d58"

# Source repository
SRC_URI = "git://git@github.com/rdkcentral/rdkb-ieee1905.git;branch=main;protocol=ssh"
SRCREV = "3b14c3cc1226bad84aca1d530cfb5b2e355def00"

# Source directory
S = "${WORKDIR}/git"

# IMPORTANT!
#RUST_PANIC_STRATEGY="abort" must be in the
# machine or bitbake local.conf for this
# package to build successfully
# Set Rust flags for panic=abort strategy
# Builds under bitbake do not have network
# access, so all dependent rust crates
# must be added as SRC_URI
# You can use cargo-bitbake to create this list
#

SRC_URI += " \
    crate://crates.io/addr2line/0.24.2 \
    crate://crates.io/adler2/2.0.0 \
    crate://crates.io/aho-corasick/1.1.3 \
    crate://crates.io/anyhow/1.0.97 \
    crate://crates.io/async-stream/0.3.6 \
    crate://crates.io/async-stream-impl/0.3.6 \
    crate://crates.io/async-trait/0.1.88 \
    crate://crates.io/atomic-waker/1.1.2 \
    crate://crates.io/autocfg/1.4.0 \
    crate://crates.io/axum/0.7.9 \
    crate://crates.io/axum-core/0.4.5 \
    crate://crates.io/backtrace/0.3.74 \
    crate://crates.io/base64/0.21.7 \
    crate://crates.io/base64/0.22.1 \
    crate://crates.io/bitflags/1.3.2 \
    crate://crates.io/bitflags/2.9.0 \
    crate://crates.io/byteorder/1.5.0 \
    crate://crates.io/bytes/1.10.1 \
    crate://crates.io/cassowary/0.3.0 \
    crate://crates.io/cfg-if/1.0.0 \
    crate://crates.io/console-api/0.8.1 \
    crate://crates.io/console-subscriber/0.4.1 \
    crate://crates.io/core-foundation/0.9.4 \
    crate://crates.io/core-foundation-sys/0.8.7 \
    crate://crates.io/crc32fast/1.4.2 \
    crate://crates.io/crossbeam-channel/0.5.14 \
    crate://crates.io/crossbeam-utils/0.8.21 \
    crate://crates.io/crossterm/0.25.0 \
    crate://crates.io/crossterm/0.28.1 \
    crate://crates.io/crossterm_winapi/0.9.1 \
    crate://crates.io/dlopen2/0.5.0 \
    crate://crates.io/either/1.15.0 \
    crate://crates.io/equivalent/1.0.2 \
    crate://crates.io/errno/0.3.10 \
    crate://crates.io/eyre/0.6.12 \
    crate://crates.io/flate2/1.1.0 \
    crate://crates.io/fnv/1.0.7 \
    crate://crates.io/futures/0.3.31 \
    crate://crates.io/futures-channel/0.3.31 \
    crate://crates.io/futures-core/0.3.31 \
    crate://crates.io/futures-executor/0.3.31 \
    crate://crates.io/futures-io/0.3.31 \
    crate://crates.io/futures-macro/0.3.31 \
    crate://crates.io/futures-sink/0.3.31 \
    crate://crates.io/futures-task/0.3.31 \
    crate://crates.io/futures-util/0.3.31 \
    crate://crates.io/getrandom/0.2.15 \
    crate://crates.io/gimli/0.31.1 \
    crate://crates.io/glob/0.3.2 \
    crate://crates.io/h2/0.4.8 \
    crate://crates.io/hashbrown/0.12.3 \
    crate://crates.io/hashbrown/0.15.2 \
    crate://crates.io/hdrhistogram/7.5.4 \
    crate://crates.io/http/1.3.1 \
    crate://crates.io/http-body/1.0.1 \
    crate://crates.io/http-body-util/0.1.3 \
    crate://crates.io/httparse/1.10.1 \
    crate://crates.io/httpdate/1.0.3 \
    crate://crates.io/humantime/2.2.0 \
    crate://crates.io/hyper/1.6.0 \
    crate://crates.io/hyper-timeout/0.5.2 \
    crate://crates.io/hyper-util/0.1.11 \
    crate://crates.io/indenter/0.3.3 \
    crate://crates.io/indexmap/1.9.3 \
    crate://crates.io/indexmap/2.8.0 \
    crate://crates.io/ipnet/2.11.0 \
    crate://crates.io/ipnetwork/0.20.0 \
    crate://crates.io/itertools/0.14.0 \
    crate://crates.io/itoa/1.0.15 \
    crate://crates.io/lazy_static/1.5.0 \
    crate://crates.io/libc/0.2.171 \
    crate://crates.io/linux-raw-sys/0.4.15 \
    crate://crates.io/lock_api/0.4.12 \
    crate://crates.io/log/0.4.27 \
    crate://crates.io/matchers/0.1.0 \
    crate://crates.io/matchit/0.7.3 \
    crate://crates.io/memchr/2.7.4 \
    crate://crates.io/mime/0.3.17 \
    crate://crates.io/minimal-lexical/0.2.1 \
    crate://crates.io/miniz_oxide/0.8.5 \
    crate://crates.io/mio/0.8.11 \
    crate://crates.io/mio/1.0.3 \
    crate://crates.io/netdev/0.33.0 \
    crate://crates.io/netlink-packet-core/0.7.0 \
    crate://crates.io/netlink-packet-route/0.21.0 \
    crate://crates.io/netlink-packet-utils/0.5.2 \
    crate://crates.io/netlink-sys/0.8.7 \
    crate://crates.io/no-std-net/0.6.0 \
    crate://crates.io/nom/7.1.3 \
    crate://crates.io/nom/8.0.0 \
    crate://crates.io/nu-ansi-term/0.46.0 \
    crate://crates.io/num-traits/0.2.19 \
    crate://crates.io/object/0.36.7 \
    crate://crates.io/once_cell/1.21.3 \
    crate://crates.io/overload/0.1.1 \
    crate://crates.io/parking_lot/0.12.3 \
    crate://crates.io/parking_lot_core/0.9.10 \
    crate://crates.io/paste/1.0.15 \
    crate://crates.io/percent-encoding/2.3.1 \
    crate://crates.io/pin-project/1.1.10 \
    crate://crates.io/pin-project-internal/1.1.10 \
    crate://crates.io/pin-project-lite/0.2.16 \
    crate://crates.io/pin-utils/0.1.0 \
    crate://crates.io/pnet/0.35.0 \
    crate://crates.io/pnet_base/0.35.0 \
    crate://crates.io/pnet_datalink/0.35.0 \
    crate://crates.io/pnet_macros/0.35.0 \
    crate://crates.io/pnet_macros_support/0.35.0 \
    crate://crates.io/pnet_packet/0.35.0 \
    crate://crates.io/pnet_sys/0.35.0 \
    crate://crates.io/pnet_transport/0.35.0 \
    crate://crates.io/ppv-lite86/0.2.21 \
    crate://crates.io/proc-macro2/1.0.94 \
    crate://crates.io/prost/0.13.5 \
    crate://crates.io/prost-derive/0.13.5 \
    crate://crates.io/prost-types/0.13.5 \
    crate://crates.io/quote/1.0.40 \
    crate://crates.io/rand/0.8.5 \
    crate://crates.io/rand_chacha/0.3.1 \
    crate://crates.io/rand_core/0.6.4 \
    crate://crates.io/redox_syscall/0.5.10 \
    crate://crates.io/regex/1.11.1 \
    crate://crates.io/regex-automata/0.1.10 \
    crate://crates.io/regex-automata/0.4.9 \
    crate://crates.io/regex-syntax/0.6.29 \
    crate://crates.io/regex-syntax/0.8.5 \
    crate://crates.io/rustc-demangle/0.1.24 \
    crate://crates.io/rustix/0.38.44 \
    crate://crates.io/rustversion/1.0.20 \
    crate://crates.io/ryu/1.0.20 \
    crate://crates.io/scopeguard/1.2.0 \
    crate://crates.io/serde/1.0.219 \
    crate://crates.io/serde_derive/1.0.219 \
    crate://crates.io/serde_json/1.0.140 \
    crate://crates.io/sharded-slab/0.1.7 \
    crate://crates.io/signal-hook/0.3.17 \
    crate://crates.io/signal-hook-mio/0.2.4 \
    crate://crates.io/signal-hook-registry/1.4.2 \
    crate://crates.io/slab/0.4.9 \
    crate://crates.io/smallvec/1.14.0 \
    crate://crates.io/socket2/0.5.9 \
    crate://crates.io/syn/2.0.100 \
    crate://crates.io/sync_wrapper/1.0.2 \
    crate://crates.io/system-configuration/0.6.1 \
    crate://crates.io/system-configuration-sys/0.6.0 \
    crate://crates.io/thiserror/1.0.69 \
    crate://crates.io/thiserror-impl/1.0.69 \
    crate://crates.io/thread_local/1.1.8 \
    crate://crates.io/tokio/1.44.1 \
    crate://crates.io/tokio-macros/2.5.0 \
    crate://crates.io/tokio-stream/0.1.17 \
    crate://crates.io/tokio-tasker/1.2.0 \
    crate://crates.io/tokio-util/0.7.14 \
    crate://crates.io/tonic/0.12.3 \
    crate://crates.io/tower/0.4.13 \
    crate://crates.io/tower/0.5.2 \
    crate://crates.io/tower-layer/0.3.3 \
    crate://crates.io/tower-service/0.3.3 \
    crate://crates.io/tracing/0.1.41 \
    crate://crates.io/tracing-attributes/0.1.28 \
    crate://crates.io/tracing-core/0.1.33 \
    crate://crates.io/tracing-log/0.2.0 \
    crate://crates.io/tracing-subscriber/0.3.19 \
    crate://crates.io/try-lock/0.2.5 \
    crate://crates.io/tui/0.19.0 \
    crate://crates.io/unicode-ident/1.0.18 \
    crate://crates.io/unicode-segmentation/1.12.0 \
    crate://crates.io/unicode-width/0.1.14 \
    crate://crates.io/valuable/0.1.1 \
    crate://crates.io/want/0.3.1 \
    crate://crates.io/wasi/0.11.0+wasi-snapshot-preview1 \
    crate://crates.io/winapi/0.3.9 \
    crate://crates.io/winapi-i686-pc-windows-gnu/0.4.0 \
    crate://crates.io/winapi-x86_64-pc-windows-gnu/0.4.0 \
    crate://crates.io/windows-sys/0.48.0 \
    crate://crates.io/windows-sys/0.52.0 \
    crate://crates.io/windows-sys/0.59.0 \
    crate://crates.io/windows-targets/0.48.5 \
    crate://crates.io/windows-targets/0.52.6 \
    crate://crates.io/windows_aarch64_gnullvm/0.48.5 \
    crate://crates.io/windows_aarch64_gnullvm/0.52.6 \
    crate://crates.io/windows_aarch64_msvc/0.48.5 \
    crate://crates.io/windows_aarch64_msvc/0.52.6 \
    crate://crates.io/windows_i686_gnu/0.48.5 \
    crate://crates.io/windows_i686_gnu/0.52.6 \
    crate://crates.io/windows_i686_gnullvm/0.52.6 \
    crate://crates.io/windows_i686_msvc/0.48.5 \
    crate://crates.io/windows_i686_msvc/0.52.6 \
    crate://crates.io/windows_x86_64_gnu/0.48.5 \
    crate://crates.io/windows_x86_64_gnu/0.52.6 \
    crate://crates.io/windows_x86_64_gnullvm/0.48.5 \
    crate://crates.io/windows_x86_64_gnullvm/0.52.6 \
    crate://crates.io/windows_x86_64_msvc/0.48.5 \
    crate://crates.io/windows_x86_64_msvc/0.52.6 \
    crate://crates.io/zerocopy/0.8.24 \
    crate://crates.io/zerocopy-derive/0.8.24 \
"
