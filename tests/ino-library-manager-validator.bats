#!/usr/bin/env bats

TEMPORARY_FOLDER="${HOME}/temporary/ino-library-manager-validator"
ARDUINO_CI_SCRIPT_FOLDER="${HOME}/scripts/arduino-ci-script"

# source arduino-ci-script so its exit status names can be used instead of magic numbers
source ${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh

# Missing INO_LIBRARY_MANAGER_VALIDATOR_TEMPORARY_FOLDER argument
@test "../ino-library-manager-validator.sh" {
  #skip
  expectedExitStatus=1
  run ../ino-library-manager-validator.sh
  echo "Exit status: $status | Expected: $expectedExitStatus"
  [ $status -eq $expectedExitStatus ]
  [ "${#lines[@]}" -eq 1 ]
  outputRegex='^ERROR: INO_LIBRARY_MANAGER_VALIDATOR_TEMPORARY_FOLDER argument not specified$'
  [[ "${lines[0]}" =~ $outputRegex ]]
}

# Missing INO_LIBRARY_MANAGER_VALIDATOR_ARDUINO_CI_SCRIPT_PATH argument
@test "../ino-library-manager-validator.sh \"$TEMPORARY_FOLDER\"" {
  #skip
  expectedExitStatus=1
  run ../ino-library-manager-validator.sh "$TEMPORARY_FOLDER"
  echo "Exit status: $status | Expected: $expectedExitStatus"
  [ $status -eq $expectedExitStatus ]
  [ "${#lines[@]}" -eq 1 ]
  outputRegex='^ERROR: INO_LIBRARY_MANAGER_VALIDATOR_ARDUINO_CI_SCRIPT_PATH argument not specified$'
  [[ "${lines[0]}" =~ $outputRegex ]]
}

# Compliant library with trailing slash on URL
@test "../ino-library-manager-validator.sh \"$TEMPORARY_FOLDER\" \"${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh\" 'https://github.com/adafruit/Adafruit_DHT_Unified/'" {
  #skip
  expectedExitStatus=0
  run ../ino-library-manager-validator.sh "$TEMPORARY_FOLDER" "${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh" 'https://github.com/adafruit/Adafruit_DHT_Unified/'
  echo "Exit status: $status | Expected: $expectedExitStatus"
  [ $status -eq $expectedExitStatus ]
  [ "${#lines[@]}" -eq 8 ]
  outputRegex='^Cloning the library repository\.\.\.$'
  [[ "${lines[0]}" =~ $outputRegex ]]
  outputRegex='^Checking out latest tag:'
  [[ "${lines[1]}" =~ $outputRegex ]]
  outputRegex='^Checking if library name Adafruit DHT Unified is already taken\.\.\.$'
  [[ "${lines[2]}" =~ $outputRegex ]]
  outputRegex='^Library name is not taken$'
  [[ "${lines[3]}" =~ $outputRegex ]]
  outputRegex='^Checking library\.properties\.\.\.$'
  [[ "${lines[4]}" =~ $outputRegex ]]
  outputRegex="^ERROR: ${TEMPORARY_FOLDER}/Adafruit_DHT_Unified/library\.properties: paragraph value repeats the sentence\. These strings are displayed one after the other in Library Manager so there is no point in redundancy\.$"
  [[ "${lines[5]}" =~ $outputRegex ]]
  outputRegex="^NOTE: The above error does not block acceptance to the Arduino Library Manager index, but it's recommended to fix it anyway\.$"
  [[ "${lines[6]}" =~ $outputRegex ]]
  outputRegex='^Running additional checks for compliance with the Library Manager requirements\.\.\.$'
  [[ "${lines[7]}" =~ $outputRegex ]]
}

# Compliant library with missing scheme on URL
@test "../ino-library-manager-validator.sh \"$TEMPORARY_FOLDER\" \"${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh\" 'github.com/adafruit/Adafruit_DHT_Unified'" {
  #skip
  expectedExitStatus=0
  run ../ino-library-manager-validator.sh "$TEMPORARY_FOLDER" "${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh" 'github.com/adafruit/Adafruit_DHT_Unified'
  echo "Exit status: $status | Expected: $expectedExitStatus"
  [ $status -eq $expectedExitStatus ]
  [ "${#lines[@]}" -eq 8 ]
  outputRegex='^Cloning the library repository\.\.\.$'
  [[ "${lines[0]}" =~ $outputRegex ]]
  outputRegex='^Checking out latest tag:'
  [[ "${lines[1]}" =~ $outputRegex ]]
  outputRegex='^Checking if library name Adafruit DHT Unified is already taken\.\.\.$'
  [[ "${lines[2]}" =~ $outputRegex ]]
  outputRegex='^Library name is not taken$'
  [[ "${lines[3]}" =~ $outputRegex ]]
  outputRegex='^Checking library\.properties\.\.\.$'
  [[ "${lines[4]}" =~ $outputRegex ]]
  outputRegex="^ERROR: ${TEMPORARY_FOLDER}/Adafruit_DHT_Unified/library\.properties: paragraph value repeats the sentence\. These strings are displayed one after the other in Library Manager so there is no point in redundancy\.$"
  [[ "${lines[5]}" =~ $outputRegex ]]
  outputRegex="^NOTE: The above error does not block acceptance to the Arduino Library Manager index, but it's recommended to fix it anyway\.$"
  [[ "${lines[6]}" =~ $outputRegex ]]
  outputRegex='^Running additional checks for compliance with the Library Manager requirements\.\.\.$'
  [[ "${lines[7]}" =~ $outputRegex ]]
}

# Compliant library with .git extension on URL
@test "../ino-library-manager-validator.sh \"$TEMPORARY_FOLDER\" \"${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh\" 'https://github.com/adafruit/Adafruit_DHT_Unified.git'" {
  #skip
  expectedExitStatus=0
  run ../ino-library-manager-validator.sh "$TEMPORARY_FOLDER" "${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh" 'https://github.com/adafruit/Adafruit_DHT_Unified.git'
  echo "Exit status: $status | Expected: $expectedExitStatus"
  [ $status -eq $expectedExitStatus ]
  [ "${#lines[@]}" -eq 8 ]
  outputRegex='^Cloning the library repository\.\.\.$'
  [[ "${lines[0]}" =~ $outputRegex ]]
  outputRegex='^Checking out latest tag:'
  [[ "${lines[1]}" =~ $outputRegex ]]
  outputRegex='^Checking if library name Adafruit DHT Unified is already taken\.\.\.$'
  [[ "${lines[2]}" =~ $outputRegex ]]
  outputRegex='^Library name is not taken$'
  [[ "${lines[3]}" =~ $outputRegex ]]
  outputRegex='^Checking library\.properties\.\.\.$'
  [[ "${lines[4]}" =~ $outputRegex ]]
  outputRegex="^ERROR: ${TEMPORARY_FOLDER}/Adafruit_DHT_Unified/library\.properties: paragraph value repeats the sentence\. These strings are displayed one after the other in Library Manager so there is no point in redundancy\.$"
  [[ "${lines[5]}" =~ $outputRegex ]]
  outputRegex="^NOTE: The above error does not block acceptance to the Arduino Library Manager index, but it's recommended to fix it anyway\.$"
  [[ "${lines[6]}" =~ $outputRegex ]]
  outputRegex='^Running additional checks for compliance with the Library Manager requirements\.\.\.$'
  [[ "${lines[7]}" =~ $outputRegex ]]
}

# Compliant library with standard URL
@test "../ino-library-manager-validator.sh \"$TEMPORARY_FOLDER\" \"${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh\" 'https://github.com/adafruit/Adafruit_DHT_Unified'" {
  #skip
  expectedExitStatus=0
  run ../ino-library-manager-validator.sh "$TEMPORARY_FOLDER" "${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh" 'https://github.com/adafruit/Adafruit_DHT_Unified'
  echo "Exit status: $status | Expected: $expectedExitStatus"
  [ $status -eq $expectedExitStatus ]
  [ "${#lines[@]}" -eq 8 ]
  outputRegex='^Cloning the library repository\.\.\.$'
  [[ "${lines[0]}" =~ $outputRegex ]]
  outputRegex='^Checking out latest tag:'
  [[ "${lines[1]}" =~ $outputRegex ]]
  outputRegex='^Checking if library name Adafruit DHT Unified is already taken\.\.\.$'
  [[ "${lines[2]}" =~ $outputRegex ]]
  outputRegex='^Library name is not taken$'
  [[ "${lines[3]}" =~ $outputRegex ]]
  outputRegex='^Checking library\.properties\.\.\.$'
  [[ "${lines[4]}" =~ $outputRegex ]]
  outputRegex="^ERROR: ${TEMPORARY_FOLDER}/Adafruit_DHT_Unified/library\.properties: paragraph value repeats the sentence\. These strings are displayed one after the other in Library Manager so there is no point in redundancy\.$"
  [[ "${lines[5]}" =~ $outputRegex ]]
  outputRegex="^NOTE: The above error does not block acceptance to the Arduino Library Manager index, but it's recommended to fix it anyway\.$"
  [[ "${lines[6]}" =~ $outputRegex ]]
  outputRegex='^Running additional checks for compliance with the Library Manager requirements\.\.\.$'
  [[ "${lines[7]}" =~ $outputRegex ]]
}

# No tags
@test "../ino-library-manager-validator.sh \"$TEMPORARY_FOLDER\" \"${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh\" 'https://github.com/Ark-IoT/Ark-Cpp'" {
  #skip
  expectedExitStatus=1
  run ../ino-library-manager-validator.sh "$TEMPORARY_FOLDER" "${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh" 'https://github.com/Ark-IoT/Ark-Cpp'
  echo "Exit status: $status | Expected: $expectedExitStatus"
  [ $status -eq $expectedExitStatus ]
  [ "${#lines[@]}" -eq 3 ]
  outputRegex='^Cloning the library repository\.\.\.$'
  [[ "${lines[0]}" =~ $outputRegex ]]
  outputRegex='^fatal: No names found, cannot describe anything\.'
  [[ "${lines[1]}" =~ $outputRegex ]]
  outputRegex='^ERROR: The library repository has no tags$'
  [[ "${lines[2]}" =~ $outputRegex ]]
}

# Test latest version checkout commands
# No library.properties
@test "../ino-library-manager-validator.sh \"$TEMPORARY_FOLDER\" \"${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh\" 'https://github.com/sparkfun/SFE_CC3000_Library'" {
  #skip
  expectedExitStatus=1
  run ../ino-library-manager-validator.sh "$TEMPORARY_FOLDER" "${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh" 'https://github.com/sparkfun/SFE_CC3000_Library'
  echo "Exit status: $status | Expected: $expectedExitStatus"
  [ $status -eq $expectedExitStatus ]
  [ "${#lines[@]}" -eq 4 ]
  outputRegex='^Cloning the library repository\.\.\.$'
  [[ "${lines[0]}" =~ $outputRegex ]]
  outputRegex='^Checking out latest tag: v1\.6$'
  [[ "${lines[1]}" =~ $outputRegex ]]
  outputRegex='^ERROR: No library\.properties found in the root of the repository$'
  [[ "${lines[2]}" =~ $outputRegex ]]
  outputRegex='^Running additional checks for compliance with the Library Manager requirements\.\.\.$'
  [[ "${lines[3]}" =~ $outputRegex ]]
}

# Library name is taken
@test "../ino-library-manager-validator.sh \"$TEMPORARY_FOLDER\" \"${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh\" 'https://github.com/arduino-libraries/Stepper'" {
  #skip
  expectedExitStatus=1
  run ../ino-library-manager-validator.sh "$TEMPORARY_FOLDER" "${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh" 'https://github.com/arduino-libraries/Stepper'
  echo "Exit status: $status | Expected: $expectedExitStatus"
  [ $status -eq $expectedExitStatus ]
  [ "${#lines[@]}" -eq 6 ]
  outputRegex='^Cloning the library repository\.\.\.$'
  [[ "${lines[0]}" =~ $outputRegex ]]
  outputRegex='^Checking out latest tag:'
  [[ "${lines[1]}" =~ $outputRegex ]]
  outputRegex='^Checking if library name Stepper is already taken\.\.\.$'
  [[ "${lines[2]}" =~ $outputRegex ]]
  outputRegex='^ERROR: Library name already taken$'
  [[ "${lines[3]}" =~ $outputRegex ]]
  outputRegex='^Checking library\.properties\.\.\.$'
  [[ "${lines[4]}" =~ $outputRegex ]]
  outputRegex='^Running additional checks for compliance with the Library Manager requirements\.\.\.$'
  [[ "${lines[5]}" =~ $outputRegex ]]
}

# Library name not taken
# Library name starts with arduino
@test "../ino-library-manager-validator.sh \"$TEMPORARY_FOLDER\" \"${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh\" 'https://github.com/winkj/arduino-sdp'" {
  #skip
  expectedExitStatus=$ARDUINO_CI_SCRIPT_CHECK_LIBRARY_MANAGER_COMPLIANCE_NAME_IS_RESERVED_EXIT_STATUS
  run ../ino-library-manager-validator.sh "$TEMPORARY_FOLDER" "${ARDUINO_CI_SCRIPT_FOLDER}/arduino-ci-script.sh" 'https://github.com/winkj/arduino-sdp'
  echo "Exit status: $status | Expected: $expectedExitStatus"
  [ $status -eq $expectedExitStatus ]
  [ "${#lines[@]}" -eq 8 ]
  outputRegex='^Cloning the library repository\.\.\.$'
  [[ "${lines[0]}" =~ $outputRegex ]]
  outputRegex='^Checking out latest tag:'
  [[ "${lines[1]}" =~ $outputRegex ]]
  outputRegex='^Checking if library name arduino-sdp is already taken\.\.\.$'
  [[ "${lines[2]}" =~ $outputRegex ]]
  outputRegex='^Library name is not taken$'
  [[ "${lines[3]}" =~ $outputRegex ]]
  outputRegex='^Checking library\.properties\.\.\.$'
  [[ "${lines[4]}" =~ $outputRegex ]]
  outputRegex="^WARNING: ${TEMPORARY_FOLDER}/arduino-sdp/library\.properties: name value: arduino-sdp starts with "'"arduino"\. These names are reserved for official Arduino libraries\. Libraries using a reserved name will not be accepted in the Library Manager index\.$'
  [[ "${lines[5]}" =~ $outputRegex ]]
  outputRegex='^Running additional checks for compliance with the Library Manager requirements\.\.\.$'
  [[ "${lines[6]}" =~ $outputRegex ]]
  outputRegex="^ERROR: ${TEMPORARY_FOLDER}/arduino-sdp/library\.properties: name value: arduino-sdp starts with "'"arduino"\. These names are reserved for official Arduino libraries\.$'
  [[ "${lines[7]}" =~ $outputRegex ]]
}
