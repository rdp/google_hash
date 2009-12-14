#include <iostream>
#include <google/sparse_hash_map>

using google::sparse_hash_map;      // namespace where class lives by default
using std::cout;
using std::endl;
using __gnu_cxx::hash;  // or __gnu_cxx::hash, or maybe tr1::hash, depending on your OS

struct eqstr
{
  bool operator()(const char* s1, const char* s2) const
  {
    return (s1 == s2) || (s1 && s2 && strcmp(s1, s2) == 0);
  }
};

int main()
{
  sparse_hash_map<const char*, int, hash<const char*>, eqstr> months;
  
  months["january"] = 31;
  months["february"] = 28;
  months["march"] = 31;
  months["april"] = 30;
  months["may"] = 31;
  months["june"] = 30;
  months["july"] = 31;
  months["august"] = 31;
  months["september"] = 30;
  months["october"] = 31;
  months["november"] = 30;
  months["december"] = 31;
  
  cout << "september -> " << months["september"] << endl;
  cout << "april     -> " << months["april"] << endl;
  cout << "june      -> " << months["june"] << endl;
  cout << "november  -> " << months["november"] << endl;

  for(sparse_hash_map<const char*, int, hash<const char*>, eqstr>::iterator it = months.begin(); it != months.end(); ++it) {
    cout << "h";
  }
   
}

/*


   for (sparse_hash_map<int*, ComplicatedClass>::iterator it = ht.begin();
        it != ht.end(); ++it) {
       // The key is stored in the sparse_hash_map as a pointer
       const_cast<int*>(it->first) = new int;
       fread(const_cast<int*>(it->first), sizeof(int), 1, fp);
       // The value is a complicated C++ class that takes an int to construct
       int ctor_arg;
       fread(&ctor_arg, sizeof(int), 1, fp);
       new (&it->second) ComplicatedClass(ctor_arg);  // "placement new"
   }
*/
