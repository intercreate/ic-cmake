# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

include_guard(GLOBAL)


# Common C warning flags
set(IC_C_WARNINGS
    -Wall
    -Wextra
    -Wshadow
    -Wconversion
    -Wdouble-promotion
    -Wformat=2
    -Wformat-truncation
    -Wundef
    -Wno-unused-parameter
)
