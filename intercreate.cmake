# Copyright (c) 2023 Intercreate, Inc.

# Sets the following CMake variables
#   FW_VERSION
#   GIT_TAG
#   GIT_TAG_REV  (this is the -1, -2, -3, that counts commits after tag)
#   GIT_HASH
#   BUILD_DATE  (YYYYMMDD)

# And adds the following compile definitions
#   FW_VERSION
#   GIT_TAG
#   GIT_TAG_REV  (this is the -1, -2, -3, that counts commits after tag)
#   GIT_HASH
#   BUILD_DATE  (YYYYMMDD)   

# Set firmware version
execute_process(
    COMMAND git describe --dirty=+ --always --abbrev=7
    OUTPUT_VARIABLE FW_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
add_compile_definitions(FW_VERSION="${FW_VERSION}")
message(STATUS "Firmware version is ${FW_VERSION}")

# Get the GIT tag and tag revision from the FW_VERSION
string(REPLACE "-" ";" _FW_VERSION_LIST ${FW_VERSION})
list(GET _FW_VERSION_LIST 0 GIT_TAG)
list(LENGTH _FW_VERSION_LIST _LEN)
if (_LEN EQUAL 3)
    list(GET _FW_VERSION_LIST 1 GIT_TAG_REV)
    set(GIT_TAG_REV "-${GIT_TAG_REV}")
else()
    set(GIT_TAG_REV "")
endif()

# Set short git commit hash
execute_process(
    COMMAND git describe --dirty=+ --always --abbrev=7 --exclude *
    OUTPUT_VARIABLE GIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

add_compile_definitions(
    GIT_TAG="${GIT_TAG}"
    GIT_TAG_REV="${GIT_TAG_REV}"
    GIT_HASH="${GIT_HASH}"
)
message(STATUS "GIT tag is ${GIT_TAG}")
message(STATUS "GIT tag revision is ${GIT_TAG_REV}")
message(STATUS "Short git hash is ${GIT_HASH}")

# Set build date
string(TIMESTAMP BUILD_DATE "%Y%m%d")
add_compile_definitions(BUILD_DATE="${BUILD_DATE}")
message(STATUS "Today is ${BUILD_DATE}")


macro(_set_default_arg)
    if(NOT DEFINED "_${ARGV1}")
        set("_${ARGV1}" "${ARGV2}")
    endif()
endmacro()

# Create well-named build output files, folder, and archives
function(intercreate_project)
    set(_REQUIRED_KEYWORD_ARGS
        CLIENT_NAME
        HW_VERSION
    )
    set(_OPTIONAL_KEYWORD_ARGS
        PROJECT_NAME
        GIT_TAG_REV
        BUILD_TYPE
        ARTIFACT_PREFIX
        DEPENDS_TARGET
        EXTRA_FILES
    )
    list(APPEND _KEYWORD_ARGS
        ${_REQUIRED_KEYWORD_ARGS}
        ${_OPTIONAL_KEYWORD_ARGS}
    )
    cmake_parse_arguments("" "" "${_KEYWORD_ARGS}" "" ${ARGN})

    _set_default_arg(_PROJECT_NAME ${CMAKE_PROJECT_NAME})
    _set_default_arg(_GIT_TAG_REV "")
    _set_default_arg(_BUILD_TYPE ${CMAKE_BUILD_TYPE})
    _set_default_arg(_ARTIFACT_PREFIX "")
    _set_default_arg(_DEPENDS_TARGET ${CMAKE_PROJECT_NAME})
    _set_default_arg(_EXTRA_FILES "")

    foreach(KEY ${_REQUIRED_KEYWORD_ARGS})
        if(NOT DEFINED "_${KEY}")
            message(FATAL_ERROR "Missing keyword argument ${KEY} in call to ${CMAKE_CURRENT_FUNCTION}()")
        endif()
    endforeach()
    
    set(_cmd "COMMAND ${CMAKE_COMMAND} -E")

    add_custom_target(intercreate_names ALL
        _cmd remove_directory intercreate_output
        _cmd make_directory intercreate_output
    
    )

    
endfunction()