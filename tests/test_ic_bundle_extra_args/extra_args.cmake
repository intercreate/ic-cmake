# Copyright (c) 2026 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

test_cmake_group_begin("ic_bundle() EXTRA_POSTFIXES and EXTRA_FILES")

set(FULL_NAME "client_project_board@rev_1.0.0_123456")

set(BUNDLE_DIR "${CMAKE_CURRENT_LIST_DIR}/build/${FULL_NAME}")

# More than one postfix, which a one-value keyword could not accept
assert(EXISTS "${BUNDLE_DIR}/${FULL_NAME}.signed.bin")
assert(EXISTS "${BUNDLE_DIR}/${FULL_NAME}.signed.hex")

# A file from outside PREFIX, named after the bundle rather than its source
assert(EXISTS "${BUNDLE_DIR}/${FULL_NAME}_bootloader.hex")
assert(NOT EXISTS "${BUNDLE_DIR}/bootloader.hex")

# The default artifacts are still bundled alongside them
assert(EXISTS "${BUNDLE_DIR}/${FULL_NAME}.elf")
assert(EXISTS "${BUNDLE_DIR}/${FULL_NAME}.bin")
assert(EXISTS "${BUNDLE_DIR}/${FULL_NAME}.hex")
assert(EXISTS "${BUNDLE_DIR}/${FULL_NAME}.map")

assert(EXISTS "${BUNDLE_DIR}.zip")

test_cmake_group_end()
