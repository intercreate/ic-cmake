# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

include_guard(GLOBAL)

include(${CMAKE_CURRENT_LIST_DIR}/ic_utils.cmake)

#[[ 
Create the project(), set() CMake variables, and add_compile_definitions() with project metadata.

<out_variable_list> : output variable list (see ic_project_out)
CLIENT_NAME <name> : the client name for the project
PROJECT_NAME <name> : the name of the project; calls project(<name>)
BOARD_NAME <name> : the name of the board (hardware revision)
[BOARD_REV <rev>] : the board revision
[BUILD_TYPE <build_type>] : a build type modifier, e.g. release, debug, factory, etc.
    will default to ${CMAKE_BUILD_TYPE} but it does not set CMAKE_BUILD_TYPE

Usage:
    ic_project_out(ic_out)  # using the default names
    ic_project(
        # output variables
        ${ic_out}

        # keyword arguments
        CLIENT_NAME "Flumbr"
        PROJECT_NAME "Dipple Snurp 3"
        BOARD_NAME FF3
        BUILD_TYPE debug
    )
]]#
function(ic_project
    # output variables
    out_client_name
    out_project_name
    out_board_name
    out_board_rev # depends on BOARD_REV
    out_fw_version
    out_build_type # depends on BUILD_TYPE
    out_git_dirty
    out_git_tag
    out_git_tag_rev # maybe "" 
    out_git_hash
    out_git_user_name
    out_git_user_email
    out_build_date
    out_build_time
    out_c_compiler_id
    out_c_compiler
    out_c_compiler_version
    out_host_system_name
    out_host_system_version
    out_full_name
)
    set(required_keyword_args
        CLIENT_NAME
        PROJECT_NAME
        BOARD_NAME
    )
    set(optional_keyword_args
        BOARD_REV
        BUILD_TYPE
        FW_VERSION
    )
    list(APPEND keyword_args
        ${required_keyword_args}
        ${optional_keyword_args}
    )
    cmake_parse_arguments(PARSE_ARGV 20 "" "" "${keyword_args}" "")

    if(_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unparsed arguments: ${_UNPARSED_ARGUMENTS}")
    endif()

    set_default("_BUILD_TYPE" "${CMAKE_BUILD_TYPE}")

    foreach(KEY ${required_keyword_args})
        if(NOT DEFINED "_${KEY}")
            message(
                FATAL_ERROR
                "Missing keyword argument ${KEY} in call to \
                ${CMAKE_CURRENT_FUNCTION}()"
            )
        endif()
    endforeach()

    set_definition_string("${out_client_name}" "${_CLIENT_NAME}" PARENT_SCOPE)
    set_definition_string("${out_project_name}" "${_PROJECT_NAME}" PARENT_SCOPE)
    set_definition_string("${out_board_name}" "${_BOARD_NAME}" PARENT_SCOPE)
    if_set_definition_string("${out_board_rev}" "${_BOARD_REV}" PARENT_SCOPE)
    if_set_definition_string("${out_fw_version}" "${_FW_VERSION}" PARENT_SCOPE)
    if_set_definition_string("${out_build_type}" "${_BUILD_TYPE}" PARENT_SCOPE)

    # Warn about git tag
    execute_process(
        COMMAND git describe --tags
        RESULT_VARIABLE res
        ERROR_QUIET
        OUTPUT_QUIET
    )
    if(res AND NOT res EQUAL 0)
        if(NOT DEFINED ${out_fw_version})
            message(
                WARNING
                "The ${out_fw_version} should be set by git tag but there is no tag"
            )
        endif()
        set(has_git_tag 0)
    else()
        set(has_git_tag 1)
        execute_process(
            COMMAND git describe --tags --always --abbrev=7
            OUTPUT_VARIABLE git_tag
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    endif()

    # Set short git commit hash
    execute_process(
        COMMAND git describe --dirty=+ --always --abbrev=7 --exclude *
        OUTPUT_VARIABLE git_hash
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set_definition_string("${out_git_hash}" "${git_hash}" PARENT_SCOPE)

    # Set git dirty commit
    string(FIND ${git_hash} + res)
    if(res EQUAL -1)
        set_definition_string("${out_git_dirty}" 0 PARENT_SCOPE)
    else()
        set_definition_string("${out_git_dirty}" 1 PARENT_SCOPE)
    endif()
    
    if(${has_git_tag})
        # Set the git tag
        string(REPLACE "-" ";" fw_version_list ${git_tag})
        list(GET fw_version_list 0 git_label)
        set_definition_string("${out_git_tag}" "${git_label}" PARENT_SCOPE)

        # Set the git tag revision
        list(LENGTH fw_version_list len)
        if (len EQUAL 3)
            list(GET fw_version_list 1 git_tag_rev)
            set_definition_string("${out_git_tag_rev}" "${git_tag_rev}" PARENT_SCOPE)
        else()
            set_definition_string("${out_git_tag_rev}" "" PARENT_SCOPE)
        endif()
    else()
        set_definition_string("${out_git_tag}" "" PARENT_SCOPE)
        set_definition_string("${out_git_tag_rev}" "" PARENT_SCOPE)
    endif()

    if(NOT DEFINED ${out_fw_version})
        if(${has_git_tag})
            if(NOT "${git_tag_rev}" STREQUAL "")
                set_definition_string("${out_fw_version}" "${git_label}-${git_tag_rev}" PARENT_SCOPE)
            else()
                set_definition_string("${out_fw_version}" "${git_label}" PARENT_SCOPE)
            endif()
        else()
            set_definition_string("${out_fw_version}" "${git_hash}" PARENT_SCOPE)
        endif()
    endif()

    string(TIMESTAMP build_date "%Y%m%d")
    set_definition_string("${out_build_date}" "${build_date}" PARENT_SCOPE)
    string(TIMESTAMP timestamp)
    set_definition_string("${out_build_time}" "${timestamp}" PARENT_SCOPE)

    # Set user info
    execute_process(
        COMMAND git config user.name 
        OUTPUT_VARIABLE user_name
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set_definition_string("${out_git_user_name}" "${user_name}" PARENT_SCOPE)
    execute_process(
        COMMAND git config user.email 
        OUTPUT_VARIABLE user_email
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set_definition_string("${out_git_user_email}" "${user_email}" PARENT_SCOPE)

    # Set build environment info
    set_definition_string("${out_c_compiler_id}" "${CMAKE_C_COMPILER_ID}" PARENT_SCOPE)
    set_definition_string("${out_c_compiler}" "${CMAKE_C_COMPILER}" PARENT_SCOPE)
    set_definition_string("${out_c_compiler_version}" "${CMAKE_C_COMPILER_VERSION}" PARENT_SCOPE)
    set_definition_string("${out_host_system_name}" "${CMAKE_HOST_SYSTEM}" PARENT_SCOPE)
    set_definition_string("${out_host_system_version}" "${CMAKE_HOST_SYSTEM_VERSION}" PARENT_SCOPE)

    if(NOT "" STREQUAL "${_BOARD_REV}")
        set(board_rev_string @${_BOARD_REV})
    endif()
    
    if(NOT "" STREQUAL "${_BUILD_TYPE}")
        set(build_type_string _${_BUILD_TYPE})
    endif()

    # Set the config string for use in naming files, docs, etc.
    set(
        config_string
        "${_CLIENT_NAME}_${_PROJECT_NAME}_${_BOARD_NAME}${board_rev_string}_${${out_fw_version}}_${git_hash}_${build_date}${build_type_string}"
    )
    string(REPLACE " " "_" config_string ${config_string})
    set_definition_string("${out_full_name}" "${config_string}" PARENT_SCOPE)

endfunction()

#[[
Set the variable `out_variable_name` to the default ic_project() output variable names list.

<out_variable_name> : the name of the CMake variable in which to store the default list

Usage:
    ic_project_out(ic_project_out_vars)
    ic_project(${ic_project_out_vars}
        CLIENT_NAME my_client
        PROJECT_NAME my_project
        BOARD_NAME my_board
    )
#]]
function(ic_project_out out_variable_name)
    set(_IC_OUT_VARIABLES
        IC_CLIENT_NAME
        IC_PROJECT_NAME
        IC_BOARD_NAME
        IC_BOARD_REV
        IC_FW_VERSION
        IC_BUILD_TYPE
        IC_GIT_DIRTY
        IC_GIT_TAG
        IC_GIT_TAG_REV
        IC_GIT_HASH
        IC_GIT_USER_NAME
        IC_GIT_USER_EMAIL
        IC_BUILD_DATE
        IC_BUILD_TIME
        IC_C_COMPILER_ID
        IC_C_COMPILER
        IC_C_COMPILER_VERSION
        IC_HOST_SYSTEM_NAME
        IC_HOST_SYSTEM_VERSION
        IC_FULL_NAME
    )
    set(${out_variable_name} ${_IC_OUT_VARIABLES} PARENT_SCOPE)
endfunction()
