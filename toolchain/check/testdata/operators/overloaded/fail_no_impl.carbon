// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/operators/overloaded/fail_no_impl.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/operators/overloaded/fail_no_impl.carbon

package User;

class C {};

fn TestUnary(a: C) -> C {
  // CHECK:STDERR: fail_no_impl.carbon:[[@LINE+4]]:10: ERROR: Cannot access member of interface Negate in type C that does not implement that interface.
  // CHECK:STDERR:   return -a;
  // CHECK:STDERR:          ^~
  // CHECK:STDERR:
  return -a;
}

fn TestBinary(a: C, b: C) -> C {
  // CHECK:STDERR: fail_no_impl.carbon:[[@LINE+4]]:10: ERROR: Cannot access member of interface Add in type C that does not implement that interface.
  // CHECK:STDERR:   return a + b;
  // CHECK:STDERR:          ^~~~~
  // CHECK:STDERR:
  return a + b;
}

fn TestRef(b: C) {
  var a: C = {};
  // CHECK:STDERR: fail_no_impl.carbon:[[@LINE+4]]:3: ERROR: Cannot access member of interface AddAssign in type C that does not implement that interface.
  // CHECK:STDERR:   a += b;
  // CHECK:STDERR:   ^~~~~~
  // CHECK:STDERR:
  a += b;
  // CHECK:STDERR: fail_no_impl.carbon:[[@LINE+3]]:3: ERROR: Cannot access member of interface Inc in type C that does not implement that interface.
  // CHECK:STDERR:   ++a;
  // CHECK:STDERR:   ^~~
  ++a;
}

