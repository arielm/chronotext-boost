cmake_minimum_required (VERSION 3.2.2)

project(TestBoost)

find_package(GTest REQUIRED)
find_package(Boost 1.58.0 REQUIRED COMPONENTS system filesystem iostreams)

include_directories(
  ${GTEST_INCLUDE_DIRS}
  ${Boost_INCLUDE_DIRS}
)

add_executable(TestBoost
  TestBoost.cpp
)

target_link_libraries(TestBoost
  ${GTEST_BOTH_LIBRARIES}
  ${Boost_LIBRARIES}
)

enable_testing()
add_test(NAME AllTests COMMAND ./run.sh)
