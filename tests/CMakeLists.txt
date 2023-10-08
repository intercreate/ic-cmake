# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

cmake_minimum_required(VERSION 3.20.0)
project(test_ic_project)

include(${CMAKE_SOURCE_DIR}/../ic.cmake)

include(fetch_test_cmake.cmake)

test_cmake_begin()

include(test_ic_project.cmake)

test_cmake_end()
