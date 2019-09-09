# must specify UTF-8 encoding due to the non-ASCII characters in the ArduinoJSON description
# encoding: utf-8
# for making custom command line arguments work in conjunction with the unittest module
import sys
# for unit testing
import unittest

# add the parent folder to the module search path
sys.path.append('../')
from checkforduplicatelibraryname import *  # nopep8

# parse command line arguments
argument_parser = argparse.ArgumentParser()
argument_parser.add_argument("--verbose", dest="enable_verbosity", help="Enable verbose output", action="store_true")

# this is needed to use command line arguments in conjunction with the unittest module
# (it uses its own command line arguments).
# https://stackoverflow.com/a/44255084/7059512
# alternative solution: https://stackoverflow.com/a/44248445/7059512
argument_parser.add_argument('unittest_args', nargs='*')
argument = argument_parser.parse_args()
sys.argv[1:] = argument.unittest_args


class TestCheckforduplicatelibraryname(unittest.TestCase):
    # NOTE: the tests are run in order sorted by method name, not in the order below

    set_verbosity(enable_verbosity_input=False)

    # @unittest.skip("")
    def test_check_library_name_taken(self):
        self.assertEqual(check_library_name(library_name_input="Stepper"), False)

    # @unittest.skip("")
    def test_check_library_name_taken_case_mismatch(self):
        self.assertEqual(check_library_name(library_name_input="stepper"), False)

    # @unittest.skip("")
    def test_check_library_name_not_taken(self):
        self.assertEqual(check_library_name(library_name_input="asdfqwer"), True)


if __name__ == '__main__':
    unittest.main()
