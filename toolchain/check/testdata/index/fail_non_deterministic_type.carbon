// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/index/fail_non_deterministic_type.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/index/fail_non_deterministic_type.carbon

var a: (i32, i32) = (2, 3);
var b: i32 = 0;
// CHECK:STDERR: fail_non_deterministic_type.carbon:[[@LINE+3]]:14: ERROR: Tuple index must be a constant.
// CHECK:STDERR: var c: i32 = a[b];
// CHECK:STDERR:              ^~~~
var c: i32 = a[b];

// CHECK:STDOUT: --- fail_non_deterministic_type.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Int32.type: type = fn_type @Int32 [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Int32: %Int32.type = struct_value () [template]
// CHECK:STDOUT:   %.2: type = tuple_type (type, type) [template]
// CHECK:STDOUT:   %.3: type = tuple_type (i32, i32) [template]
// CHECK:STDOUT:   %.4: type = ptr_type %.3 [template]
// CHECK:STDOUT:   %.5: i32 = int_literal 2 [template]
// CHECK:STDOUT:   %.6: i32 = int_literal 3 [template]
// CHECK:STDOUT:   %tuple: %.3 = tuple_value (%.5, %.6) [template]
// CHECK:STDOUT:   %.7: i32 = int_literal 0 [template]
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
// CHECK:STDOUT:   %int.make_type_32.loc11_9: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %int.make_type_32.loc11_14: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc11_17.1: %.2 = tuple_literal (%int.make_type_32.loc11_9, %int.make_type_32.loc11_14)
// CHECK:STDOUT:   %.loc11_17.2: type = value_of_initializer %int.make_type_32.loc11_9 [template = i32]
// CHECK:STDOUT:   %.loc11_17.3: type = converted %int.make_type_32.loc11_9, %.loc11_17.2 [template = i32]
// CHECK:STDOUT:   %.loc11_17.4: type = value_of_initializer %int.make_type_32.loc11_14 [template = i32]
// CHECK:STDOUT:   %.loc11_17.5: type = converted %int.make_type_32.loc11_14, %.loc11_17.4 [template = i32]
// CHECK:STDOUT:   %.loc11_17.6: type = converted %.loc11_17.1, constants.%.3 [template = constants.%.3]
// CHECK:STDOUT:   %a.var: ref %.3 = var a
// CHECK:STDOUT:   %a: ref %.3 = bind_name a, %a.var
// CHECK:STDOUT:   %int.make_type_32.loc12: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc12_8.1: type = value_of_initializer %int.make_type_32.loc12 [template = i32]
// CHECK:STDOUT:   %.loc12_8.2: type = converted %int.make_type_32.loc12, %.loc12_8.1 [template = i32]
// CHECK:STDOUT:   %b.var: ref i32 = var b
// CHECK:STDOUT:   %b: ref i32 = bind_name b, %b.var
// CHECK:STDOUT:   %int.make_type_32.loc16: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc16_8.1: type = value_of_initializer %int.make_type_32.loc16 [template = i32]
// CHECK:STDOUT:   %.loc16_8.2: type = converted %int.make_type_32.loc16, %.loc16_8.1 [template = i32]
// CHECK:STDOUT:   %c.var: ref i32 = var c
// CHECK:STDOUT:   %c: ref i32 = bind_name c, %c.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Int32() -> type = "int.make_type_32";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc11_22: i32 = int_literal 2 [template = constants.%.5]
// CHECK:STDOUT:   %.loc11_25: i32 = int_literal 3 [template = constants.%.6]
// CHECK:STDOUT:   %.loc11_26.1: %.3 = tuple_literal (%.loc11_22, %.loc11_25)
// CHECK:STDOUT:   %.loc11_26.2: ref i32 = tuple_access file.%a.var, element0
// CHECK:STDOUT:   %.loc11_26.3: init i32 = initialize_from %.loc11_22 to %.loc11_26.2 [template = constants.%.5]
// CHECK:STDOUT:   %.loc11_26.4: ref i32 = tuple_access file.%a.var, element1
// CHECK:STDOUT:   %.loc11_26.5: init i32 = initialize_from %.loc11_25 to %.loc11_26.4 [template = constants.%.6]
// CHECK:STDOUT:   %.loc11_26.6: init %.3 = tuple_init (%.loc11_26.3, %.loc11_26.5) to file.%a.var [template = constants.%tuple]
// CHECK:STDOUT:   %.loc11_27: init %.3 = converted %.loc11_26.1, %.loc11_26.6 [template = constants.%tuple]
// CHECK:STDOUT:   assign file.%a.var, %.loc11_27
// CHECK:STDOUT:   %.loc12: i32 = int_literal 0 [template = constants.%.7]
// CHECK:STDOUT:   assign file.%b.var, %.loc12
// CHECK:STDOUT:   %a.ref: ref %.3 = name_ref a, file.%a
// CHECK:STDOUT:   %b.ref: ref i32 = name_ref b, file.%b
// CHECK:STDOUT:   %.loc16_16: i32 = bind_value %b.ref
// CHECK:STDOUT:   %.loc16_17: ref <error> = tuple_index %a.ref, <error> [template = <error>]
// CHECK:STDOUT:   assign file.%c.var, <error>
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
