# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

include_guard(GLOBAL)

include(FetchContent)

FetchContent_Declare(test_cmake
    URL https://github.com/intercreate/test-cmake/releases/latest/download/test_cmake.zip
    DOWNLOAD_EXTRACT_TIMESTAMP true
)
FetchContent_MakeAvailable(test_cmake)

include(${CMAKE_BINARY_DIR}/_deps/test_cmake-src/test_cmake.cmake)
