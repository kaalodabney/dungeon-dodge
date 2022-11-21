#ifndef DRAGONRUBY_DRAGONRUBY_H
#define DRAGONRUBY_DRAGONRUBY_H

#include <mruby.h>
#include <stdlib.h>
#if defined(_WIN32)
#include <windows.h>
#endif

#if defined(_WIN32)
#define DRB_FFI_EXPORT __declspec(dllexport)
#elif defined(__GNUC__) || defined(__clang__)
#define DRB_FFI_EXPORT __attribute__((visibility("default")))
#else
#define DRB_FFI_EXPORT
#endif

#ifndef __DRB_ANNOTATE
#define __DRB_ANNOTATE(key, value) __attribute__((annotate(key #value)))
#endif

#ifndef DRB_FFI_NAME
#define DRB_FFI_NAME(name) __DRB_ANNOTATE("drb_ffi:", name)
#endif

#ifndef DRB_FFI
#define DRB_FFI __DRB_ANNOTATE("drb_ffi:", )
#endif

typedef enum drb_foreign_object_kind {
  drb_foreign_object_kind_struct,
  drb_foreign_object_kind_pointer
} drb_foreign_object_kind;

typedef struct drb_foreign_object {
  drb_foreign_object_kind kind;
} drb_foreign_object;

struct mrb_state;
struct RClass;
struct RData;
struct mrb_data_type;

typedef struct drb_api_t {
  void (*mrb_raise)(struct mrb_state *mrb, struct RClass *c, const char *msg);
  void (*mrb_raisef)(struct mrb_state *mrb, struct RClass *c, const char *fmt, ...);
  struct RClass *(*mrb_module_get)(struct mrb_state *mrb, const char *name);
  struct RClass *(*mrb_module_get_under)(struct mrb_state *mrb, struct RClass *outer,
                                         const char *name);
  struct RClass *(*mrb_define_module_under)(struct mrb_state *mrb, struct RClass *outer,
                                            const char *name);
  struct RClass *(*mrb_class_get_under)(struct mrb_state *mrb, struct RClass *outer,
                                        const char *name);
  struct RClass *(*mrb_define_class_under)(struct mrb_state *mrb, struct RClass *outer,
                                           const char *name, struct RClass *super);
  void (*mrb_define_module_function)(struct mrb_state *mrb, struct RClass *cla, const char *name,
                                     mrb_func_t fun, mrb_aspec aspec);
  void (*mrb_define_method)(struct mrb_state *mrb, struct RClass *cla, const char *name,
                            mrb_func_t func, mrb_aspec aspec);
  void (*mrb_define_class_method)(struct mrb_state *mrb, struct RClass *cla, const char *name,
                                  mrb_func_t fun, mrb_aspec aspec);
  int64_t (*mrb_get_args)(struct mrb_state *mrb, mrb_args_format format, ...);
  mrb_value (*mrb_str_new_cstr)(struct mrb_state *, const char *);
  struct RData *(*mrb_data_object_alloc)(struct mrb_state *mrb, struct RClass *klass, void *ptr,
                                         const struct mrb_data_type *type);

  void (*drb_free_foreign_object)(struct mrb_state *mrb, void *ptr);
  void (*drb_typecheck_float)(struct mrb_state *mrb, mrb_value self);
  void (*drb_typecheck_int)(struct mrb_state *mrb, mrb_value self);
  void (*drb_typecheck_bool)(struct mrb_state *mrb, mrb_value self);
  mrb_value (*drb_float_value)(struct mrb_state *mrb, mrb_float f);
  struct RClass *(*drb_getruntime_error)(struct mrb_state *mrb);
  struct RClass *(*drb_getargument_error)(struct mrb_state *mrb);
  void (*drb_typecheck_aggregate)(struct mrb_state *mrb, mrb_value self, struct RClass *expected,
                                  struct mrb_data_type *data_type);
  void (*drb_upload_pixel_array)(const char *name, const int w, const int h, const uint32_t *pixels);
  void *(*drb_load_image)(const char *fname, int *w, int *h);
  void (*drb_free_image)(void *pixels);
  void (*drb_log_write)(const char *subsystem, const int level, const char *str);
} drb_api_t;

#endif // DRAGONRUBY_DRAGONRUBY_H
