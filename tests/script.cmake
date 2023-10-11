# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

# Build the examples since the tests check for build artifacts
execute_process(COMMAND cmake "-B" "tests/test_ic_bundle/build" "-S" "tests/test_ic_bundle")
execute_process(COMMAND cmake "--build" "tests/test_ic_bundle/build")

# Run the tests
execute_process(
    COMMAND cmake "-B" "tests/build" "-S" "tests"
    RESULT_VARIABLE res 
)
if(NOT ${res} EQUAL 0)
    message(FATAL_ERROR "Tests failed!")
endif()
