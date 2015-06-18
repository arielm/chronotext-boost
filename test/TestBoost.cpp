/*
 * REFERENCE: https://github.com/arielm/chronotext-boost/wiki/Testing-instructions
 */

#include <iostream>

#include <boost/algorithm/string.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/filesystem.hpp>

#include <boost/iostreams/device/back_inserter.hpp>
#include <boost/iostreams/filtering_stream.hpp>
#include <boost/iostreams/stream.hpp>

#include <gtest/gtest.h>

using namespace std;

namespace fs = boost::filesystem;
namespace io = boost::iostreams;

TEST(TestBoost, TestIEquals)
{
  ASSERT_TRUE(boost::iequals("foo", "FOO"));
}

TEST(TestBoost, TestLexicalCast)
{
  EXPECT_EQ(12345, boost::lexical_cast<int>("12345"));
  EXPECT_EQ(33.33, boost::lexical_cast<double>("33.33"));
}

TEST(TestBoost, TestFileSystem)
{
  fs::path documents("/Users/arielm/Documents");
  fs::path filePath = documents / "bar.jpg";

  EXPECT_EQ("/Users/arielm/Documents/bar.jpg", filePath.string());
}

TEST(TestBoost, TestFilteringStream)
{
  vector<char> store;
  {
    io::filtering_ostream out;
    out.push(io::back_insert_device<vector<char>>(store));
        
    double d = 123.456;
    int32_t ui = 99;
    
    out << "ABC" << '\n';
    out.write(reinterpret_cast<const char*>(&d), sizeof(d));
    out.write(reinterpret_cast<const char*>(&ui), sizeof(ui));
  }

  EXPECT_EQ(16, store.size());

  {
    io::filtering_istream in;
    in.push(io::basic_array_source<char>(store.data(), store.size()));

    // ---

    string line;
    std::getline(in, line);
    EXPECT_EQ("ABC", line);
    EXPECT_EQ(12, in.rdbuf()->in_avail());
    
    double d;
    in.read(reinterpret_cast<char*>(&d), sizeof(d));
    EXPECT_EQ(123.456, d);
    
    uint32_t ui;
    in.read(reinterpret_cast<char*>(&ui), sizeof(ui));
    EXPECT_EQ(99, ui);
    
    EXPECT_EQ(16, in.tellg());

    // ---

    const std::type_info &ti = in.component_type(0);

    /*
     * FIXME: NOT COMPATIBLE WITH VISUAL-STUDIO
     */
    int status;
    char *realname = abi::__cxa_demangle(ti.name(), 0, 0, &status);

    ASSERT_EQ(0, status);
    ASSERT_STREQ("boost::iostreams::basic_array_source<char>", realname);
    
    free(realname);

    // ---

    auto component = in.component<io::basic_array_source<char>>(0);
    auto seq = component->input_sequence();

    EXPECT_EQ(16, int(seq.second - seq.first));
  }
}
