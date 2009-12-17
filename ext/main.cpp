extern "C" {
#include <ruby.h>
extern void init_dense();
extern void init_sparse();

void Init_google_hash() {
  init_dense();
  init_sparse();
  rb_eval_string("GoogleHash = GoogleHashDense");
}
}

