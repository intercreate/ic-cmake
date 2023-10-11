# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

cmake_minimum_required(VERSION 3.20.0)
project(create_the_ic_bundle_build)

include(${CMAKE_SOURCE_DIR}/../../ic.cmake)

add_custom_target(test_ic_bundle ALL)

set(FULL_NAME "client_project_board@rev_1.0.0_123456")

ic_bundle(
    FULL_NAME "${FULL_NAME}"
    PREFIX ${CMAKE_SOURCE_DIR}/../fixtures/ic_bundle/project
    DEPENDS test_ic_bundle
)
