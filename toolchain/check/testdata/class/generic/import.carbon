// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/class/generic/import.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/class/generic/import.carbon

// --- foo.carbon

library "foo";

class Class(T:! type);

class CompleteClass(T:! type) {
  var n: i32;
  fn F() -> i32 { return 0; }
}

fn F() -> CompleteClass(i32);

// --- foo.impl.carbon

impl library "foo";

class Class(T:! type) {
  var x: T;
}

fn F() -> CompleteClass(i32) {
  return {.n = 1};
}

// --- use_foo.carbon

library "use_foo";
import library "foo";

fn Use() -> i32 {
  var v: CompleteClass(i32) = F();
  return v.F();
}

// --- fail_todo_use_foo.carbon

library "fail_todo_use_foo";
import library "foo";

fn Use() -> i32 {
  var v: CompleteClass(i32) = F();
  // TODO: This should be accepted.
  // CHECK:STDERR: fail_todo_use_foo.carbon:[[@LINE+4]]:10: ERROR: Cannot implicitly convert from `CompleteClass` to `CompleteClass`.
  // CHECK:STDERR:   return v.n;
  // CHECK:STDERR:          ^~~
  // CHECK:STDERR:
  return v.n;
}

// --- fail_generic_arg_mismatch.carbon

library "fail_generic_arg_mismatch";
import library "foo";

fn Use() {
  // TODO: Include the generic arguments in the formatted type name.
  // CHECK:STDERR: fail_generic_arg_mismatch.carbon:[[@LINE+4]]:3: ERROR: Cannot implicitly convert from `CompleteClass` to `CompleteClass`.
  // CHECK:STDERR:   var v: CompleteClass(i32*) = F();
  // CHECK:STDERR:   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // CHECK:STDERR:
  var v: CompleteClass(i32*) = F();
}

// --- fail_bad_foo.impl.carbon

impl library "foo";

// CHECK:STDERR: fail_bad_foo.impl.carbon:[[@LINE+5]]:13: ERROR: Redeclaration differs at parameter 1.
// CHECK:STDERR: class Class(U:! type) {
// CHECK:STDERR:             ^
// CHECK:STDERR: fail_bad_foo.impl.carbon: Previous declaration's corresponding parameter here.
// CHECK:STDERR:
class Class(U:! type) {
  // CHECK:STDERR: fail_bad_foo.impl.carbon:[[@LINE+3]]:10: ERROR: Name `T` not found.
  // CHECK:STDERR:   var x: T;
  // CHECK:STDERR:          ^
  var x: T;
}

