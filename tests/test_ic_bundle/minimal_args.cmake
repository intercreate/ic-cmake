# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

test_cmake_group_begin("ic_bundle()")

set(FULL_NAME "client_project_board@rev_1.0.0_123456")

set(BUNDLE_DIR "${CMAKE_CURRENT_LIST_DIR}/build/${FULL_NAME}")

assert(EXISTS "${BUNDLE_DIR}")
assert(EXISTS "${BUNDLE_DIR}/${FULL_NAME}.elf")
assert(EXISTS "${BUNDLE_DIR}/${FULL_NAME}.bin")
assert(EXISTS "${BUNDLE_DIR}/${FULL_NAME}.hex")
assert(EXISTS "${BUNDLE_DIR}/${FULL_NAME}.map")

assert(EXISTS "${BUNDLE_DIR}.zip")

test_cmake_group_end()
