cmake_minimum_required(VERSION 3.16)
project(expresso_fuzz LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(EXPRESSO_SRC ${CMAKE_CURRENT_SOURCE_DIR}/../Expresso/src)

find_package(Qt6 COMPONENTS Core Widgets REQUIRED)

add_executable(fuzz_fromvariant
    fuzz_fromvariant.cpp
    ${EXPRESSO_SRC}/artikl.cpp
    ${EXPRESSO_SRC}/kategorija.cpp
)

target_include_directories(fuzz_fromvariant PRIVATE ${EXPRESSO_SRC})
target_link_libraries(fuzz_fromvariant PRIVATE Qt6::Core Qt6::Widgets)

target_compile_options(fuzz_fromvariant PRIVATE -g -O1 -fsanitize=fuzzer,address)
target_link_options(fuzz_fromvariant PRIVATE -fsanitize=fuzzer,address)

# UI forms required by the dependencies of the full harness.
set(FUZZ_LOAD_FORMS
    ${EXPRESSO_SRC}/naruci.ui
    ${EXPRESSO_SRC}/tableoptions.ui
    ${EXPRESSO_SRC}/unesiartikle.ui
)
qt6_wrap_ui(FUZZ_LOAD_UI_HEADERS ${FUZZ_LOAD_FORMS})

add_executable(fuzz_load
    fuzz_load.cpp
    ${EXPRESSO_SRC}/artikl.cpp
    ${EXPRESSO_SRC}/kategorija.cpp
    ${EXPRESSO_SRC}/meni.cpp
    ${EXPRESSO_SRC}/porudzbina.cpp
    ${EXPRESSO_SRC}/raspored.cpp
    ${EXPRESSO_SRC}/sto.cpp
    ${EXPRESSO_SRC}/binaryserializer.cpp
    ${EXPRESSO_SRC}/naruci.cpp
    ${EXPRESSO_SRC}/tableoptions.cpp
    ${EXPRESSO_SRC}/unesiartikle.cpp
    ${FUZZ_LOAD_FORMS}
)

target_include_directories(fuzz_load PRIVATE ${EXPRESSO_SRC})
target_link_libraries(fuzz_load PRIVATE Qt6::Core Qt6::Widgets)

target_compile_options(fuzz_load PRIVATE -g -O1 -fsanitize=fuzzer,address)
target_link_options(fuzz_load PRIVATE -fsanitize=fuzzer,address)