// CHECK:STDOUT: --- foo.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %T: type = bind_symbolic_name T 0 [symbolic]
// CHECK:STDOUT:   %Class.type: type = generic_class_type @Class [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Class.1: %Class.type = struct_value () [template]
// CHECK:STDOUT:   %Class.2: type = class_type @Class, @Class(%T) [symbolic]
// CHECK:STDOUT:   %CompleteClass.type: type = generic_class_type @CompleteClass [template]
// CHECK:STDOUT:   %CompleteClass.1: %CompleteClass.type = struct_value () [template]
// CHECK:STDOUT:   %CompleteClass.2: type = class_type @CompleteClass, @CompleteClass(%T) [symbolic]
// CHECK:STDOUT:   %Int32.type: type = fn_type @Int32 [template]
// CHECK:STDOUT:   %Int32: %Int32.type = struct_value () [template]
// CHECK:STDOUT:   %.2: type = unbound_element_type %CompleteClass.2, i32 [symbolic]
// CHECK:STDOUT:   %F.type.1: type = fn_type @F.1 [template]
// CHECK:STDOUT:   %F.1: %F.type.1 = struct_value () [template]
// CHECK:STDOUT:   %.3: type = struct_type {.n: i32} [template]
// CHECK:STDOUT:   %.4: i32 = int_literal 0 [template]
// CHECK:STDOUT:   %CompleteClass.3: type = class_type @CompleteClass, @CompleteClass(i32) [template]
// CHECK:STDOUT:   %F.type.2: type = fn_type @F.2 [template]
// CHECK:STDOUT:   %F.2: %F.type.2 = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT:   %import_ref.2: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT:   %import_ref.3: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .Class = %Class.decl
// CHECK:STDOUT:     .CompleteClass = %CompleteClass.decl
// CHECK:STDOUT:     .F = %F.decl
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
// CHECK:STDOUT:   %Class.decl: %Class.type = class_decl @Class [template = constants.%Class.1] {
// CHECK:STDOUT:     %T.loc4_13.1: type = param T
// CHECK:STDOUT:     %T.loc4_13.2: type = bind_symbolic_name T 0, %T.loc4_13.1 [symbolic = @Class.%T (constants.%T)]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %CompleteClass.decl: %CompleteClass.type = class_decl @CompleteClass [template = constants.%CompleteClass.1] {
// CHECK:STDOUT:     %T.loc6_21.1: type = param T
// CHECK:STDOUT:     %T.loc6_21.2: type = bind_symbolic_name T 0, %T.loc6_21.1 [symbolic = @CompleteClass.%T (constants.%T)]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %F.decl: %F.type.2 = fn_decl @F.2 [template = constants.%F.2] {
// CHECK:STDOUT:     %CompleteClass.ref: %CompleteClass.type = name_ref CompleteClass, %CompleteClass.decl [template = constants.%CompleteClass.1]
// CHECK:STDOUT:     %int.make_type_32: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc11_24.1: type = value_of_initializer %int.make_type_32 [template = i32]
// CHECK:STDOUT:     %.loc11_24.2: type = converted %int.make_type_32, %.loc11_24.1 [template = i32]
// CHECK:STDOUT:     %.loc11_24.3: init type = call %CompleteClass.ref(%.loc11_24.2) [template = constants.%CompleteClass.3]
// CHECK:STDOUT:     %.loc11_28.1: type = value_of_initializer %.loc11_24.3 [template = constants.%CompleteClass.3]
// CHECK:STDOUT:     %.loc11_28.2: type = converted %.loc11_24.3, %.loc11_28.1 [template = constants.%CompleteClass.3]
// CHECK:STDOUT:     @F.2.%return: ref %CompleteClass.3 = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @Class(file.%T.loc4_13.2: type) {
// CHECK:STDOUT:   %T: type = bind_symbolic_name T 0 [symbolic = %T (constants.%T)]
// CHECK:STDOUT:
// CHECK:STDOUT:   class;
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @CompleteClass(file.%T.loc6_21.2: type) {
// CHECK:STDOUT:   %T: type = bind_symbolic_name T 0 [symbolic = %T (constants.%T)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %CompleteClass: type = class_type @CompleteClass, @CompleteClass(%T) [symbolic = %CompleteClass (constants.%CompleteClass.2)]
// CHECK:STDOUT:   %.1: type = unbound_element_type @CompleteClass.%CompleteClass (%CompleteClass.2), i32 [symbolic = %.1 (constants.%.2)]
// CHECK:STDOUT:
// CHECK:STDOUT:   class {
// CHECK:STDOUT:     %int.make_type_32.loc7: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc7_10.1: type = value_of_initializer %int.make_type_32.loc7 [template = i32]
// CHECK:STDOUT:     %.loc7_10.2: type = converted %int.make_type_32.loc7, %.loc7_10.1 [template = i32]
// CHECK:STDOUT:     %.loc7_8: @CompleteClass.%.1 (%.2) = field_decl n, element0 [template]
// CHECK:STDOUT:     %F.decl: %F.type.1 = fn_decl @F.1 [template = constants.%F.1] {
// CHECK:STDOUT:       %int.make_type_32.loc8: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:       %.loc8_13.1: type = value_of_initializer %int.make_type_32.loc8 [template = i32]
// CHECK:STDOUT:       %.loc8_13.2: type = converted %int.make_type_32.loc8, %.loc8_13.1 [template = i32]
// CHECK:STDOUT:       %return.var: ref i32 = var <return slot>
// CHECK:STDOUT:     }
// CHECK:STDOUT:
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = constants.%CompleteClass.2
// CHECK:STDOUT:     .n = %.loc7_8
// CHECK:STDOUT:     .F = %F.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Int32() -> type = "int.make_type_32";
// CHECK:STDOUT:
// CHECK:STDOUT: generic fn @F.1(file.%T.loc6_21.2: type) {
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   fn() -> i32 {
// CHECK:STDOUT:   !entry:
// CHECK:STDOUT:     %.loc8: i32 = int_literal 0 [template = constants.%.4]
// CHECK:STDOUT:     return %.loc8
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F.2() -> %CompleteClass.3;
// CHECK:STDOUT:
// CHECK:STDOUT: specific @Class(constants.%T) {
// CHECK:STDOUT:   %T => constants.%T
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @CompleteClass(constants.%T) {
// CHECK:STDOUT:   %T => constants.%T
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @F.1(constants.%T) {}
// CHECK:STDOUT:
// CHECK:STDOUT: specific @CompleteClass(@CompleteClass.%T) {
// CHECK:STDOUT:   %T => constants.%T
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @CompleteClass(i32) {
// CHECK:STDOUT:   %T => i32
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- foo.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %T: type = bind_symbolic_name T 0, <unexpected>.inst+31 [symbolic]
// CHECK:STDOUT:   %Class.type: type = generic_class_type @Class [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Class.1: %Class.type = struct_value () [template]
// CHECK:STDOUT:   %Class.2: type = class_type @Class, invalid(%T) [symbolic]
// CHECK:STDOUT:   %.2: type = unbound_element_type %Class.2, %T [symbolic]
// CHECK:STDOUT:   %.3: type = struct_type {.x: %T} [symbolic]
// CHECK:STDOUT:   %CompleteClass.type: type = generic_class_type @CompleteClass [template]
// CHECK:STDOUT:   %CompleteClass.1: %CompleteClass.type = struct_value () [template]
// CHECK:STDOUT:   %.4: type = struct_type {.n: i32} [template]
// CHECK:STDOUT:   %CompleteClass.2: type = class_type @CompleteClass, invalid(%T) [symbolic]
// CHECK:STDOUT:   %Int32.type: type = fn_type @Int32 [template]
// CHECK:STDOUT:   %Int32: %Int32.type = struct_value () [template]
// CHECK:STDOUT:   %CompleteClass.3: type = class_type @CompleteClass, invalid(i32) [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT:   %.5: type = ptr_type %.4 [template]
// CHECK:STDOUT:   %.6: i32 = int_literal 1 [template]
// CHECK:STDOUT:   %struct: %CompleteClass.3 = struct_value (%.6) [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: %Class.type = import_ref Main//foo, inst+6, loaded [template = constants.%Class.1]
// CHECK:STDOUT:   %import_ref.2: %CompleteClass.type = import_ref Main//foo, inst+14, loaded [template = constants.%CompleteClass.1]
// CHECK:STDOUT:   %import_ref.3: %F.type = import_ref Main//foo, inst+55, loaded [template = constants.%F]
// CHECK:STDOUT:   %import_ref.4 = import_ref Main//foo, inst+18, unloaded
// CHECK:STDOUT:   %import_ref.5 = import_ref Main//foo, inst+28, unloaded
// CHECK:STDOUT:   %import_ref.6 = import_ref Main//foo, inst+36, unloaded
// CHECK:STDOUT:   %import_ref.7: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Class = %Class.decl
// CHECK:STDOUT:     .CompleteClass = imports.%import_ref.2
// CHECK:STDOUT:     .F = %F.decl
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import.loc2_6.1 = import <invalid>
// CHECK:STDOUT:   %default.import.loc2_6.2 = import <invalid>
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
// CHECK:STDOUT:   %Class.decl: %Class.type = class_decl @Class [template = constants.%Class.1] {
// CHECK:STDOUT:     %T.loc4_13.1: type = param T
// CHECK:STDOUT:     %T.loc4_13.2: type = bind_symbolic_name T 0, %T.loc4_13.1 [symbolic = constants.%T]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %F.decl: %F.type = fn_decl @F [template = constants.%F] {
// CHECK:STDOUT:     %CompleteClass.ref: %CompleteClass.type = name_ref CompleteClass, imports.%import_ref.2 [template = constants.%CompleteClass.1]
// CHECK:STDOUT:     %int.make_type_32: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc8_24.1: type = value_of_initializer %int.make_type_32 [template = i32]
// CHECK:STDOUT:     %.loc8_24.2: type = converted %int.make_type_32, %.loc8_24.1 [template = i32]
// CHECK:STDOUT:     %.loc8_24.3: init type = call %CompleteClass.ref(%.loc8_24.2) [template = constants.%CompleteClass.3]
// CHECK:STDOUT:     %.loc8_28.1: type = value_of_initializer %.loc8_24.3 [template = constants.%CompleteClass.3]
// CHECK:STDOUT:     %.loc8_28.2: type = converted %.loc8_24.3, %.loc8_28.1 [template = constants.%CompleteClass.3]
// CHECK:STDOUT:     @F.%return: ref %CompleteClass.3 = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @Class {
// CHECK:STDOUT:   %T.ref: type = name_ref T, file.%T.loc4_13.2 [symbolic = constants.%T]
// CHECK:STDOUT:   %.loc5: %.2 = field_decl x, element0 [template]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%Class.2
// CHECK:STDOUT:   .x = %.loc5
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @CompleteClass {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.4
// CHECK:STDOUT:   .n = imports.%import_ref.5
// CHECK:STDOUT:   .F = imports.%import_ref.6
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Int32() -> type = "int.make_type_32";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F() -> %return: %CompleteClass.3 {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc9_16: i32 = int_literal 1 [template = constants.%.6]
// CHECK:STDOUT:   %.loc9_17.1: %.4 = struct_literal (%.loc9_16)
// CHECK:STDOUT:   %.loc9_17.2: ref i32 = class_element_access %return, element0
// CHECK:STDOUT:   %.loc9_17.3: init i32 = initialize_from %.loc9_16 to %.loc9_17.2 [template = constants.%.6]
// CHECK:STDOUT:   %.loc9_17.4: init %CompleteClass.3 = class_init (%.loc9_17.3), %return [template = constants.%struct]
// CHECK:STDOUT:   %.loc9_18: init %CompleteClass.3 = converted %.loc9_17.1, %.loc9_17.4 [template = constants.%struct]
// CHECK:STDOUT:   return %.loc9_18 to %return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific invalid(constants.%T);
// CHECK:STDOUT:
// CHECK:STDOUT: specific invalid(i32);
// CHECK:STDOUT:
// CHECK:STDOUT: --- use_foo.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Int32.type: type = fn_type @Int32 [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Int32: %Int32.type = struct_value () [template]
// CHECK:STDOUT:   %Use.type: type = fn_type @Use [template]
// CHECK:STDOUT:   %Use: %Use.type = struct_value () [template]
// CHECK:STDOUT:   %CompleteClass.type: type = generic_class_type @CompleteClass [template]
// CHECK:STDOUT:   %CompleteClass.1: %CompleteClass.type = struct_value () [template]
// CHECK:STDOUT:   %.2: type = struct_type {.n: i32} [template]
// CHECK:STDOUT:   %T: type = bind_symbolic_name T 0, <unexpected>.inst+28 [symbolic]
// CHECK:STDOUT:   %CompleteClass.2: type = class_type @CompleteClass, invalid(%T) [symbolic]
// CHECK:STDOUT:   %CompleteClass.3: type = class_type @CompleteClass, invalid(i32) [template]
// CHECK:STDOUT:   %.3: type = ptr_type %.2 [template]
// CHECK:STDOUT:   %F.type.1: type = fn_type @F.1 [template]
// CHECK:STDOUT:   %F.1: %F.type.1 = struct_value () [template]
// CHECK:STDOUT:   %F.type.2: type = fn_type @F.2 [template]
// CHECK:STDOUT:   %F.2: %F.type.2 = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1 = import_ref Main//foo, inst+6, unloaded
// CHECK:STDOUT:   %import_ref.2: %CompleteClass.type = import_ref Main//foo, inst+14, loaded [template = constants.%CompleteClass.1]
// CHECK:STDOUT:   %import_ref.3: %F.type.1 = import_ref Main//foo, inst+55, loaded [template = constants.%F.1]
// CHECK:STDOUT:   %import_ref.4: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT:   %import_ref.5 = import_ref Main//foo, inst+18, unloaded
// CHECK:STDOUT:   %import_ref.6 = import_ref Main//foo, inst+28, unloaded
// CHECK:STDOUT:   %import_ref.7: %F.type.2 = import_ref Main//foo, inst+36, loaded [template = constants.%F.2]
// CHECK:STDOUT:   %import_ref.8: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Class = imports.%import_ref.1
// CHECK:STDOUT:     .CompleteClass = imports.%import_ref.2
// CHECK:STDOUT:     .F = imports.%import_ref.3
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .Use = %Use.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %Core: <namespace> = namespace %Core.import, [template] {
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/operators
// CHECK:STDOUT:     import Core//prelude/types
// CHECK:STDOUT:     import Core//prelude/operators/arithmetic
// CHECK:STDOUT:     import Core//prelude/operators/bitwise
// CHECK:STDOUT:     import Core//prelude/operators/comparison
// CHECK:STDOUT:     import Core//prelude/types/bool
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Use.decl: %Use.type = fn_decl @Use [template = constants.%Use] {
// CHECK:STDOUT:     %int.make_type_32: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc5_13.1: type = value_of_initializer %int.make_type_32 [template = i32]
// CHECK:STDOUT:     %.loc5_13.2: type = converted %int.make_type_32, %.loc5_13.1 [template = i32]
// CHECK:STDOUT:     @Use.%return: ref i32 = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @CompleteClass {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.5
// CHECK:STDOUT:   .n = imports.%import_ref.6
// CHECK:STDOUT:   .F = imports.%import_ref.7
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Int32() -> type = "int.make_type_32";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Use() -> i32 {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %CompleteClass.ref: %CompleteClass.type = name_ref CompleteClass, imports.%import_ref.2 [template = constants.%CompleteClass.1]
// CHECK:STDOUT:   %int.make_type_32: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc6_23.1: type = value_of_initializer %int.make_type_32 [template = i32]
// CHECK:STDOUT:   %.loc6_23.2: type = converted %int.make_type_32, %.loc6_23.1 [template = i32]
// CHECK:STDOUT:   %.loc6_23.3: init type = call %CompleteClass.ref(%.loc6_23.2) [template = constants.%CompleteClass.3]
// CHECK:STDOUT:   %.loc6_27.1: type = value_of_initializer %.loc6_23.3 [template = constants.%CompleteClass.3]
// CHECK:STDOUT:   %.loc6_27.2: type = converted %.loc6_23.3, %.loc6_27.1 [template = constants.%CompleteClass.3]
// CHECK:STDOUT:   %v.var: ref %CompleteClass.3 = var v
// CHECK:STDOUT:   %v: ref %CompleteClass.3 = bind_name v, %v.var
// CHECK:STDOUT:   %F.ref.loc6: %F.type.1 = name_ref F, imports.%import_ref.3 [template = constants.%F.1]
// CHECK:STDOUT:   %.loc6_7: ref %CompleteClass.3 = splice_block %v.var {}
// CHECK:STDOUT:   %F.call.loc6: init %CompleteClass.3 = call %F.ref.loc6() to %.loc6_7
// CHECK:STDOUT:   assign %v.var, %F.call.loc6
// CHECK:STDOUT:   %v.ref: ref %CompleteClass.3 = name_ref v, %v
// CHECK:STDOUT:   %F.ref.loc7: %F.type.2 = name_ref F, imports.%import_ref.7 [template = constants.%F.2]
// CHECK:STDOUT:   %F.call.loc7: init i32 = call %F.ref.loc7()
// CHECK:STDOUT:   %.loc7_15.1: i32 = value_of_initializer %F.call.loc7
// CHECK:STDOUT:   %.loc7_15.2: i32 = converted %F.call.loc7, %.loc7_15.1
// CHECK:STDOUT:   return %.loc7_15.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F.1() -> %CompleteClass.3;
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F.2() -> i32;
// CHECK:STDOUT:
// CHECK:STDOUT: specific invalid(constants.%T);
// CHECK:STDOUT:
// CHECK:STDOUT: specific invalid(i32);
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_todo_use_foo.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Int32.type: type = fn_type @Int32 [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Int32: %Int32.type = struct_value () [template]
// CHECK:STDOUT:   %Use.type: type = fn_type @Use [template]
// CHECK:STDOUT:   %Use: %Use.type = struct_value () [template]
// CHECK:STDOUT:   %CompleteClass.type: type = generic_class_type @CompleteClass [template]
// CHECK:STDOUT:   %CompleteClass.1: %CompleteClass.type = struct_value () [template]
// CHECK:STDOUT:   %.2: type = struct_type {.n: i32} [template]
// CHECK:STDOUT:   %T: type = bind_symbolic_name T 0, <unexpected>.inst+28 [symbolic]
// CHECK:STDOUT:   %CompleteClass.2: type = class_type @CompleteClass, invalid(%T) [symbolic]
// CHECK:STDOUT:   %CompleteClass.3: type = class_type @CompleteClass, invalid(i32) [template]
// CHECK:STDOUT:   %.3: type = ptr_type %.2 [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT:   %.4: type = unbound_element_type %CompleteClass.2, i32 [symbolic]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1 = import_ref Main//foo, inst+6, unloaded
// CHECK:STDOUT:   %import_ref.2: %CompleteClass.type = import_ref Main//foo, inst+14, loaded [template = constants.%CompleteClass.1]
// CHECK:STDOUT:   %import_ref.3: %F.type = import_ref Main//foo, inst+55, loaded [template = constants.%F]
// CHECK:STDOUT:   %import_ref.4: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT:   %import_ref.5 = import_ref Main//foo, inst+18, unloaded
// CHECK:STDOUT:   %import_ref.6: %.4 = import_ref Main//foo, inst+28, loaded [template = %.1]
// CHECK:STDOUT:   %import_ref.7 = import_ref Main//foo, inst+36, unloaded
// CHECK:STDOUT:   %import_ref.8: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Class = imports.%import_ref.1
// CHECK:STDOUT:     .CompleteClass = imports.%import_ref.2
// CHECK:STDOUT:     .F = imports.%import_ref.3
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .Use = %Use.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %Core: <namespace> = namespace %Core.import, [template] {
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/operators
// CHECK:STDOUT:     import Core//prelude/types
// CHECK:STDOUT:     import Core//prelude/operators/arithmetic
// CHECK:STDOUT:     import Core//prelude/operators/bitwise
// CHECK:STDOUT:     import Core//prelude/operators/comparison
// CHECK:STDOUT:     import Core//prelude/types/bool
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Use.decl: %Use.type = fn_decl @Use [template = constants.%Use] {
// CHECK:STDOUT:     %int.make_type_32: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc5_13.1: type = value_of_initializer %int.make_type_32 [template = i32]
// CHECK:STDOUT:     %.loc5_13.2: type = converted %int.make_type_32, %.loc5_13.1 [template = i32]
// CHECK:STDOUT:     @Use.%return: ref i32 = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @CompleteClass {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.5
// CHECK:STDOUT:   .n = imports.%import_ref.6
// CHECK:STDOUT:   .F = imports.%import_ref.7
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Int32() -> type = "int.make_type_32";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Use() -> i32 {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %CompleteClass.ref: %CompleteClass.type = name_ref CompleteClass, imports.%import_ref.2 [template = constants.%CompleteClass.1]
// CHECK:STDOUT:   %int.make_type_32: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc6_23.1: type = value_of_initializer %int.make_type_32 [template = i32]
// CHECK:STDOUT:   %.loc6_23.2: type = converted %int.make_type_32, %.loc6_23.1 [template = i32]
// CHECK:STDOUT:   %.loc6_23.3: init type = call %CompleteClass.ref(%.loc6_23.2) [template = constants.%CompleteClass.3]
// CHECK:STDOUT:   %.loc6_27.1: type = value_of_initializer %.loc6_23.3 [template = constants.%CompleteClass.3]
// CHECK:STDOUT:   %.loc6_27.2: type = converted %.loc6_23.3, %.loc6_27.1 [template = constants.%CompleteClass.3]
// CHECK:STDOUT:   %v.var: ref %CompleteClass.3 = var v
// CHECK:STDOUT:   %v: ref %CompleteClass.3 = bind_name v, %v.var
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, imports.%import_ref.3 [template = constants.%F]
// CHECK:STDOUT:   %.loc6_7: ref %CompleteClass.3 = splice_block %v.var {}
// CHECK:STDOUT:   %F.call: init %CompleteClass.3 = call %F.ref() to %.loc6_7
// CHECK:STDOUT:   assign %v.var, %F.call
// CHECK:STDOUT:   %v.ref: ref %CompleteClass.3 = name_ref v, %v
// CHECK:STDOUT:   %n.ref: %.4 = name_ref n, imports.%import_ref.6 [template = imports.%.1]
// CHECK:STDOUT:   %.loc12: i32 = class_element_access <error>, element0 [template = <error>]
// CHECK:STDOUT:   return <error>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F() -> %CompleteClass.3;
// CHECK:STDOUT:
// CHECK:STDOUT: specific invalid(constants.%T);
// CHECK:STDOUT:
// CHECK:STDOUT: specific invalid(i32);
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_generic_arg_mismatch.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Use.type: type = fn_type @Use [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Use: %Use.type = struct_value () [template]
// CHECK:STDOUT:   %CompleteClass.type: type = generic_class_type @CompleteClass [template]
// CHECK:STDOUT:   %CompleteClass.1: %CompleteClass.type = struct_value () [template]
// CHECK:STDOUT:   %.2: type = struct_type {.n: i32} [template]
// CHECK:STDOUT:   %T: type = bind_symbolic_name T 0, <unexpected>.inst+19 [symbolic]
// CHECK:STDOUT:   %CompleteClass.2: type = class_type @CompleteClass, invalid(%T) [symbolic]
// CHECK:STDOUT:   %Int32.type: type = fn_type @Int32 [template]
// CHECK:STDOUT:   %Int32: %Int32.type = struct_value () [template]
// CHECK:STDOUT:   %.3: type = ptr_type i32 [template]
// CHECK:STDOUT:   %CompleteClass.3: type = class_type @CompleteClass, invalid(%.3) [template]
// CHECK:STDOUT:   %.4: type = ptr_type %.2 [template]
// CHECK:STDOUT:   %CompleteClass.4: type = class_type @CompleteClass, invalid(i32) [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1 = import_ref Main//foo, inst+6, unloaded
// CHECK:STDOUT:   %import_ref.2: %CompleteClass.type = import_ref Main//foo, inst+14, loaded [template = constants.%CompleteClass.1]
// CHECK:STDOUT:   %import_ref.3: %F.type = import_ref Main//foo, inst+55, loaded [template = constants.%F]
// CHECK:STDOUT:   %import_ref.4 = import_ref Main//foo, inst+18, unloaded
// CHECK:STDOUT:   %import_ref.5 = import_ref Main//foo, inst+28, unloaded
// CHECK:STDOUT:   %import_ref.6 = import_ref Main//foo, inst+36, unloaded
// CHECK:STDOUT:   %import_ref.7: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Class = imports.%import_ref.1
// CHECK:STDOUT:     .CompleteClass = imports.%import_ref.2
// CHECK:STDOUT:     .F = imports.%import_ref.3
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .Use = %Use.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %Core: <namespace> = namespace %Core.import, [template] {
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/operators
// CHECK:STDOUT:     import Core//prelude/types
// CHECK:STDOUT:     import Core//prelude/operators/arithmetic
// CHECK:STDOUT:     import Core//prelude/operators/bitwise
// CHECK:STDOUT:     import Core//prelude/operators/comparison
// CHECK:STDOUT:     import Core//prelude/types/bool
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Use.decl: %Use.type = fn_decl @Use [template = constants.%Use] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @CompleteClass {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.4
// CHECK:STDOUT:   .n = imports.%import_ref.5
// CHECK:STDOUT:   .F = imports.%import_ref.6
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Use() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %CompleteClass.ref: %CompleteClass.type = name_ref CompleteClass, imports.%import_ref.2 [template = constants.%CompleteClass.1]
// CHECK:STDOUT:   %int.make_type_32: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc11_27.1: type = value_of_initializer %int.make_type_32 [template = i32]
// CHECK:STDOUT:   %.loc11_27.2: type = converted %int.make_type_32, %.loc11_27.1 [template = i32]
// CHECK:STDOUT:   %.loc11_27.3: type = ptr_type i32 [template = constants.%.3]
// CHECK:STDOUT:   %.loc11_23: init type = call %CompleteClass.ref(%.loc11_27.3) [template = constants.%CompleteClass.3]
// CHECK:STDOUT:   %.loc11_28.1: type = value_of_initializer %.loc11_23 [template = constants.%CompleteClass.3]
// CHECK:STDOUT:   %.loc11_28.2: type = converted %.loc11_23, %.loc11_28.1 [template = constants.%CompleteClass.3]
// CHECK:STDOUT:   %v.var: ref %CompleteClass.3 = var v
// CHECK:STDOUT:   %v: ref %CompleteClass.3 = bind_name v, %v.var
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, imports.%import_ref.3 [template = constants.%F]
// CHECK:STDOUT:   %.loc11_33: ref %CompleteClass.4 = temporary_storage
// CHECK:STDOUT:   %F.call: init %CompleteClass.4 = call %F.ref() to %.loc11_33
// CHECK:STDOUT:   assign %v.var, <error>
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Int32() -> type = "int.make_type_32";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F() -> %CompleteClass.4;
// CHECK:STDOUT:
// CHECK:STDOUT: specific invalid(constants.%T);
// CHECK:STDOUT:
// CHECK:STDOUT: specific invalid(constants.%.3);
// CHECK:STDOUT:
// CHECK:STDOUT: specific invalid(i32);
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_bad_foo.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %U: type = bind_symbolic_name U 0 [symbolic]
// CHECK:STDOUT:   %Class.type: type = generic_class_type @Class [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Class.1: %Class.type = struct_value () [template]
// CHECK:STDOUT:   %T: type = bind_symbolic_name T 0, <unexpected>.inst+17 [symbolic]
// CHECK:STDOUT:   %Class.2: type = class_type @Class, invalid(%T) [symbolic]
// CHECK:STDOUT:   %.type: type = generic_class_type @.1 [template]
// CHECK:STDOUT:   %.2: %.type = struct_value () [template]
// CHECK:STDOUT:   %.3: type = class_type @.1, @.1(%U) [symbolic]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: %Class.type = import_ref Main//foo, inst+6, loaded [template = constants.%Class.1]
// CHECK:STDOUT:   %import_ref.2 = import_ref Main//foo, inst+14, unloaded
// CHECK:STDOUT:   %import_ref.3 = import_ref Main//foo, inst+55, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Class = imports.%import_ref.1
// CHECK:STDOUT:     .CompleteClass = imports.%import_ref.2
// CHECK:STDOUT:     .F = imports.%import_ref.3
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import.loc2_6.1 = import <invalid>
// CHECK:STDOUT:   %default.import.loc2_6.2 = import <invalid>
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
// CHECK:STDOUT:   %.decl: %.type = class_decl @.1 [template = constants.%.2] {
// CHECK:STDOUT:     %U.loc9_13.1: type = param U
// CHECK:STDOUT:     %U.loc9_13.2: type = bind_symbolic_name U 0, %U.loc9_13.1 [symbolic = @.1.%U (constants.%U)]
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @Class;
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @.1(file.%U.loc9_13.2: type) {
// CHECK:STDOUT:   %U: type = bind_symbolic_name U 0 [symbolic = %U (constants.%U)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   class {
// CHECK:STDOUT:     %T.ref: <error> = name_ref T, <error> [template = <error>]
// CHECK:STDOUT:     %.loc13: <error> = field_decl x, element0 [template]
// CHECK:STDOUT:
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = constants.%.3
// CHECK:STDOUT:     .x = %.loc13
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific invalid(constants.%T);
// CHECK:STDOUT:
// CHECK:STDOUT: specific @.1(constants.%U) {
// CHECK:STDOUT:   %U => constants.%U
// CHECK:STDOUT: }
// CHECK:STDOUT:
