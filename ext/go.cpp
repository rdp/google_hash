#include <iostream>
#include <google/sparse_hash_map>
#include <ruby.h>

using google::sparse_hash_map;      // namespace where class lives by default
using std::cout;
using std::endl;
using __gnu_cxx::hash;  // or __gnu_cxx::hash, or maybe tr1::hash, depending on your OS
extern "C" {

struct eqstr
{
  bool operator()(const char* s1, const char* s2) const
  {
    return (s1 == s2) || (s1 && s2 && strcmp(s1, s2) == 0);
  }
};


struct eqint
{
  inline bool operator()(int s1, int s2) const
  {
    return s1 == s2;
  }
};

typedef struct {
  sparse_hash_map<int, VALUE, hash<int>, eqint> *hash_map;
} RCallback;

static VALUE rb_cGoogleHashSmall;


static void mark_hash_map_values(RCallback incoming) {} // TODO, etc.

static VALUE callback_alloc _((VALUE)); // what does this line do?

static VALUE
callback_alloc( VALUE klass )
{
    VALUE cb;
    RCallback* cbs;
    cb = Data_Make_Struct(klass, RCallback, /*mark_mri_callback*/ 0, 0 /*free_mri_callback*/, cbs);
    cbs->hash_map = new sparse_hash_map<int, VALUE, hash<int>, eqint>();
    sparse_hash_map<int, int> a;
    a[35] = 47;
    sparse_hash_map<int, int, hash<int>, eqint> *a2 = new sparse_hash_map<int, int, hash<int>, eqint>;
    (*a2)[35] = 37;
    (*cbs->hash_map)[33] = 35;
    return cb;
}

#define GetCallbackStruct(obj)	(Check_Type(obj, T_DATA), (RCallback*)DATA_PTR(obj))

static VALUE
rb_mri_hash_new(VALUE freshly_created) {

  // we don't actually have anything special to do here...
  return freshly_created;
}

int main()
{
  sparse_hash_map<const char*, int, hash<const char*>, eqstr> months;
  
  months["april"] = 30;
  
  cout << "april     -> " << months["april"] << endl;
  cout << "iterating";
  for(sparse_hash_map<const char*, int, hash<const char*>, eqstr>::iterator it = months.begin(); it != months.end(); ++it) {
    cout << it->first;
  }
   
}

static VALUE rb_ghash_set(VALUE cb, VALUE set_this, VALUE to_this) {
  cout << "got set this" << FIX2INT(set_this) << "and to_this ruby" << FIX2INT(to_this);
  RCallback* cbs = GetCallbackStruct(cb);
  (*cbs->hash_map)[FIX2INT(set_this)] = to_this;  
  return to_this; // ltodo test that it returns value...
}

static VALUE rb_ghash_get(VALUE cb, VALUE get_this) {
  RCallback* cbs = GetCallbackStruct(cb);
  cout << "retrieving  from key..." << FIX2INT(get_this);
  VALUE out = (*cbs->hash_map)[FIX2INT(get_this)];
  cout << 'returning almost:' << out << "  might be integer -> " << INT2FIX(out) << "\n";
  // todo if out == 0 return Qnil
  return out;
}

void Init_google_hash() {
    rb_cGoogleHashSmall = rb_define_class("GoogleHashSmall", rb_cObject);

    rb_define_alloc_func(rb_cGoogleHashSmall, callback_alloc); // I guess it calls this for us, pre initialize... 

    rb_define_method(rb_cGoogleHashSmall, "initialize", RUBY_METHOD_FUNC(rb_mri_hash_new), 0); 
    rb_define_method(rb_cGoogleHashSmall, "[]=", RUBY_METHOD_FUNC(rb_ghash_set), 2); 
    rb_define_method(rb_cGoogleHashSmall, "[]", RUBY_METHOD_FUNC(rb_ghash_get), 1); 


    main();

  } 
}

