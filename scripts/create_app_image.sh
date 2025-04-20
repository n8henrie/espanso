#!/usr/bin/env bash

set -Eeuf -o pipefail
set -x

readonly BUILD_DIR=${TARGET_DIR}/build
readonly OUTPUT_DIR=${TARGET_DIR}/out
readonly BASE_DIR=$(pwd)
readonly TARGET_DIR=${BASE_DIR}/target/linux/AppImage

main() {
  rm -ff "${TARGET_DIR}"
  mkdir -p "${OUTPUT_DIR}"
  mkdir -p "${BUILD_DIR}"

  echo "Building AppImage into ${OUTPUT_DIR}"
  pushd "${OUTPUT_DIR}"

  linuxdeploy=$(find "${BASE_DIR}"/scripts/vendor-app-image -maxdepth 1 -name 'linuxdeploy*.AppImage' -print -quit)
  "${linuxdeploy}" --appimage-extract-and-run -e "${BASE_DIR}/${EXEC_PATH}" \
    -d "${BASE_DIR}/espanso/src/res/linux/espanso.desktop" \
    -i "${BASE_DIR}/espanso/src/res/linux/icon.png" \
    --appdir "${BUILD_DIR}" \
    --output appimage
  chmod +x ./Espanso*.AppImage

  # Apply a workaround to fix this issue: https://github.com/federico-terzi/espanso/issues/900
  # See: https://github.com/project-slippi/Ishiiruka/issues/323#issuecomment-977415376

  echo "Applying patch for libgmodule"

  espanso_appimage=$(find . -maxdepth 1 -name 'Espanso*.AppImage' -print -quit)

  "${espanso_appimage}" --appimage-extract
  rm -Rf ./Espanso*.AppImage
  rm -rf squashfs-root/usr/lib/libgmodule*

  appimagetool=$(find "${BASE_DIR}"/scripts/vendor-app-image -maxdepth 1 -name 'appimagetool*.AppImage' -print -quit)
  "${appimagetool}" --appimage-extract-and-run -v squashfs-root
  rm -rf squashfs-root
}
main "$@"
