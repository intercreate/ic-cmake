# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

include_guard(GLOBAL)

#[[
set() name to value only if name is not defined.

Use to set default arguments within a function.

<name> : CMake variable name to set
<value> : the value for the CMake variable
#]]
macro(set_default name value)
    if(NOT DEFINED ${name})
        set(${name} ${value})
    endif()
endmacro()

#[[
set() the CMake variable and add_compile_definition()

<name> : CMake variable and compile definition name to set
<value> : the value to set name to
[PARENT_SCOPE] : call set() with PARENT_SCOPE
#]]
macro(set_definition name value)
    if(NOT ${ARGC} EQUAL 2 AND NOT ${ARGC} EQUAL 3)
        message(
            FATAL_ERROR
            "Invalid arguments to set_definition(<name> <value> [PARENT_SCOPE]): (${name} ${value} ${ARGN})"
        )
    elseif(${ARGC} EQUAL 3 AND NOT ${ARG2} EQUAL PARENT_SCOPE)
        message(
            FATAL_ERROR
            "Invalid arguments to set_definition(<name> <value> [PARENT_SCOPE]): (${name} ${value} ${ARGN})"
        )
    endif()

    if(DEFINED name)
        message(FATAL_ERROR "${name} is already defined!")
    endif()

    set(${name} ${value} ${ARGN})
    add_compile_definitions(${name}=${value})
    message(STATUS "${name} = ${value}")
endmacro()

#[[
set_definition() only if value is defined as something other than ""

<name> : CMake variable and compile definition name to set
<value> : the value to set name to
[PARENT_SCOPE] : call set() with PARENT_SCOPE
#]]
macro(if_set_definition name value)
    if(NOT "" STREQUAL "${value}")
        set_definition(${name} ${value} ${ARGN})
    endif()
endmacro()
