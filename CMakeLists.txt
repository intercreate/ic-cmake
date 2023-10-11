# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

cmake_minimum_required(VERSION 3.20)
project(ic_cmake)

if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    # We're in the root, define additional targets for developers.

    # generate a package for distribution
    # reference: https://www.foonathan.net/2022/06/cmake-fetchcontent/
    set(package_files 
        ic.cmake
        LICENSE
        src/ic_bundle.cmake
        src/ic_project.cmake
        src/ic_utils.cmake
    )
    add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.zip
        COMMAND ${CMAKE_COMMAND} -E tar
            c ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.zip
            --format=zip
            -- ${package_files}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        DEPENDS ${package_files}
    )
    add_custom_target(package
        DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.zip
    )
endif()
