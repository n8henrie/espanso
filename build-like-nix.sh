#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash --pure
#!nix-shell -p iconv
#!nix-shell -p cargo
#!nix-shell -p darwin.apple_sdk.frameworks.Foundation
#!nix-shell -p darwin.apple_sdk.frameworks.AppKit
#!nix-shell -p darwin.apple_sdk.frameworks.Cocoa
#!nix-shell -p darwin.apple_sdk.frameworks.IOKit
#!nix-shell -p wxGTK32
#!nix-shell -p nix

# RUSTFLAGS="-Lnative=/nix/store/plv8jh3miapq1mxsm9zxvqcmjg2gdfgc-wxwidgets-3.1.7/lib -ldylib=wx_osx_cocoau_xrc-3.1" \
main() {
  env \
    CC_AARCH64_APPLE_DARWIN=/nix/store/s7lwib0lr80bqq0k43vd1ihr63yc6yql-clang-wrapper-16.0.6/bin/cc \
    CXX_AARCH64_APPLE_DARWIN=/nix/store/s7lwib0lr80bqq0k43vd1ihr63yc6yql-clang-wrapper-16.0.6/bin/c++ \
    CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER=/nix/store/s7lwib0lr80bqq0k43vd1ihr63yc6yql-clang-wrapper-16.0.6/bin/cc \
    CC_AARCH64_APPLE_DARWIN=/nix/store/s7lwib0lr80bqq0k43vd1ihr63yc6yql-clang-wrapper-16.0.6/bin/cc \
    CXX_AARCH64_APPLE_DARWIN=/nix/store/s7lwib0lr80bqq0k43vd1ihr63yc6yql-clang-wrapper-16.0.6/bin/c++ \
    CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER=/nix/store/s7lwib0lr80bqq0k43vd1ihr63yc6yql-clang-wrapper-16.0.6/bin/cc \
    CARGO_BUILD_TARGET=aarch64-apple-darwin \
    HOST_CC=/nix/store/s7lwib0lr80bqq0k43vd1ihr63yc6yql-clang-wrapper-16.0.6/bin/cc \
    HOST_CXX=/nix/store/s7lwib0lr80bqq0k43vd1ihr63yc6yql-clang-wrapper-16.0.6/bin/c++ \
    WX_WIDGETS_BUILD_OUT_DIR_ENV_NAME=/nix/store/vzyzk8k6r4f69z382z9z54q08dvr3q6s-wxwidgets-3.2.4/include/wx \
    cargo build \
    -j 8 \
    --target aarch64-apple-darwin \
    --frozen \
    --no-default-features \
    --features=modulo,native-tls
}
main "$@"
