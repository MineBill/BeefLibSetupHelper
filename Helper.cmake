# cmake_minimum_required(VERSION 3.20)
# project("Tracy-Native")

set(CMAKE_DEBUG_POSTFIX d)

macro(SetOption option value)
  set(${option} ${value} CACHE "" INTERNAL FORCE)
endmacro()

SetOption(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
# SetOption(TRACY_ON_DEMAND ON)
# SetOption(TRACY_CALLSTACK ON)

# include(FetchContent)
# FetchContent_Declare(
#     tracy
#     GIT_REPOSITORY https://github.com/wolfpld/tracy
#     GIT_TAG v0.11.1
# )
# FetchContent_MakeAvailable(tracy)

# add_custom_target(build_libs
#     DEPENDS TracyClient
#     COMMENT "Building tracy"
# )

add_custom_target(CopyLibsTarget ALL
    COMMENT "Copying library files"
)

function(CopyLibrary target destination)
    if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
        set(PLATFORM_SUFFIX "Win64")
    elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
        set(PLATFORM_SUFFIX "Linux64")
    else()
        message(FATAL_ERROR "Unsupported platform: ${CMAKE_SYSTEM_NAME}")
    endif()
    add_custom_command(TARGET CopyLibsTarget POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_SOURCE_DIR}/${destination}/$<CONFIG>-${PLATFORM_SUFFIX}"
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${target}> "${CMAKE_SOURCE_DIR}/${destination}/$<CONFIG>-${PLATFORM_SUFFIX}"
    COMMENT "Copying ${target} library to ${CMAKE_SOURCE_DIR}/${destination}/$<CONFIG>-${PLATFORM_SUFFIX}"
)
endfunction()

# CopyLibrary(TracyClient "dist")

