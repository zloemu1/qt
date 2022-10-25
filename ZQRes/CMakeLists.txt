project(ZQRes CXX)

add_library(${PROJECT_NAME} SHARED main.cpp qml.qrc def.def)
set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "-mwindows -Wl,--exclude-all-symbols")
set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")
target_link_libraries(${PROJECT_NAME} Qt5::Core)

add_custom_command(TARGET ${PROJECT_NAME}
	POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${PROJECT_NAME}> ${CMAKE_SOURCE_DIR}
	COMMAND ${CMAKE_STRIP} ${CMAKE_SOURCE_DIR}/${PROJECT_NAME}.dll
)
