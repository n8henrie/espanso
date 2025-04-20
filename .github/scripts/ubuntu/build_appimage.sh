#!/usr/bin/env bash

set -Eeuf -o pipefail
set -x

echo "Testing espanso..."
cd espanso
cargo test \
  --release \
  --workspace \
  --exclude espanso-modulo \
  --exclude espanso-ipc \
  --no-default-features \
  --features native-tls

echo "Building espanso and creating AppImage"
bash ./scripts/create_app_image.sh

cd ..
cp espanso/target/linux/AppImage/out/Espanso-*.AppImage Espanso-X11.AppImage
sha256sum Espanso-X11.AppImage > Espanso-X11.AppImage.sha256.txt
ls -la

echo "Copying to mounted volume"
cp Espanso-X11* /shared
