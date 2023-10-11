# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

cmake_minimum_required(VERSION 3.20.0)
project(test_ic_project)

include(${CMAKE_CURRENT_LIST_DIR}/../dependencies/fetch_test_cmake.cmake)

test_cmake_begin()

include(test_ic_project.cmake)
include(test_ic_bundle/minimal_args.cmake)

test_cmake_end()
