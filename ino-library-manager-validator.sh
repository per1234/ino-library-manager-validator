#!/bin/bash

# This script is used to check compliance with the requirements for addition to the Arduino Library Manager index
# https://github.com/arduino/Arduino/wiki/Library-Manager-FAQ

# The temporary folder to use for cloning the library
# WARNING: The temporary folder will be deleted
readonly INO_LIBRARY_MANAGER_VALIDATOR_TEMPORARY_FOLDER=$1
# The path to arduino-ci-script.sh
readonly INO_LIBRARY_MANAGER_VALIDATOR_ARDUINO_CI_SCRIPT_PATH=$2
# If this argument is not specified, the user will be prompted for the URL at runtime
INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_URL=$3

readonly INO_LIBRARY_MANAGER_VALIDATOR_PREVIOUS_FOLDER="$PWD"

readonly INO_LIBRARY_MANAGER_VALIDATOR_SUCCESS_EXIT_STATUS=0
readonly INO_LIBRARY_MANAGER_VALIDATOR_FAILURE_EXIT_STATUS=1

# Set default exit status
INO_LIBRARY_MANAGER_VALIDATOR_EXIT_STATUS="$INO_LIBRARY_MANAGER_VALIDATOR_SUCCESS_EXIT_STATUS"

# Clean up
function cleanup() {
  cd "$INO_LIBRARY_MANAGER_VALIDATOR_PREVIOUS_FOLDER" || return 1
  # Remove the temporary folder
  rm --force --recursive "$INO_LIBRARY_MANAGER_VALIDATOR_TEMPORARY_FOLDER"
}

function setExitStatus() {
  local -r newExitStatus="$1"

  # Only update exit status if it's a change from success to failure
  if [[ "$INO_LIBRARY_MANAGER_VALIDATOR_EXIT_STATUS" == "$INO_LIBRARY_MANAGER_VALIDATOR_SUCCESS_EXIT_STATUS" ]]; then
    INO_LIBRARY_MANAGER_VALIDATOR_EXIT_STATUS="$newExitStatus"
  fi
}

if [[ "$INO_LIBRARY_MANAGER_VALIDATOR_TEMPORARY_FOLDER" == "" ]]; then
  echo "ERROR: INO_LIBRARY_MANAGER_VALIDATOR_TEMPORARY_FOLDER argument not specified"
  exit 1
fi

if [[ "$INO_LIBRARY_MANAGER_VALIDATOR_ARDUINO_CI_SCRIPT_PATH" == "" ]]; then
  echo "ERROR: INO_LIBRARY_MANAGER_VALIDATOR_ARDUINO_CI_SCRIPT_PATH argument not specified"
  exit 1
fi

if ! [[ -e "$INO_LIBRARY_MANAGER_VALIDATOR_ARDUINO_CI_SCRIPT_PATH" ]]; then
  echo "ERROR: $INO_LIBRARY_MANAGER_VALIDATOR_ARDUINO_CI_SCRIPT_PATH does not exist"
  exit 1
fi

if [[ "$INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_URL" == "" ]]; then
  read -r -p "Library URL: " INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_URL
fi

# Remove trailing slash if present to make the URL uniform
INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_URL="${INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_URL%/}"

# Check URL for missing scheme
readonly INO_LIBRARY_MANAGER_VALIDATOR_URL_SCHEME_REGEX="://"
if ! [[ "$INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_URL" =~ $INO_LIBRARY_MANAGER_VALIDATOR_URL_SCHEME_REGEX ]]; then
  # Scheme is missing from the URL, so add it
  INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_URL="https://${INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_URL}"
fi

# Clean/create the temporary folder
if [[ -d "$INO_LIBRARY_MANAGER_VALIDATOR_TEMPORARY_FOLDER" ]]; then
  rm --force --recursive "$INO_LIBRARY_MANAGER_VALIDATOR_TEMPORARY_FOLDER"
