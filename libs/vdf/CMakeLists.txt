cmake_minimum_required(VERSION 2.8.11)

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

list(APPEND CMAKE_MODULE_PATH
     "${CMAKE_CURRENT_LIST_DIR}/cmake"
     "${CMAKE_CURRENT_LIST_DIR}/cmake/packages"
     "${CMAKE_CURRENT_LIST_DIR}/cmake/modules/share/modules/cmake")

cm_project(vdf WORKSPACE_NAME ${CMAKE_WORKSPACE_NAME} LANGUAGES ASM C CXX)

cm_find_package(CM)
include(CMDeploy)
include(CMSetupVersion)

include(CheckSSE)
include(CheckAVX)

include(TargetArchitecture)

if(NOT SSE2_FOUND OR NOT SSE3_FOUND OR NOT SSSE3_FOUND OR NOT SSE4_1_FOUND OR NOT SSE4_2_FOUND)
    check_sse()
endif()

if(NOT HAVE_AVX2_EXTENSIONS OR NOT HAVE_AVX_EXTENSIONS)
    check_avx()
endif()

if(NOT SSE2_FOUND OR NOT SSE3_FOUND OR NOT SSSE3_FOUND OR NOT SSE4_1_FOUND OR NOT SSE4_2_FOUND OR
   HAVE_AVX2_EXTENSIONS OR HAVE_AVX_EXTENSIONS)
    option(CRYPTO3_VDF_USE_SIMD "Build Crypto3.VDF with SIMD instructions usage." FALSE)
endif()

option(CRYPTO3_VDF_NO_BOOST "Build Crypto3.VDF with no Boost usage. Requires GMP and FLINT." FALSE)

if(CRYPTO3_VDF_NO_BOOST)
    message("-- Building Crypto3.VDF with GMP/FLINT backend")

    cm_find_package(GMP REQUIRED)
    cm_find_package(GMPXX REQUIRED)
    cm_find_package(FLINT REQUIRED)
else()
    message("-- Building Crypto3.VDF with Boost.Multiprecision backend")

    cm_find_package(${CMAKE_WORKSPACE_NAME}_multiprecision REQUIRED)
endif()

if(CRYPTO3_VDF_NO_BOOST)
    option(CRYPTO3_VDF_CHIA "Build with Chia VDF support" TRUE)
else()
    option(CRYPTO3_VDF_PIETRZAK "Build with Pietrzak VDF support" TRUE)
    option(CRYPTO3_VDF_WESOLOWSKI "Build with Wesolowski VDF support" TRUE)
    option(CRYPTO3_VDF_CHIA "Build with Chia VDF support" TRUE)
endif()

if(CRYPTO3_VDF_PIETRZAK)
    list(APPEND ${CURRENT_PROJECT_NAME}_PIETRZAK_HEADERS
         include/nil/crypto3/vdf/pietrzak.hpp
         )

    list(APPEND ${CURRENT_PROJECT_NAME}_PUBLIC_HEADERS
         ${${CURRENT_PROJECT_NAME}_PIETRZAK_HEADERS}
         )
endif()

if(CRYPTO3_VDF_WESOLOWSKI)
    list(APPEND ${CURRENT_PROJECT_NAME}_WESOLOWSKI_HEADERS
         include/nil/crypto3/vdf/wesolowski.hpp
         )

    list(APPEND ${CURRENT_PROJECT_NAME}_PUBLIC_HEADERS
         ${${CURRENT_PROJECT_NAME}_WESOLOWSKI_HEADERS}
         )
endif()

if(CRYPTO3_VDF_CHIA)
    list(APPEND ${CURRENT_PROJECT_NAME}_CHIA_HEADERS
         include/nil/crypto3/vdf/chia.hpp
         )

    list(APPEND ${CURRENT_PROJECT_NAME}_PUBLIC_HEADERS
         ${${CURRENT_PROJECT_NAME}_CHIA_HEADERS}
         )
endif()

list(APPEND ${CURRENT_PROJECT_NAME}_PUBLIC_HEADERS

     )

list(APPEND ${CURRENT_PROJECT_NAME}_UNGROUPED_SOURCES
     )

list(APPEND ${CURRENT_PROJECT_NAME}_HEADERS
     ${${CURRENT_PROJECT_NAME}_PUBLIC_HEADERS}
     )

list(APPEND ${CURRENT_PROJECT_NAME}_SOURCES
     ${${CURRENT_PROJECT_NAME}_UNGROUPED_SOURCES}
     )

cm_setup_version(VERSION 0.1.0 PREFIX ${CMAKE_WORKSPACE_NAME}_${CURRENT_PROJECT_NAME})

add_library(${CMAKE_WORKSPACE_NAME}_${CURRENT_PROJECT_NAME} INTERFACE)

if(SSE2_FOUND OR SSE3_FOUND OR SSSE3_FOUND OR SSE4_1_FOUND OR SSE4_2_FOUND)
    target_compile_options(${CMAKE_WORKSPACE_NAME}_${CURRENT_PROJECT_NAME} INTERFACE "-mpclmul;-mssse3")
    target_compile_definitions(${CMAKE_WORKSPACE_NAME}_${CURRENT_PROJECT_NAME} INTERFACE
                               "${CMAKE_UPPER_WORKSPACE_NAME}_HAS_CHIA_VDF_SIMD")
endif()

target_compile_options(${CMAKE_WORKSPACE_NAME}_${CURRENT_PROJECT_NAME} INTERFACE "$<$<CONFIG:RELEASE>:-O3;-fno-rtti>")

if(CRYPTO3_VDF_NO_BOOST)
    target_compile_definitions(${CMAKE_WORKSPACE_NAME}_${CURRENT_PROJECT_NAME} INTERFACE CRYPTO3_VDF_NO_BOOST)
endif()

set_target_properties(${CMAKE_WORKSPACE_NAME}_${CURRENT_PROJECT_NAME} PROPERTIES
                      EXPORT_NAME ${CURRENT_PROJECT_NAME})

if(CRYPTO3_VDF_NO_BOOST)
    target_include_directories(${CMAKE_WORKSPACE_NAME}_${CURRENT_PROJECT_NAME} INTERFACE
                               "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
                               "$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/include>"

                               ${GMP_INCLUDE_DIR}
                               ${GMPXX_INCLUDE_DIR}
                               ${FLINT_INCLUDE_DIR})

    target_link_libraries(${CMAKE_WORKSPACE_NAME}_${CURRENT_PROJECT_NAME} INTERFACE
                          ${GMP_LIBRARIES} ${GMPXX_LIBRARIES} ${FLINT_LIBRARIES})
else()
    target_include_directories(${CMAKE_WORKSPACE_NAME}_${CURRENT_PROJECT_NAME} INTERFACE
                               "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
                               "$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/include>")

    target_link_libraries(${CMAKE_WORKSPACE_NAME}_${CURRENT_PROJECT_NAME} INTERFACE boost::multiprecision)
endif()

cm_deploy(TARGETS ${CMAKE_WORKSPACE_NAME}_${CURRENT_PROJECT_NAME}
          INCLUDE include
          NAMESPACE ${CMAKE_WORKSPACE_NAME}::)


if(BUILD_UNIT_TESTS)
    add_subdirectory(test)
endif()