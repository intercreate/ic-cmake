# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

include_guard(GLOBAL)


# Common C flags
set(IC_C_FLAGS
    -fno-common
    -fstack-usage
    -fmacro-prefix-map=${CMAKE_SOURCE_DIR}=.
)
