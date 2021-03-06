# Function for building single example
function(buildExample EXAMPLE_NAME)
	SET(EXAMPLE_FOLDER ${CMAKE_CURRENT_SOURCE_DIR}/${EXAMPLE_NAME})
	message(STATUS "Generating project file for example in ${EXAMPLE_FOLDER}")
	# Main
	file(GLOB SOURCE *.cpp ${BASE_HEADERS} ${EXAMPLE_FOLDER}/*.cpp)
	SET(MAIN_CPP ${EXAMPLE_FOLDER}/${EXAMPLE_NAME}.cpp)
	if(EXISTS ${EXAMPLE_FOLDER}/main.cpp)
		SET(MAIN_CPP ${EXAMPLE_FOLDER}/main.cpp)
	ENDIF()
	# imgui example requires additional source files
	IF(${EXAMPLE_NAME} STREQUAL "imgui")
		file(GLOB ADD_SOURCE "../external/imgui/*.cpp")
		SET(SOURCE ${SOURCE} ${ADD_SOURCE})
	ENDIF()
	# Add shaders
	set(SHADER_DIR "../data/shaders/${EXAMPLE_NAME}")
	file(GLOB SHADERS "${SHADER_DIR}/*.vert" "${SHADER_DIR}/*.frag" "${SHADER_DIR}/*.comp" "${SHADER_DIR}/*.geom" "${SHADER_DIR}/*.tesc" "${SHADER_DIR}/*.tese")
	source_group("Shaders" FILES ${SHADERS})
	if(WIN32)
		add_executable(${EXAMPLE_NAME} WIN32 ${MAIN_CPP} ${SOURCE} ${SHADERS})
		target_link_libraries(${EXAMPLE_NAME} base ${Vulkan_LIBRARY} ${ASSIMP_LIBRARIES} ${WINLIBS})
	else(WIN32)
		add_executable(${EXAMPLE_NAME} ${MAIN_CPP} ${SOURCE} ${SHADERS})
		target_link_libraries(${EXAMPLE_NAME} base )
	endif(WIN32)

	set_target_properties(${EXAMPLE_NAME} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

	if(RESOURCE_INSTALL_DIR)
		install(TARGETS ${EXAMPLE_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
	endif()
endfunction(buildExample)

# Build all examples
function(buildExamples)
	foreach(EXAMPLE ${EXAMPLES})
		buildExample(${EXAMPLE})
	endforeach(EXAMPLE)
endfunction(buildExamples)

set(EXAMPLES
	deferred
	imgui
    primitive_point_particle
	projection_perspective_lighting
	projection_perspective_lookat
	projection_perspective_quad
	projection_perspective_specialfullscreen_texture
	projection_perspective_specialfullscreen_texture_novertex
	projection_perspective_texture
	projection_perspective_texture_mapping
	projection_perspective_texture_mapping_addressmode
    projection_perspective_texture_mapping_notfullscreen_fulltexture
    projection_perspective_texture_mapping_notfullscreen_parttexture
    projection_perspective_mesh_quad
    projection_perspective_mesh_sphere
    raytracing_plane
    raytracing_quad
    raytracing_shadow
    raytracing_skybox
    raytracing_sphere
    raytracing_triangle
	shadowmapping
	vr_lens_distorter
)

buildExamples()