fi
mkdir --parents "$INO_LIBRARY_MANAGER_VALIDATOR_TEMPORARY_FOLDER"

# clone the repository
echo "Cloning the library repository..."
cd "$INO_LIBRARY_MANAGER_VALIDATOR_TEMPORARY_FOLDER" || {
  cleanup
  exit 1
}
git clone --quiet "$INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_URL" || {
  cleanup
  exit 1
}
# Determine the repository folder name
readonly INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_PATH="${INO_LIBRARY_MANAGER_VALIDATOR_TEMPORARY_FOLDER}/$(basename --suffix=.git "${INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_URL}")"
# checkout the latest tag of the repository
cd "$INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_PATH" || {
  cleanup
  exit 1
}
# get new tags from the remote
git fetch --quiet --tags || {
  cleanup
  exit 1
}
# checkout the latest tag
INO_LIBRARY_MANAGER_VALIDATOR_LATEST_TAG="$(git describe --tags "$(git rev-list --tags --max-count=1)")"
if [[ "$INO_LIBRARY_MANAGER_VALIDATOR_LATEST_TAG" == "" ]]; then
  echo "ERROR: The library repository has no tags"
  cleanup
  exit 1
fi
echo "Checking out latest tag: $INO_LIBRARY_MANAGER_VALIDATOR_LATEST_TAG"
git checkout --quiet "$INO_LIBRARY_MANAGER_VALIDATOR_LATEST_TAG" || {
  cleanup
  exit 1
}
cd "$INO_LIBRARY_MANAGER_VALIDATOR_PREVIOUS_FOLDER" || {
  cleanup
  return 1
}

# source arduino-ci-script so its functions can be used
# shellcheck source=/dev/null
source "$INO_LIBRARY_MANAGER_VALIDATOR_ARDUINO_CI_SCRIPT_PATH"

# Check if there is a library.properties
if ! [[ -e "${INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_PATH}/library.properties" ]]; then
  echo "ERROR: No library.properties found in the root of the repository"
  setExitStatus "$INO_LIBRARY_MANAGER_VALIDATOR_FAILURE_EXIT_STATUS"
else
  # These actions can only be done if there is a library.properties

  # Determine the library name

  # Check whether the library name is already taken
  readonly INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_PROPERTIES=$(tr "\r" "\n" <"${INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_PATH}/library.properties")
  readonly INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_NAME="$(get_library_properties_field_value "$INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_PROPERTIES" 'name')"
  if [[ "$INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_NAME" == "" ]]; then
    echo "ERROR: Unable to determine library name"
    setExitStatus "$INO_LIBRARY_MANAGER_VALIDATOR_FAILURE_EXIT_STATUS"
  fi
  echo "Checking if library name $INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_NAME is already taken..."
  if ! python "$(dirname "$0")/checkforduplicatelibraryname/checkforduplicatelibraryname.py" --libraryname "$INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_NAME"; then
    setExitStatus "$INO_LIBRARY_MANAGER_VALIDATOR_FAILURE_EXIT_STATUS"
  fi

  # Run check_library_properties
  # NOTE: not all failures of check_library_properties block acceptance to the Arduino Library Manager index
  echo "Checking library.properties..."
  check_library_properties "$INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_PATH"
  setExitStatus $?
fi

# Run check_library_manager_compliance
echo "Running additional checks for compliance with the Library Manager requirements..."
check_library_manager_compliance "$INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_PATH"
setExitStatus $?

if [[ "$INO_LIBRARY_MANAGER_VALIDATOR_EXIT_STATUS" == "0" ]]; then
  INO_LIBRARY_MANAGER_VALIDATOR_EXIT_STATUS="$CHECK_LIBRARY_MANAGER_COMPLIANCE_EXIT_STATUS"
fi

cleanup
exit "$INO_LIBRARY_MANAGER_VALIDATOR_EXIT_STATUS"
