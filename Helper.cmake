set(CMAKE_DEBUG_POSTFIX d)

macro(SetOption option value)
  set(${option} ${value} CACHE "" INTERNAL FORCE)
endmacro()

SetOption(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

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
