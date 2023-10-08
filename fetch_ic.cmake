# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

include_guard(GLOBAL)

include(FetchContent)

FetchContent_Declare(ic_cmake
    URL https://github.com/intercreate/test-cmake/releases/latest/download/ic.zip
    DOWNLOAD_EXTRACT_TIMESTAMP true
)
FetchContent_MakeAvailable(ic_cmake)

include(${CMAKE_BINARY_DIR}/_deps/ic_cmake-src/ic.cmake)