// CHECK:STDOUT: --- fail_no_impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %.1: type = struct_type {} [template]
// CHECK:STDOUT:   %TestUnary.type: type = fn_type @TestUnary [template]
// CHECK:STDOUT:   %.2: type = tuple_type () [template]
// CHECK:STDOUT:   %TestUnary: %TestUnary.type = struct_value () [template]
// CHECK:STDOUT:   %.3: type = ptr_type %.1 [template]
// CHECK:STDOUT:   %.4: type = interface_type @Negate [template]
// CHECK:STDOUT:   %Self.1: %.4 = bind_symbolic_name Self 0 [symbolic]
// CHECK:STDOUT:   %Op.type.1: type = fn_type @Op.1 [template]
// CHECK:STDOUT:   %Op.1: %Op.type.1 = struct_value () [template]
// CHECK:STDOUT:   %.5: type = assoc_entity_type @Negate, %Op.type.1 [template]
// CHECK:STDOUT:   %.6: %.5 = assoc_entity element0, imports.%import_ref.5 [template]
// CHECK:STDOUT:   %TestBinary.type: type = fn_type @TestBinary [template]
// CHECK:STDOUT:   %TestBinary: %TestBinary.type = struct_value () [template]
// CHECK:STDOUT:   %.7: type = interface_type @Add [template]
// CHECK:STDOUT:   %Self.2: %.7 = bind_symbolic_name Self 0 [symbolic]
// CHECK:STDOUT:   %Op.type.2: type = fn_type @Op.2 [template]
// CHECK:STDOUT:   %Op.2: %Op.type.2 = struct_value () [template]
// CHECK:STDOUT:   %.8: type = assoc_entity_type @Add, %Op.type.2 [template]
// CHECK:STDOUT:   %.9: %.8 = assoc_entity element0, imports.%import_ref.10 [template]
// CHECK:STDOUT:   %TestRef.type: type = fn_type @TestRef [template]
// CHECK:STDOUT:   %TestRef: %TestRef.type = struct_value () [template]
// CHECK:STDOUT:   %struct: %C = struct_value () [template]
// CHECK:STDOUT:   %.10: type = interface_type @AddAssign [template]
// CHECK:STDOUT:   %Self.3: %.10 = bind_symbolic_name Self 0 [symbolic]
// CHECK:STDOUT:   %.11: type = ptr_type %Self.3 [symbolic]
// CHECK:STDOUT:   %Op.type.3: type = fn_type @Op.3 [template]
// CHECK:STDOUT:   %Op.3: %Op.type.3 = struct_value () [template]
// CHECK:STDOUT:   %.12: type = assoc_entity_type @AddAssign, %Op.type.3 [template]
// CHECK:STDOUT:   %.13: %.12 = assoc_entity element0, imports.%import_ref.15 [template]
// CHECK:STDOUT:   %.14: type = interface_type @Inc [template]
// CHECK:STDOUT:   %Self.4: %.14 = bind_symbolic_name Self 0 [symbolic]
// CHECK:STDOUT:   %.15: type = ptr_type %Self.4 [symbolic]
// CHECK:STDOUT:   %Op.type.4: type = fn_type @Op.4 [template]
// CHECK:STDOUT:   %Op.4: %Op.type.4 = struct_value () [template]
// CHECK:STDOUT:   %.16: type = assoc_entity_type @Inc, %Op.type.4 [template]
// CHECK:STDOUT:   %.17: %.16 = assoc_entity element0, imports.%import_ref.20 [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: type = import_ref Core//prelude/operators/arithmetic, inst+72, loaded [template = constants.%.4]
// CHECK:STDOUT:   %import_ref.2 = import_ref Core//prelude/operators/arithmetic, inst+74, unloaded
// CHECK:STDOUT:   %import_ref.3: %.5 = import_ref Core//prelude/operators/arithmetic, inst+90, loaded [template = constants.%.6]
// CHECK:STDOUT:   %import_ref.4 = import_ref Core//prelude/operators/arithmetic, inst+85, unloaded
// CHECK:STDOUT:   %import_ref.5 = import_ref Core//prelude/operators/arithmetic, inst+85, unloaded
// CHECK:STDOUT:   %import_ref.6: type = import_ref Core//prelude/operators/arithmetic, inst+1, loaded [template = constants.%.7]
// CHECK:STDOUT:   %import_ref.7 = import_ref Core//prelude/operators/arithmetic, inst+3, unloaded
// CHECK:STDOUT:   %import_ref.8: %.8 = import_ref Core//prelude/operators/arithmetic, inst+25, loaded [template = constants.%.9]
// CHECK:STDOUT:   %import_ref.9 = import_ref Core//prelude/operators/arithmetic, inst+19, unloaded
// CHECK:STDOUT:   %import_ref.10 = import_ref Core//prelude/operators/arithmetic, inst+19, unloaded
// CHECK:STDOUT:   %import_ref.11: type = import_ref Core//prelude/operators/arithmetic, inst+27, loaded [template = constants.%.10]
// CHECK:STDOUT:   %import_ref.12 = import_ref Core//prelude/operators/arithmetic, inst+29, unloaded
// CHECK:STDOUT:   %import_ref.13: %.12 = import_ref Core//prelude/operators/arithmetic, inst+50, loaded [template = constants.%.13]
// CHECK:STDOUT:   %import_ref.14 = import_ref Core//prelude/operators/arithmetic, inst+44, unloaded
// CHECK:STDOUT:   %import_ref.15 = import_ref Core//prelude/operators/arithmetic, inst+44, unloaded
// CHECK:STDOUT:   %import_ref.16: type = import_ref Core//prelude/operators/arithmetic, inst+52, loaded [template = constants.%.14]
// CHECK:STDOUT:   %import_ref.17 = import_ref Core//prelude/operators/arithmetic, inst+54, unloaded
// CHECK:STDOUT:   %import_ref.18: %.16 = import_ref Core//prelude/operators/arithmetic, inst+70, loaded [template = constants.%.17]
// CHECK:STDOUT:   %import_ref.19 = import_ref Core//prelude/operators/arithmetic, inst+64, unloaded
// CHECK:STDOUT:   %import_ref.20 = import_ref Core//prelude/operators/arithmetic, inst+64, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .C = %C.decl
// CHECK:STDOUT:     .TestUnary = %TestUnary.decl
// CHECK:STDOUT:     .TestBinary = %TestBinary.decl
// CHECK:STDOUT:     .TestRef = %TestRef.decl
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
// CHECK:STDOUT:   %C.decl: type = class_decl @C [template = constants.%C] {}
// CHECK:STDOUT:   %TestUnary.decl: %TestUnary.type = fn_decl @TestUnary [template = constants.%TestUnary] {
// CHECK:STDOUT:     %C.ref.loc15_17: type = name_ref C, %C.decl [template = constants.%C]
// CHECK:STDOUT:     %a.loc15_14.1: %C = param a
// CHECK:STDOUT:     @TestUnary.%a: %C = bind_name a, %a.loc15_14.1
// CHECK:STDOUT:     %C.ref.loc15_23: type = name_ref C, %C.decl [template = constants.%C]
// CHECK:STDOUT:     @TestUnary.%return: ref %C = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %TestBinary.decl: %TestBinary.type = fn_decl @TestBinary [template = constants.%TestBinary] {
// CHECK:STDOUT:     %C.ref.loc23_18: type = name_ref C, %C.decl [template = constants.%C]
// CHECK:STDOUT:     %a.loc23_15.1: %C = param a
// CHECK:STDOUT:     @TestBinary.%a: %C = bind_name a, %a.loc23_15.1
// CHECK:STDOUT:     %C.ref.loc23_24: type = name_ref C, %C.decl [template = constants.%C]
// CHECK:STDOUT:     %b.loc23_21.1: %C = param b
// CHECK:STDOUT:     @TestBinary.%b: %C = bind_name b, %b.loc23_21.1
// CHECK:STDOUT:     %C.ref.loc23_30: type = name_ref C, %C.decl [template = constants.%C]
// CHECK:STDOUT:     @TestBinary.%return: ref %C = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %TestRef.decl: %TestRef.type = fn_decl @TestRef [template = constants.%TestRef] {
// CHECK:STDOUT:     %C.ref.loc31: type = name_ref C, %C.decl [template = constants.%C]
// CHECK:STDOUT:     %b.loc31_12.1: %C = param b
// CHECK:STDOUT:     @TestRef.%b: %C = bind_name b, %b.loc31_12.1
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @Negate {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.2
// CHECK:STDOUT:   .Op = imports.%import_ref.3
// CHECK:STDOUT:   witness = (imports.%import_ref.4)
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @Add {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.7
// CHECK:STDOUT:   .Op = imports.%import_ref.8
// CHECK:STDOUT:   witness = (imports.%import_ref.9)
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @AddAssign {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.12
// CHECK:STDOUT:   .Op = imports.%import_ref.13
// CHECK:STDOUT:   witness = (imports.%import_ref.14)
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @Inc {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.17
// CHECK:STDOUT:   .Op = imports.%import_ref.18
// CHECK:STDOUT:   witness = (imports.%import_ref.19)
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%C
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @TestUnary(%a: %C) -> %return: %C {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %a.ref: %C = name_ref a, %a
// CHECK:STDOUT:   return <error> to %return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Op.1[%self: %Self.1]() -> %Self.1;
// CHECK:STDOUT:
// CHECK:STDOUT: fn @TestBinary(%a: %C, %b: %C) -> %return: %C {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %a.ref: %C = name_ref a, %a
// CHECK:STDOUT:   %b.ref: %C = name_ref b, %b
// CHECK:STDOUT:   return <error> to %return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Op.2[%self: %Self.2](%other: %Self.2) -> %Self.2;
// CHECK:STDOUT:
// CHECK:STDOUT: fn @TestRef(%b: %C) {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %C.ref: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:   %a.var: ref %C = var a
// CHECK:STDOUT:   %a: ref %C = bind_name a, %a.var
// CHECK:STDOUT:   %.loc32_15.1: %.1 = struct_literal ()
// CHECK:STDOUT:   %.loc32_15.2: init %C = class_init (), %a.var [template = constants.%struct]
// CHECK:STDOUT:   %.loc32_16: init %C = converted %.loc32_15.1, %.loc32_15.2 [template = constants.%struct]
// CHECK:STDOUT:   assign %a.var, %.loc32_16
// CHECK:STDOUT:   %a.ref.loc37: ref %C = name_ref a, %a
// CHECK:STDOUT:   %b.ref: %C = name_ref b, %b
// CHECK:STDOUT:   %a.ref.loc41: ref %C = name_ref a, %a
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Op.3[addr %self: %.11](%other: %Self.3);
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Op.4[addr %self: %.15]();
// CHECK:STDOUT:
