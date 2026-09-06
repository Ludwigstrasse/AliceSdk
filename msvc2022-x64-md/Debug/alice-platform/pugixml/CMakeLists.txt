##########################################################################################################
#--Date:    2023.02.19
#--Project: pugixml
#--Author:  hananiah
##########################################################################################################
message("=====================================Start pugixml=======================================")
message("${PROJECT_SOURCE_DIR}")

FILE(GLOB SOURCE_CPP_FILES "${PROJECT_SOURCE_DIR}/Externals/pugixml/*.cpp")
FILE(GLOB HEADER_H_FILES   "${PROJECT_SOURCE_DIR}/Externals/pugixml/*.hpp")

source_group("Header Files" FILES ${HEADER_H_FILES})
source_group("Source Files" FILES ${SOURCE_CPP_FILES})


#-----------------------------------------------------------------------------
# @ 设置制品的输出路径
# @ 定义项目构建中间文件的生成目录
# @ 必须放在add_library之前，否则无效
#-----------------------------------------------------------------------------
# 用指针位数决定输出目录：x64 / x86
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(SD_ARCH "x64")
elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
  set(SD_ARCH "x86")
else()
  message(FATAL_ERROR "Unknown pointer size: ${CMAKE_SIZEOF_VOID_P}")
endif()

# Linux 侧需要 GNUInstallDirs 提供 CMAKE_INSTALL_LIBDIR/BINDIR
if(UNIX AND NOT APPLE)
  include(GNUInstallDirs)
endif()

# 防止误开关：Linux 下不允许走 SOLIDRENDER_WIN 分支
if(SOLIDRENDER_WIN AND NOT WIN32)
  message(FATAL_ERROR "SOLIDRENDER_WIN=ON but WIN32=OFF. Disable SOLIDRENDER_WIN on Linux.")
endif()

if(SOLIDRENDER_WIN)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/${SD_ARCH}/Debug)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/${SD_ARCH}/Debug)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/${SD_ARCH}/Debug)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/${SD_ARCH}/Release)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/${SD_ARCH}/Release)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/${SD_ARCH}/Release)

elseif(SOLIDRENDER_LINUX)  
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/${CMAKE_INSTALL_LIBDIR})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/${CMAKE_INSTALL_LIBDIR})
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

#=============================================================================
#指定工程为动态库程序
add_library(pugixml SHARED ${HEADER_H_FILES} ${SOURCE_CPP_FILES} )

set_target_properties(pugixml PROPERTIES FOLDER "Externals")
#=============================================================================

if(WIN32)
  target_compile_definitions(pugixml PRIVATE _WINDOWS)
endif()

#-----------------------------------------------------------------------------
# 头文件搜索路径
#-----------------------------------------------------------------------------
include_directories(${CMAKE_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

#-----------------------------------------------------------------------------
# 根据系统及机器位数设置链接的位数
# 必须放在link之后,否则设置无效
#-----------------------------------------------------------------------------

if(WIN32)
    # include the major version number in Windows shared library names (but not import library names)
    set_target_properties(pugixml PROPERTIES DEBUG_POSTFIX "")
    set_target_properties(pugixml PROPERTIES SUFFIX "${CMAKE_SHARED_LIBRARY_SUFFIX}")
else()
    set_target_properties(pugixml PROPERTIES DEBUG_POSTFIX "d")
endif()
if (WIN32 AND MINGW)
    # on Windows/gcc get rid of "lib" prefix for shared libraries,
    # and transform the ".dll.a" suffix into ".a" for import libraries
    set_target_properties(pugixml PROPERTIES PREFIX "")
    set_target_properties(pugixml PROPERTIES IMPORT_SUFFIX ".a")
endif()


message("=====================================End pugixml==========================================")