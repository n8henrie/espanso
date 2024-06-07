#!/usr/bin/env bash

main() {
  pushd espanso-detect
  c++ \
    -O0 \
    -ffunction-sections \
    -fdata-sections \
    -fPIC \
    -g \
    -fno-omit-frame-pointer \
    -arch arm64 \
    -I src/mac/native.h \
    -Wall \
    -Wextra \
    -o /Users/n8henrie/git/espanso/target/debug/build/espanso-detect-8c4fa7e8279c2541/out/src/mac/native.o \
    -c src/mac/native.mm
}
main "$@"
