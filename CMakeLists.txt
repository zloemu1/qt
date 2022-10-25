cmake_minimum_required(VERSION 3.9)

cmake_policy(SET CMP0048 NEW)
project(Z VERSION 1 LANGUAGES CXX)

set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_BUILD_TYPE "Release")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt5 COMPONENTS Core Quick QuickControls2 LinguistTools REQUIRED)

add_definitions(-DWIN32 -DUNICODE -DMBEDTLS_NO_DEBUG)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -fno-rtti -std=c++14")

add_subdirectory(ZQml)
add_subdirectory(ZQRes)
if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/ZQt")
	add_subdirectory(ZQt)
endif()
