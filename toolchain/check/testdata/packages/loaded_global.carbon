// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/packages/loaded_global.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/packages/loaded_global.carbon

// --- implicit.carbon

package Implicit;

fn A();

// --- implicit.impl.carbon

impl package Implicit;

var a: () = A();

var package_a: () = package.A();

// --- same_package.carbon

package SamePackage;

fn B();

// --- same_package_importer.carbon

package SamePackage library "importer";

import library default;

var b: () = B();

var package_b: () = package.B();

// CHECK:STDOUT: --- implicit.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %A.type: type = fn_type @A [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %A: %A.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .A = %A.decl
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
// CHECK:STDOUT:   %A.decl: %A.type = fn_decl @A [template = constants.%A] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @A();
// CHECK:STDOUT:
// CHECK:STDOUT: --- implicit.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %A.type: type = fn_type @A [template]
// CHECK:STDOUT:   %A: %A.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref: %A.type = import_ref Implicit//default, inst+3, loaded [template = constants.%A]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .A = imports.%import_ref
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .a = %a
// CHECK:STDOUT:     .package_a = %package_a
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Implicit.import = import Implicit
// CHECK:STDOUT:   %default.import = import <invalid>
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
// CHECK:STDOUT:   %.loc4_9.1: %.1 = tuple_literal ()
// CHECK:STDOUT:   %.loc4_9.2: type = converted %.loc4_9.1, constants.%.1 [template = constants.%.1]
// CHECK:STDOUT:   %a.var: ref %.1 = var a
// CHECK:STDOUT:   %a: ref %.1 = bind_name a, %a.var
// CHECK:STDOUT:   %.loc6_17.1: %.1 = tuple_literal ()
// CHECK:STDOUT:   %.loc6_17.2: type = converted %.loc6_17.1, constants.%.1 [template = constants.%.1]
// CHECK:STDOUT:   %package_a.var: ref %.1 = var package_a
// CHECK:STDOUT:   %package_a: ref %.1 = bind_name package_a, %package_a.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @A();
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %A.ref.loc4: %A.type = name_ref A, imports.%import_ref [template = constants.%A]
// CHECK:STDOUT:   %A.call.loc4: init %.1 = call %A.ref.loc4()
// CHECK:STDOUT:   assign file.%a.var, %A.call.loc4
// CHECK:STDOUT:   %package.ref: <namespace> = name_ref package, package [template = package]
// CHECK:STDOUT:   %A.ref.loc6: %A.type = name_ref A, imports.%import_ref [template = constants.%A]
// CHECK:STDOUT:   %A.call.loc6: init %.1 = call %A.ref.loc6()
// CHECK:STDOUT:   assign file.%package_a.var, %A.call.loc6
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- same_package.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %B.type: type = fn_type @B [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %B: %B.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .B = %B.decl
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
// CHECK:STDOUT:   %B.decl: %B.type = fn_decl @B [template = constants.%B] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @B();
// CHECK:STDOUT:
// CHECK:STDOUT: --- same_package_importer.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %B.type: type = fn_type @B [template]
// CHECK:STDOUT:   %B: %B.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref: %B.type = import_ref SamePackage//default, inst+3, loaded [template = constants.%B]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .B = imports.%import_ref
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .b = %b
// CHECK:STDOUT:     .package_b = %package_b
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
// CHECK:STDOUT:   %.loc6_9.1: %.1 = tuple_literal ()
// CHECK:STDOUT:   %.loc6_9.2: type = converted %.loc6_9.1, constants.%.1 [template = constants.%.1]
// CHECK:STDOUT:   %b.var: ref %.1 = var b
// CHECK:STDOUT:   %b: ref %.1 = bind_name b, %b.var
// CHECK:STDOUT:   %.loc8_17.1: %.1 = tuple_literal ()
// CHECK:STDOUT:   %.loc8_17.2: type = converted %.loc8_17.1, constants.%.1 [template = constants.%.1]
// CHECK:STDOUT:   %package_b.var: ref %.1 = var package_b
// CHECK:STDOUT:   %package_b: ref %.1 = bind_name package_b, %package_b.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @B();
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %B.ref.loc6: %B.type = name_ref B, imports.%import_ref [template = constants.%B]
// CHECK:STDOUT:   %B.call.loc6: init %.1 = call %B.ref.loc6()
// CHECK:STDOUT:   assign file.%b.var, %B.call.loc6
// CHECK:STDOUT:   %package.ref: <namespace> = name_ref package, package [template = package]
// CHECK:STDOUT:   %B.ref.loc8: %B.type = name_ref B, imports.%import_ref [template = constants.%B]
// CHECK:STDOUT:   %B.call.loc8: init %.1 = call %B.ref.loc8()
// CHECK:STDOUT:   assign file.%package_b.var, %B.call.loc8
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
