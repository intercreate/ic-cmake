# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

include_guard(GLOBAL)


# Sets common CMake options to Intercreate defaults.
macro(ic_set_cmake_options)
    set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
endmacro()
