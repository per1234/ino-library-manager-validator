# for command line arguments
import argparse
# for parsing Library Manager index
import json
# for debug output
import logging
# for exit status
import sys
# for URL requests
import urllib.request

file_encoding = "utf-8"
# DEBUG: automatically generated output and all higher log level output
# INFO: manually specified output and all higher log level output
logging_level = logging.INFO
# allow all log output to be disabled
logging.addLevelName(1000, "OFF")
# default to no logger
logging.basicConfig(level="OFF")
logger = logging.getLogger(__name__)

# globals
enable_verbosity = False


def main():
    """The primary function."""
    set_verbosity(enable_verbosity_input=argument.enable_verbosity)

    if check_library_name(library_name_input=argument.library_name):
        sys.exit(0)
    else:
        sys.exit(1)


def set_verbosity(enable_verbosity_input):
    """Turn debug output on or off.

    Keyword arguments:
    enable_verbosity_input -- this will generally be controlled via the script's --verbose command line argument
                              (True, False)
    """
    global enable_verbosity
    if enable_verbosity_input:
        enable_verbosity = True
        logger.setLevel(level=logging_level)
    else:
        enable_verbosity = False
        logger.setLevel(level="OFF")


def check_library_name(library_name_input):
    """Check if the library name has already been taken. If the name is taken, return False. If the name is unique,
    return True.

    Keyword arguments:
    library_name_input -- The name to check
    """
    request = urllib.request.Request(url="http://downloads.arduino.cc/libraries/library_index.json")
    try:
        with urllib.request.urlopen(request) as url_data:
            try:
                json_data = json.loads(url_data.read().decode(file_encoding, "ignore"))
            except json.decoder.JSONDecodeError as exception:
                # output some information on the exception
                logger.warning(str(exception.__class__.__name__) + ": " + str(exception))
                # pass on the exception to the caller
                raise exception
    except Exception as exception:
        raise exception
    logger.info("Checking if " + str(library_name_input) + " is a unique name")
    for library_data in json_data["libraries"]:
        # get the library name from the index
        indexed_library_name = library_data["name"]
        # check if the desired name matches (case-insensitive) the name of the library in the index
        if library_name_input.casefold() == indexed_library_name.casefold():
            sys.stderr.write("ERROR: Library name already taken\n")
            sys.stderr.flush()
            return False

    sys.stdout.write("Library name is not taken\n")
    sys.stdout.flush()
    return True


# only execute the following code if the script is run directly, not imported
if __name__ == '__main__':
    # parse command line arguments
    argument_parser = argparse.ArgumentParser()
    argument_parser.add_argument("--libraryname", dest="library_name",
                                 help="Name of the library to check", metavar="LIBRARYNAME")
    argument_parser.add_argument("--verbose", dest="enable_verbosity", help="Enable verbose output",
                                 action="store_true")
    argument = argument_parser.parse_args()

    # run program
    main()
