#!/usr/bin/env bash

set -Eeuf -o pipefail
set -x

log() {
  printf '%s\n' "$*" >&2
}

main() {
  log "Testing espanso..."
  pushd espanso
  cargo test \
    --release \
    --workspace \
    --exclude espanso-modulo \
    --exclude espanso-ipc \
    --no-default-features \
    --features native-tls

  log "Building espanso and creating AppImage"
  bash ./scripts/create_app_image.sh

  popd

  find 'espanso/target/linux/AppImage/out' -maxdepth 1 -name 'Espanso-*.AppImage' -exec cp {} Espanso-X11.AppImage \; quit

  sha256sum Espanso-X11.AppImage > Espanso-X11.AppImage.sha256.txt
  ls -la

  log "Copying to mounted volume"
  find . -maxdepth 1 -name 'Espanso-X11*' -exec cp {} /shared \; -quit
}
main "@"
