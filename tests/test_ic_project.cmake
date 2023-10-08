# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

test_cmake_group_begin("ic_project() with required args")

# test ic_project() with only required args
ic_project_out(ic_out)
ic_project(
    # output variables
    ${ic_out}

    # keyword arguments
    CLIENT_NAME "Flumbr"
    PROJECT_NAME "Dipple Snurp 3"
    BOARD_NAME FF3
)

# assert the ones that should not be defined
assert(NOT DEFINED IC_BOARD_REV)
assert(NOT DEFINED IC_BUILD_TYPE)

# filter out stuff that wouldn't be defined
list(FILTER ic_out EXCLUDE REGEX "IC_GIT_TAG_REV|IC_BOARD_REV|IC_BUILD_TYPE")

foreach(ic_out_var ${ic_out})
    assert(DEFINED "${ic_out_var}")
endforeach()

assert(Flumbr STREQUAL ${IC_CLIENT_NAME})
assert("Dipple Snurp 3" STREQUAL ${IC_PROJECT_NAME})
assert(FF3 STREQUAL ${IC_BOARD_NAME})
assert(${IC_CONFIG_STRING} MATCHES Flumbr_Dipple_Snurp_3_FF3_.+_[0-9]+)

test_cmake_group_end()

test_cmake_group_begin("ic_project() with optional args")

# test ic_project() with all args
ic_project_out(ic_out)
ic_project(
    # output variables
    ${ic_out}

    # keyword arguments
    CLIENT_NAME "Flampr"
    PROJECT_NAME "flying-vanilla-bean"
    BOARD_NAME "toffee"
    BOARD_REV "NFF2"
    BUILD_TYPE proto
)

# filter out GIT_TAG_REV - so we don't have to check here
list(FILTER ic_out EXCLUDE REGEX "IC_GIT_TAG_REV")

foreach(ic_out_var ${ic_out})
    assert(DEFINED "${ic_out_var}")
endforeach()

assert(Flampr STREQUAL ${IC_CLIENT_NAME})
assert(flying-vanilla-bean STREQUAL ${IC_PROJECT_NAME})
assert(toffee STREQUAL ${IC_BOARD_NAME})
assert(NFF2 STREQUAL ${IC_BOARD_REV})
assert(proto STREQUAL ${IC_BUILD_TYPE})
assert(Flampr STREQUAL ${IC_CLIENT_NAME})
assert(${IC_CONFIG_STRING} MATCHES Flampr_flying-vanilla-bean_toffee@NFF2_.+_[0-9]+_proto)

test_cmake_group_end()
