# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

include_guard(GLOBAL)

if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.24.0")
    set(download_extract_timestamp "DOWNLOAD_EXTRACT_TIMESTAMP true")
endif()

include(FetchContent)

FetchContent_Declare(ic_cmake
    URL https://github.com/intercreate/test-cmake/releases/latest/download/ic.zip
    ${download_extract_timestamp}
)
FetchContent_MakeAvailable(ic_cmake)

include(${CMAKE_BINARY_DIR}/_deps/ic_cmake-src/ic.cmake)
