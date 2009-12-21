extern "C" {
#include <ruby.h>
extern void init_dense();
extern void init_sparse();
int main();

void Init_google_hash() {
  init_dense();
  init_sparse();
    main();
  rb_eval_string("GoogleHash = GoogleHashDense");
}
}

