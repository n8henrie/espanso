#!/usr/bin/env bash

set -Eeuf -o pipefail
set -x

readonly INSTALLER_NAME="Espanso-Win-Installer"
readonly TARGET_DIR="target/windows/installer"
readonly RESOURCE_DIR="target/windows/resources"

toml_value_for_key_in_section() {
  local key=$1
  local section=$2
  local filename=$3
  awk -F= -v key="^${key}" -v "section=[${section}]" '
    $0 ~ section { flag++ }
    flag && $0 ~ regex {
      value=$2
      sub(/ *"?/, "", value)
      sub(/"$/, "", value)
      print value
      exit
    }
  ' "${filename}"
}

main() {
  # Clean the target directory
  rm -rf "${TARGET_DIR}"

  # Create the target directory
  mkdir -p "${TARGET_DIR}"

  # // Check InnoSetup
  # Command::new("iscc").output().expect("Could not find Inno Setup compiler. Please install it from here: http://www.jrsoftware.org/isdl.php");

  local makefile_path=${CARGO_MAKE_MAKEFILE_PATH}
  local project_path=$(dirname "${makefile_path}")
  local script_resources_path=${project_path}/scripts/resources/windows
  local template_path=${script_resources_path}/setupscript.iss

  local template=$(cat "${template_path}")

  local espanso_toml_path=${project_path}/espanso/Cargo.toml
  local arch=${BUILD_ARCH}

  # let arch = if arch == "current" {
  #   std::env::consts::ARCH
  # } else {
  #   &arch
  # };

  local version=$(toml_value_for_key_in_section version package "${espanso_toml_path}")
  template=$(sed "s/{{{app_version}}}/${version}/g" <<<"${template}")

  local homepage=$(toml_value_for_key_in_section homepage package "${espanso_toml_path}")
  template=$(sed "s/{{{app_url}}}/${homepage}/g" <<<"${template}")

  local license=${project_path}/LICENSE
  template=$(sed "s/{{{app_license}}}/${license}/g" <<<"${template}")


  local icon=${script_resources_path}/icon.ico
  template=$(sed "s/{{{app_icon}}}/${icon}/g" <<<"${template}")
  
  local cli_helper=${script_resources_path}/espanso.cmd
  template=$(sed "s/{{{cli_helper}}}/${cli_helper}/g" <<<"${template}")

  template=$(sed "s/{{{output_dir}}}/${TARGET_DIR}/g" <<<"${template}")

  template=$(sed "s/{{{output_name}}}/${INSTALLER_NAME}-${arch}/g" <<<"${template}")


  local exec_path=${RESOURCE_DIR}/espansod.exe
  template=$(sed "s/{{{executable_path}}}/${exec_path}/g" <<<"${template}")

  include_paths=""
  while read -r dll; do
      include_paths+="Source: \"${dll}\"; DestDir: \"{{app}}\"; Flags: ignoreversion\r\n",
  done < <(find "${RESOURCE_DIR}" -name '*.dll')
  template=$(sed "s/{{{dll_include}}}/${include_paths}/g" <<<"${template}")

  local iss_setup=${TARGET_DIR}/setupscript.iss
  echo "${template}" > "${iss_setup}"

  iscc "${iss_setup}"
  }
}
main "$@"
