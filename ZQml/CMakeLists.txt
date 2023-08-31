project(ZQml CXX)

file(GLOB QML_FILES qml/*.qml)
set_directory_properties(PROPERTIES CLEAN_NO_CUSTOM TRUE)
file(GLOB TRANSLATION_FILES langs/*.ts)
qt5_create_translation(TRANSLATIONS ${QML_FILES} ${TRANSLATION_FILES})

set(TRANSLATIONS_QRC "${CMAKE_CURRENT_BINARY_DIR}/ts.qrc")
file(WRITE ${TRANSLATIONS_QRC} "<RCC>\n\t<qresource prefix=\"/langs\">")
foreach(QM_FILE ${TRANSLATIONS})
	get_filename_component(QM_FILE_NAME ${QM_FILE} NAME)
	file(APPEND ${TRANSLATIONS_QRC} "\n\t\t<file>${QM_FILE_NAME}</file>")
endforeach()
file(APPEND ${TRANSLATIONS_QRC} "\n\t</qresource>\n</RCC>")

add_library(${PROJECT_NAME} SHARED main.cpp qml.qrc ${TRANSLATIONS_QRC} def.def)
set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "-mwindows -Wl,--exclude-all-symbols")
set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")
target_link_libraries(${PROJECT_NAME} Qt5::Core)

add_custom_command(TARGET ${PROJECT_NAME}
	POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${PROJECT_NAME}> ${CMAKE_SOURCE_DIR}
	COMMAND ${CMAKE_STRIP} ${CMAKE_SOURCE_DIR}/${PROJECT_NAME}.dll
)
