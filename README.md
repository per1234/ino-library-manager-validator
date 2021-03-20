# ino-library-manager-validator

Script to check whether a library meets the requirements for inclusion in the [Arduino](https://arduino.cc/) Library Manager index.

https://github.com/arduino/Arduino/wiki/Library-Manager-FAQ

## DEPRECATION NOTICE

Good news everyone! Arduino has now created an official tool that can be used for checking for compliance with the Arduino Library Manager requirements:
https://arduino.github.io/arduino-lint/latest/#library-manager-setting

This tool will no longer be maintained. Please use Arduino Lint.

### Dependencies
- Python 3
- [arduino-ci-script](https://github.com/per1234/arduino-ci-script)

### Usage
##### `check-code-formatting.sh INO_LIBRARY_MANAGER_VALIDATOR_TEMPORARY_FOLDER INO_LIBRARY_MANAGER_VALIDATOR_ARDUINO_CI_SCRIPT_PATH [INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_URL]`
- **INO_LIBRARY_MANAGER_VALIDATOR_TEMPORARY_FOLDER** - The temporary folder to use for cloning the library. WARNING: The temporary folder will be deleted.
- **INO_LIBRARY_MANAGER_VALIDATOR_ARDUINO_CI_SCRIPT_PATH** - The path of [arduino-ci-script.sh](https://github.com/per1234/arduino-ci-script).
- **INO_LIBRARY_MANAGER_VALIDATOR_LIBRARY_URL** - The URL of the repository of the library to check. If this argument is omitted, the script will prompt the user for the URL at runtime.
