# Copyright (c) 2023 Intercreate, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: J.P. Hutchins <jp@intercreate.io>

include_guard(GLOBAL)

include(${CMAKE_CURRENT_LIST_DIR}/ic_utils.cmake)

function(_add_artifact out_artifact_list
    bundle_target bundle_dir prefix postfix name dependency
)
    set(srcfile "${prefix}${postfix}")
    set(dstfile "${bundle_dir}/${name}${postfix}")
    add_custom_command(
        OUTPUT "${dstfile}"
        DEPENDS "${dependency}" "${srcfile}"
        COMMAND ${CMAKE_COMMAND} -E copy "${srcfile}" "${dstfile}"
    )
    list(APPEND ${out_artifact_list} "${dstfile}")
    set(${out_artifact_list} ${${out_artifact_list}} PARENT_SCOPE)
endfunction()

#[[
Add build targets that will create a distributable bundle of build artifacts.

Default artifacts:
    *.elf
    *.bin
    *.hex
    *.map

The bundle will be generated at ${BUNDLE_DIR}/${FULL_NAME} dir and zip.

FULL_NAME <name>
    The project configuration description string, e.g. ${IC_FULL_NAME}

[PREFIX <prefix>] default: ${PROJECT_NAME}
    The path prefix to the artifacts within the build folder.  For Zephyr
    projects, this is probably `zephyr/zephyr`.

[EXTRA_POSTFIXES <postfix list>] default: [empty cmake list]
    A list of extra artifact prefixes to add, for example:
        EXTRA_POSTFIXES -merged.hex -app-signed.hex -app-update-s-e.gbl
    Would rename and copy targets like "zephyr-merged.hex",
    "zephyr-app-update-s-e.gbl", to "${FULL_NAME}-merged.hex"
    "${FULL_NAME}-app-update-s-e.gbl" etc.

[EXTRA_FILES <file paths list>] default: [empty cmake list]
    A list of paths to extra build artifacts that should be bundled, example:
        EXTRA_FILES "${CMAKE_BINARY_DIR}/bootloader/zephyr/zephyr.hex"

[DEPENDS <target>] default: ${PROJECT_NAME}
    The target to depend on for the bundle target.  For Zephyr projects, this
    is probably `zephyr_final`.

[BUNDLE_DIR <path>] default: "${CMAKE_BINARY_DIR}/${_FULL_NAME}"
    The name for the created bundle folder and zip, e.g. 
    "${CMAKE_SOURCE_DIR}/my_build/my_bundle_name"

]]#
function(ic_bundle)
    set(required_keyword_args
        FULL_NAME
    )
    set(optional_keyword_args
        PREFIX
        EXTRA_FILES
        EXTRA_POSTFIXES
        DEPENDS
        BUNDLE_DIR
    )
    list(APPEND keyword_args
        ${required_keyword_args}
        ${optional_keyword_args}
    )
    cmake_parse_arguments(PARSE_ARGV 0 "" "" "${keyword_args}" "")

    if(_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unparsed arguments: ${_UNPARSED_ARGUMENTS}")
    endif()

    set_default(_PREFIX "${PROJECT_NAME}")
    set_default(_EXTRA_FILES "")
    set_default(_EXTRA_POSTFIXES "")
    set_default(_DEPENDS "${PROJECT_NAME}")
    set_default(_BUNDLE_DIR "${CMAKE_BINARY_DIR}/${_FULL_NAME}")

    macro(add_artifact postfix)
        _add_artifact(artifact_list
            bundle
            "${_BUNDLE_DIR}"
            "${_PREFIX}"
            "${postfix}"
            "${_FULL_NAME}"
            "${_DEPENDS}"
        )
    endmacro()

    add_artifact(.elf)
    add_artifact(.bin)
    add_artifact(.hex)
    add_artifact(.map)

    foreach(extra_postfix ${_EXTRA_POSTFIXES})
        add_artifact("${extra_postfix}")
    endforeach()
    
    add_custom_command(
        OUTPUT "${_FULL_NAME}.zip"
        COMMAND ${CMAKE_COMMAND} -E tar cf "${_FULL_NAME}.zip" --format=zip "${_FULL_NAME}"
        DEPENDS ${artifact_list}
    )

    add_custom_target(
        bundle
        ALL
        DEPENDS ${artifact_list} "${_FULL_NAME}.zip"
    )

endfunction()
