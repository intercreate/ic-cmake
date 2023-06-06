cmake_minimum_required(VERSION 3.20.0)

include(intercreate.cmake)

project(project_name)

intercreate_project(
    CLIENT_NAME "client name!"
    HW_VERSION FF1
    GIT_TAG 0.1.0
    GIT_HASH abcdef
    BUILD_DATE 2020-20-10
    BUILD_TYPE debug
    ARTIFACT_PREFIX prefix
    RELEASE_DEPENDS zephyr
)