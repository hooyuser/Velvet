#CMake minimum requirement 
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)

#Project name 
set(PROJECT_NAME "Velvet")
project(${PROJECT_NAME} LANGUAGES CXX C CUDA)  
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_CUDA_STANDARD_REQUIRED TRUE)

if (CMAKE_BUILD_TYPE STREQUAL "")
    set(CMAKE_BUILD_TYPE Release)
endif()

# Direct all output to /bin directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin)

set(SRC_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src)

set(EXTERNAL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/external)

set(SHADERS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/assets/shader)

file(GLOB_RECURSE SHADERS
    "${SHADERS_DIR}/*.vert"
    "${SHADERS_DIR}/*.frag"
    "${SHADERS_DIR}/*.comp"
)

file(GLOB_RECURSE SRC_FILES
	${SRC_DIRECTORY}/*.cu
	${SRC_DIRECTORY}/*.cuh
	${SRC_DIRECTORY}/*.cpp
	${SRC_DIRECTORY}/*.h
	${SRC_DIRECTORY}/*.hpp
)

list(FILTER SRC_FILES EXCLUDE REGEX "test\.cpp$")

file(GLOB_RECURSE EXTERNAL_FILES
	${EXTERNAL_DIR}/*.cu
	${EXTERNAL_DIR}/*.cuh
	${EXTERNAL_DIR}/*.cpp
	${EXTERNAL_DIR}/*.h
	${EXTERNAL_DIR}/*.hpp
)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
find_package(AVX)
find_package(VendorIdentifier)

find_package(glfw3 CONFIG REQUIRED)
find_package(glad CONFIG REQUIRED)
find_package(fmt REQUIRED)
find_package(glm CONFIG REQUIRED)
find_package(assimp CONFIG REQUIRED)
find_package(imgui CONFIG REQUIRED)

add_executable(${PROJECT_NAME}
    ${SRC_FILES}
    ${EXTERNAL_FILES}
    ${SHADERS}
)

target_include_directories(${PROJECT_NAME} PUBLIC 
    ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}
)

target_include_directories(${PROJECT_NAME}
    PUBLIC 
        ${EXTERNAL_DIR}/cuda
        ${EXTERNAL_DIR}/stb_image
)

#Libs linked to the executable
target_link_libraries(${PROJECT_NAME}  
	glfw
    glad::glad
    fmt::fmt
    glm::glm
    assimp::assimp
    imgui::imgui
)

# target_compile_options(cuda_test INTERFACE
#     $<$<COMPILE_LANGUAGE:CXX>:${cxx_flags}>
#     $<$<COMPILE_LANGUAGE:CUDA>:${cuda_flags}>
# )

################################################################################
# Use solution folders feature
################################################################################
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

################################################################################
# Source groups
################################################################################
set(no_group_source_files
    "${SRC_DIRECTORY}/Global.hpp"
    "${SRC_DIRECTORY}/main.cpp"
)
source_group("" FILES ${no_group_source_files})

source_group("External" FILES ${EXTERNAL_FILES})

set(Graphics__Include
    "${SRC_DIRECTORY}/Actor.hpp"
    "${SRC_DIRECTORY}/Camera.hpp"
    "${SRC_DIRECTORY}/Component.hpp"
    "${SRC_DIRECTORY}/GameInstance.hpp"
    "${SRC_DIRECTORY}/GUI.hpp"
    "${SRC_DIRECTORY}/Helper.hpp"
    "${SRC_DIRECTORY}/Input.hpp"
    "${SRC_DIRECTORY}/Light.hpp"
    "${SRC_DIRECTORY}/Material.hpp"
    "${SRC_DIRECTORY}/MaterialProperty.hpp"
    "${SRC_DIRECTORY}/Mesh.hpp"
    "${SRC_DIRECTORY}/MeshRenderer.hpp"
    "${SRC_DIRECTORY}/PlayerController.hpp"
    "${SRC_DIRECTORY}/RenderPipeline.hpp"
    "${SRC_DIRECTORY}/Resource.hpp"
    "${SRC_DIRECTORY}/Scene.hpp"
    "${SRC_DIRECTORY}/Timer.hpp"
    "${SRC_DIRECTORY}/Transform.hpp"
    "${SRC_DIRECTORY}/VtEngine.hpp"
)
source_group("Graphics\\Include" FILES ${Graphics__Include})

set(Graphics__Source
    "${SRC_DIRECTORY}/Actor.cpp"
    "${SRC_DIRECTORY}/Component.cpp"
    "${SRC_DIRECTORY}/GameInstance.cpp"
    "${SRC_DIRECTORY}/GUI.cpp"
    "${SRC_DIRECTORY}/Helper.cpp"
    "${SRC_DIRECTORY}/Input.cpp"
    "${SRC_DIRECTORY}/MeshRenderer.cpp"
    "${SRC_DIRECTORY}/Timer.cpp"
    "${SRC_DIRECTORY}/VtEngine.cpp"
)
source_group("Graphics\\Source" FILES ${Graphics__Source})

set(Physics
    "${SRC_DIRECTORY}/Collider.hpp"
    "${SRC_DIRECTORY}/Common.cuh"
    "${SRC_DIRECTORY}/Common.hpp"
    "${SRC_DIRECTORY}/ParticleGeometryRenderer.hpp"
    "${SRC_DIRECTORY}/ParticleInstancedRenderer.hpp"
    "${SRC_DIRECTORY}/VtBuffer.hpp"
)
source_group("Physics" FILES ${Physics})

set(Physics__ClothSolverCPU
    "${SRC_DIRECTORY}/VtClothObjectCPU.hpp"
    "${SRC_DIRECTORY}/VtClothSolverCPU.hpp"
)
source_group("Physics\\ClothSolverCPU" FILES ${Physics__ClothSolverCPU})

set(Physics__ClothSolverGPU
    "${SRC_DIRECTORY}/MouseGrabber.hpp"
    "${SRC_DIRECTORY}/VtClothObjectGPU.hpp"
    "${SRC_DIRECTORY}/VtClothSolverGPU.cuh"
    "${SRC_DIRECTORY}/VtClothSolverGPU.cu"
    "${SRC_DIRECTORY}/VtClothSolverGPU.hpp"
)
source_group("Physics\\ClothSolverGPU" FILES ${Physics__ClothSolverGPU})

set(Physics__SpatialHash
    "${SRC_DIRECTORY}/SpatialHashCPU.hpp"
    "${SRC_DIRECTORY}/SpatialHashGPU.cuh"
    "${SRC_DIRECTORY}/SpatialHashGPU.cu"
    "${SRC_DIRECTORY}/SpatialHashGPU.hpp"
)
source_group("Physics\\SpatialHash" FILES ${Physics__SpatialHash})

set(Shader
    "${SHADERS_DIR}/_Default.frag"
    "${SHADERS_DIR}/_Default.vert"
    "${SHADERS_DIR}/_ShadowDebug.frag"
    "${SHADERS_DIR}/_ShadowDebug.vert"
    "${SHADERS_DIR}/_ShadowDepth.frag"
    "${SHADERS_DIR}/_ShadowDepth.vert"
    "${SHADERS_DIR}/InfinitePlane.frag"
    "${SHADERS_DIR}/InfinitePlane.vert"
    "${SHADERS_DIR}/UnlitWhite.frag"
    "${SHADERS_DIR}/UnlitWhite.vert"
)
source_group("Shader" FILES ${Shader})

set(Shader__Instanced
    "${SHADERS_DIR}/_InstancedDefault.frag"
    "${SHADERS_DIR}/_InstancedDefault.vert"
    "${SHADERS_DIR}/_InstancedParticle.frag"
    "${SHADERS_DIR}/_InstancedParticle.geom"
    "${SHADERS_DIR}/_InstancedParticle.vert"
    "${SHADERS_DIR}/_InstancedShadowDepth.frag"
    "${SHADERS_DIR}/_InstancedShadowDepth.vert"
)
source_group("Shader\\Instanced" FILES ${Shader__Instanced})

# MSVC Settings
if (MSVC)
    set_target_properties(${PROJECT_NAME} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
    set_target_properties(${PROJECT_NAME} PROPERTIES VS_DPI_AWARE "On")
    set(CXX_FLAGS /Zc:preprocessor /Oi /options:strict /MP)
    # set(cuda_flags )
    target_compile_options(${PROJECT_NAME} PRIVATE
        $<$<COMPILE_LANGUAGE:CXX>:${CXX_FLAGS}>
        #$<$<COMPILE_LANGUAGE:CUDA>:${cuda_flags}>
    )
    # if (${CXX_AVX512_FOUND})
    #     set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "/arch:AVX512")
    # elseif (${CXX_AVX2_FOUND})
    #     set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "/arch:AVX2")
    # endif()
    # message(STATUS "CPU_VENDOR: ${CPU_VENDOR}")
    # if ("${CPU_VENDOR}" STREQUAL "Intel")
    #     set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "/favor:INTEL64")
    # elseif("${CPU_VENDOR}" STREQUAL "AMD")
    #     set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "/favor:AMD64")
    # endif()
endif()


