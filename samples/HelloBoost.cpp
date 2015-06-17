/*
 * REFERENCE: https://github.com/arielm/chronotext-boost/wiki/Basic-code-sample
 */

#include <iostream>
 
#include <boost/algorithm/string.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/filesystem.hpp>

#include <boost/iostreams/device/back_inserter.hpp>
#include <boost/iostreams/filtering_stream.hpp>
#include <boost/iostreams/stream.hpp>

using namespace std;

namespace fs = boost::filesystem;
namespace io = boost::iostreams;

static void writeToStream(io::filtering_ostream &out)
{
  double d = 123.456;
  int32_t ui = 99;
  
  out << "ABC" << '\n';
  out.write(reinterpret_cast<const char*>(&d), sizeof(d));
  out.write(reinterpret_cast<const char*>(&ui), sizeof(ui));
}

static void readFromStream(io::filtering_istream &in)
{
  string line; std::getline(in, line);
  cout << line << " | " << in.rdbuf()->in_avail() << endl;
  
  double d; in.read(reinterpret_cast<char*>(&d), sizeof(d));
  cout << d << endl;
  
  uint32_t ui; in.read(reinterpret_cast<char*>(&ui), sizeof(ui));
  cout << ui << endl;
  
  cout << in.tellg() << endl;
  
  // ---
  
  /*
   * CHECKING THE "IDENTITY" OF THE 1ST COMPONENT VIA RTTI
   */
  const std::type_info &info = in.component_type(0);
  cout << info.name() << endl;
  
  /*
   * ASSUMING THE 1ST COMPONENT IS A io::basic_array_source<char>
   */
  auto component = in.component<io::basic_array_source<char>>(0);
  
  auto seq = component->input_sequence();
  cout << reinterpret_cast<void*>(seq.first) << ", " << reinterpret_cast<void*>(seq.second) << " | " << int(seq.second - seq.first) << endl;
}

int main()
{
  string input = "12345";

  if (boost::iequals(input, "foo"))
  {
    cout << input << endl;
  }
  else
  {
    auto tmp = boost::lexical_cast<int>(input);
    cout << tmp << endl;
  }

  if (true)
  {
    fs::path documents("/Users/arielm/Documents");
    fs::path filePath = documents / "bar.jpg";
    cout << filePath.string() << endl;
  }

  if (true)
  {
    vector<char> store;
    {
      io::filtering_ostream out;
      out.push(io::back_insert_device<vector<char>>(store));
      
      writeToStream(out);
    }
    
    cout << store.size() << endl;

    {
      io::filtering_istream in;
      in.push(io::basic_array_source<char>(store.data(), store.size()));
      
      readFromStream(in);
    }
  }

  return 0;
}
