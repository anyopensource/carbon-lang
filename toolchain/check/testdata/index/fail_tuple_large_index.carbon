// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/index/fail_tuple_large_index.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/index/fail_tuple_large_index.carbon

var a: (i32,) = (12,);
var b: (i32,) = a;
// CHECK:STDERR: fail_tuple_large_index.carbon:[[@LINE+4]]:14: ERROR: Tuple element index `1` is past the end of type `(i32,)`.
// CHECK:STDERR: var c: i32 = b[1];
// CHECK:STDERR:              ^~~~
// CHECK:STDERR:
var c: i32 = b[1];
// CHECK:STDERR: fail_tuple_large_index.carbon:[[@LINE+3]]:14: ERROR: Tuple element index `2147483647` is past the end of type `(i32,)`.
// CHECK:STDERR: var d: i32 = b[0x7FFF_FFFF];
// CHECK:STDERR:              ^~~~~~~~~~~~~~
var d: i32 = b[0x7FFF_FFFF];

// CHECK:STDOUT: --- fail_tuple_large_index.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Int32.type: type = fn_type @Int32 [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Int32: %Int32.type = struct_value () [template]
// CHECK:STDOUT:   %.2: type = tuple_type (type) [template]
// CHECK:STDOUT:   %.3: type = tuple_type (i32) [template]
// CHECK:STDOUT:   %.4: i32 = int_literal 12 [template]
// CHECK:STDOUT:   %tuple: %.3 = tuple_value (%.4) [template]
// CHECK:STDOUT:   %.5: i32 = int_literal 1 [template]
// CHECK:STDOUT:   %.6: i32 = int_literal 2147483647 [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT:   %import_ref.2: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT:   %import_ref.3: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT:   %import_ref.4: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .a = %a
// CHECK:STDOUT:     .b = %b
// CHECK:STDOUT:     .c = %c
// CHECK:STDOUT:     .d = %d
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %Core: <namespace> = namespace %Core.import, [template] {
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/operators
// CHECK:STDOUT:     import Core//prelude/types
// CHECK:STDOUT:     import Core//prelude/operators/arithmetic
// CHECK:STDOUT:     import Core//prelude/operators/bitwise
// CHECK:STDOUT:     import Core//prelude/operators/comparison
// CHECK:STDOUT:     import Core//prelude/types/bool
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %int.make_type_32.loc11: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc11_13.1: %.2 = tuple_literal (%int.make_type_32.loc11)
// CHECK:STDOUT:   %.loc11_13.2: type = value_of_initializer %int.make_type_32.loc11 [template = i32]
// CHECK:STDOUT:   %.loc11_13.3: type = converted %int.make_type_32.loc11, %.loc11_13.2 [template = i32]
// CHECK:STDOUT:   %.loc11_13.4: type = converted %.loc11_13.1, constants.%.3 [template = constants.%.3]
// CHECK:STDOUT:   %a.var: ref %.3 = var a
// CHECK:STDOUT:   %a: ref %.3 = bind_name a, %a.var
// CHECK:STDOUT:   %int.make_type_32.loc12: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc12_13.1: %.2 = tuple_literal (%int.make_type_32.loc12)
// CHECK:STDOUT:   %.loc12_13.2: type = value_of_initializer %int.make_type_32.loc12 [template = i32]
// CHECK:STDOUT:   %.loc12_13.3: type = converted %int.make_type_32.loc12, %.loc12_13.2 [template = i32]
// CHECK:STDOUT:   %.loc12_13.4: type = converted %.loc12_13.1, constants.%.3 [template = constants.%.3]
// CHECK:STDOUT:   %b.var: ref %.3 = var b
// CHECK:STDOUT:   %b: ref %.3 = bind_name b, %b.var
// CHECK:STDOUT:   %int.make_type_32.loc17: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc17_8.1: type = value_of_initializer %int.make_type_32.loc17 [template = i32]
// CHECK:STDOUT:   %.loc17_8.2: type = converted %int.make_type_32.loc17, %.loc17_8.1 [template = i32]
// CHECK:STDOUT:   %c.var: ref i32 = var c
// CHECK:STDOUT:   %c: ref i32 = bind_name c, %c.var
// CHECK:STDOUT:   %int.make_type_32.loc21: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc21_8.1: type = value_of_initializer %int.make_type_32.loc21 [template = i32]
// CHECK:STDOUT:   %.loc21_8.2: type = converted %int.make_type_32.loc21, %.loc21_8.1 [template = i32]
// CHECK:STDOUT:   %d.var: ref i32 = var d
// CHECK:STDOUT:   %d: ref i32 = bind_name d, %d.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Int32() -> type = "int.make_type_32";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc11_18: i32 = int_literal 12 [template = constants.%.4]
// CHECK:STDOUT:   %.loc11_21.1: %.3 = tuple_literal (%.loc11_18)
// CHECK:STDOUT:   %.loc11_21.2: init %.3 = tuple_init (%.loc11_18) to file.%a.var [template = constants.%tuple]
// CHECK:STDOUT:   %.loc11_22: init %.3 = converted %.loc11_21.1, %.loc11_21.2 [template = constants.%tuple]
// CHECK:STDOUT:   assign file.%a.var, %.loc11_22
// CHECK:STDOUT:   %a.ref: ref %.3 = name_ref a, file.%a
// CHECK:STDOUT:   %.loc12_17.1: ref i32 = tuple_access %a.ref, element0
// CHECK:STDOUT:   %.loc12_17.2: i32 = bind_value %.loc12_17.1
// CHECK:STDOUT:   %.loc12_17.3: init %.3 = tuple_init (%.loc12_17.2) to file.%b.var
// CHECK:STDOUT:   %.loc12_18: init %.3 = converted %a.ref, %.loc12_17.3
// CHECK:STDOUT:   assign file.%b.var, %.loc12_18
// CHECK:STDOUT:   %b.ref.loc17: ref %.3 = name_ref b, file.%b
// CHECK:STDOUT:   %.loc17_16: i32 = int_literal 1 [template = constants.%.5]
// CHECK:STDOUT:   %.loc17_17: ref <error> = tuple_index %b.ref.loc17, <error> [template = <error>]
// CHECK:STDOUT:   assign file.%c.var, <error>
// CHECK:STDOUT:   %b.ref.loc21: ref %.3 = name_ref b, file.%b
// CHECK:STDOUT:   %.loc21_16: i32 = int_literal 2147483647 [template = constants.%.6]
// CHECK:STDOUT:   %.loc21_27: ref <error> = tuple_index %b.ref.loc21, <error> [template = <error>]
// CHECK:STDOUT:   assign file.%d.var, <error>
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
