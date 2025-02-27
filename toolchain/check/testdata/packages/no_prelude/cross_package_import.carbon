// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/packages/no_prelude/cross_package_import.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/packages/no_prelude/cross_package_import.carbon

// ============================================================================
// Setup files
// ============================================================================

// --- other_fn.carbon

package Other library "fn";

fn F() {}

// --- other_fn_extern.carbon

package Other library "fn_extern";

extern fn F();

// --- other_fn_conflict.carbon

package Other library "fn_conflict";

fn F(x: ()) {}

// --- other_fn2.carbon

package Other library "fn2";

fn F2() {}

// --- other_fn_use.carbon

package Other library "fn_use";

import library "fn";

fn G() { F(); }

// --- main_other_ns.carbon

library "other_ns";

namespace Other;

// ============================================================================
// Test files
// ============================================================================

// --- main_use_other.carbon

library "use_other";

import Other library "fn";
import Other library "fn2";

fn Run() {
  Other.F();
  Other.F2();
}

// --- fail_todo_main_use_other_extern.carbon

library "use_other_extern";

// CHECK:STDERR: fail_todo_main_use_other_extern.carbon:[[@LINE+12]]:1: In import.
// CHECK:STDERR: import Other library "fn";
// CHECK:STDERR: ^~~~~~
// CHECK:STDERR: other_fn_extern.carbon:4:1: ERROR: Duplicate name being declared in the same scope.
// CHECK:STDERR: extern fn F();
// CHECK:STDERR: ^~~~~~~~~~~~~~
// CHECK:STDERR: fail_todo_main_use_other_extern.carbon:[[@LINE+6]]:1: In import.
// CHECK:STDERR: import Other library "fn";
// CHECK:STDERR: ^~~~~~
// CHECK:STDERR: other_fn.carbon:4:1: Name is previously declared here.
// CHECK:STDERR: fn F() {}
// CHECK:STDERR: ^~~~~~~~
import Other library "fn";
import Other library "fn_extern";

fn Run() {
  // CHECK:STDERR: fail_todo_main_use_other_extern.carbon:[[@LINE+4]]:3: In name lookup for `F`.
  // CHECK:STDERR:   Other.F();
  // CHECK:STDERR:   ^~~~~~~
  // CHECK:STDERR:
  Other.F();
}

// --- main_unused_other_ambiguous.carbon

library "unused_other_ambiguous";

import Other library "fn";
import Other library "fn_conflict";

// --- fail_main_use_other_ambiguous.carbon

library "use_other_ambiguous";

// CHECK:STDERR: fail_main_use_other_ambiguous.carbon:[[@LINE+12]]:1: In import.
// CHECK:STDERR: import Other library "fn";
// CHECK:STDERR: ^~~~~~
// CHECK:STDERR: other_fn_conflict.carbon:4:1: ERROR: Duplicate name being declared in the same scope.
// CHECK:STDERR: fn F(x: ()) {}
// CHECK:STDERR: ^~~~~~~~~~~~~
// CHECK:STDERR: fail_main_use_other_ambiguous.carbon:[[@LINE+6]]:1: In import.
// CHECK:STDERR: import Other library "fn";
// CHECK:STDERR: ^~~~~~
// CHECK:STDERR: other_fn.carbon:4:1: Name is previously declared here.
// CHECK:STDERR: fn F() {}
// CHECK:STDERR: ^~~~~~~~
import Other library "fn";
import Other library "fn_conflict";

fn Run() {
  // CHECK:STDERR: fail_main_use_other_ambiguous.carbon:[[@LINE+4]]:3: In name lookup for `F`.
  // CHECK:STDERR:   Other.F();
  // CHECK:STDERR:   ^~~~~~~
  // CHECK:STDERR:
  Other.F();
}

// --- fail_main_namespace_conflict.carbon

library "namespace_conflict";

import library "other_ns";
// CHECK:STDERR: fail_main_namespace_conflict.carbon:[[@LINE+10]]:1: ERROR: Duplicate name being declared in the same scope.
// CHECK:STDERR: import Other library "fn";
// CHECK:STDERR: ^~~~~~
// CHECK:STDERR: fail_main_namespace_conflict.carbon:[[@LINE-4]]:1: In import.
// CHECK:STDERR: import library "other_ns";
// CHECK:STDERR: ^~~~~~
// CHECK:STDERR: main_other_ns.carbon:4:1: Name is previously declared here.
// CHECK:STDERR: namespace Other;
// CHECK:STDERR: ^~~~~~~~~~~~~~~~
// CHECK:STDERR:
import Other library "fn";

// CHECK:STDERR: fail_main_namespace_conflict.carbon:[[@LINE+10]]:1: ERROR: Only one library can declare `fn F` without `extern`.
// CHECK:STDERR: fn Other.F() {}
// CHECK:STDERR: ^~~~~~~~~~~~~~
// CHECK:STDERR: fail_main_namespace_conflict.carbon:[[@LINE-5]]:1: In import.
// CHECK:STDERR: import Other library "fn";
// CHECK:STDERR: ^~~~~~
// CHECK:STDERR: other_fn.carbon:4:1: Previously declared here.
// CHECK:STDERR: fn F() {}
// CHECK:STDERR: ^~~~~~~~
// CHECK:STDERR:
fn Other.F() {}

// --- fail_main_reopen_other.carbon

library "reopen_other";

import Other library "fn";

// CHECK:STDERR: fail_main_reopen_other.carbon:[[@LINE+7]]:1: ERROR: Duplicate name being declared in the same scope.
// CHECK:STDERR: namespace Other;
// CHECK:STDERR: ^~~~~~~~~~~~~~~~
// CHECK:STDERR: fail_main_reopen_other.carbon:[[@LINE-5]]:1: Name is previously declared here.
// CHECK:STDERR: import Other library "fn";
// CHECK:STDERR: ^~~~~~
// CHECK:STDERR:
namespace Other;

// This is not diagnosed after the diagnostic on `namespace Other;`.
fn Other.G() {}

// --- fail_main_reopen_other_nested.carbon

library "reopen_other_nested";

import Other library "fn";

// CHECK:STDERR: fail_main_reopen_other_nested.carbon:[[@LINE+7]]:11: ERROR: Imported packages cannot be used for declarations.
// CHECK:STDERR: namespace Other.Nested;
// CHECK:STDERR:           ^~~~~
// CHECK:STDERR: fail_main_reopen_other_nested.carbon:[[@LINE-5]]:1: Package imported here.
// CHECK:STDERR: import Other library "fn";
// CHECK:STDERR: ^~~~~~
// CHECK:STDERR:
namespace Other.Nested;

// This is not diagnosed after the diagnostic on `namespace Other;`.
fn Other.Nested.F() {}

// --- fail_main_add_to_other.carbon

library "add_to_other";

import Other library "fn";

// CHECK:STDERR: fail_main_add_to_other.carbon:[[@LINE+7]]:4: ERROR: Imported packages cannot be used for declarations.
// CHECK:STDERR: fn Other.G() {}
// CHECK:STDERR:    ^~~~~
// CHECK:STDERR: fail_main_add_to_other.carbon:[[@LINE-5]]:1: Package imported here.
// CHECK:STDERR: import Other library "fn";
// CHECK:STDERR: ^~~~~~
// CHECK:STDERR:
fn Other.G() {}

// --- fail_use_other_fn_use.carbon

library "fail_use_other_fn_use";

import Other library "fn_use";

// CHECK:STDERR: fail_use_other_fn_use.carbon:[[@LINE+3]]:13: ERROR: Name `F` not found.
// CHECK:STDERR: fn UseF() { Other.F(); }
// CHECK:STDERR:             ^~~~~~~
fn UseF() { Other.F(); }

// CHECK:STDOUT: --- other_fn.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .F = %F.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %F.decl: %F.type = fn_decl @F [template = constants.%F] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- other_fn_extern.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .F = %F.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %F.decl: %F.type = fn_decl @F [template = constants.%F] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: extern fn @F();
// CHECK:STDOUT:
// CHECK:STDOUT: --- other_fn_conflict.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .F = %F.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %F.decl: %F.type = fn_decl @F [template = constants.%F] {
// CHECK:STDOUT:     %.loc4_10.1: %.1 = tuple_literal ()
// CHECK:STDOUT:     %.loc4_10.2: type = converted %.loc4_10.1, constants.%.1 [template = constants.%.1]
// CHECK:STDOUT:     %x.loc4_6.1: %.1 = param x
// CHECK:STDOUT:     @F.%x: %.1 = bind_name x, %x.loc4_6.1
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F(%x: %.1) {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- other_fn2.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %F2.type: type = fn_type @F2 [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %F2: %F2.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .F2 = %F2.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %F2.decl: %F2.type = fn_decl @F2 [template = constants.%F2] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F2() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- other_fn_use.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %G.type: type = fn_type @G [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %G: %G.type = struct_value () [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref: %F.type = import_ref Other//fn, inst+1, loaded [template = constants.%F]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .F = imports.%import_ref
// CHECK:STDOUT:     .G = %G.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %G.decl: %G.type = fn_decl @G [template = constants.%G] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @G() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, imports.%import_ref [template = constants.%F]
// CHECK:STDOUT:   %F.call: init %.1 = call %F.ref()
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F();
// CHECK:STDOUT:
// CHECK:STDOUT: --- main_other_ns.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = %Other
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Other: <namespace> = namespace [template] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- main_use_other.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Run.type: type = fn_type @Run [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Run: %Run.type = struct_value () [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT:   %F2.type: type = fn_type @F2 [template]
// CHECK:STDOUT:   %F2: %F2.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: %F.type = import_ref Other//fn, inst+1, loaded [template = constants.%F]
// CHECK:STDOUT:   %import_ref.2: %F2.type = import_ref Other//fn2, inst+1, loaded [template = constants.%F2]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = %Other
// CHECK:STDOUT:     .Run = %Run.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT:   %Other: <namespace> = namespace %Other.import, [template] {
// CHECK:STDOUT:     import Other//fn
// CHECK:STDOUT:     import Other//fn2
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Run.decl: %Run.type = fn_decl @Run [template = constants.%Run] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Run() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Other.ref.loc8: <namespace> = name_ref Other, file.%Other [template = file.%Other]
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, imports.%import_ref.1 [template = constants.%F]
// CHECK:STDOUT:   %F.call: init %.1 = call %F.ref()
// CHECK:STDOUT:   %Other.ref.loc9: <namespace> = name_ref Other, file.%Other [template = file.%Other]
// CHECK:STDOUT:   %F2.ref: %F2.type = name_ref F2, imports.%import_ref.2 [template = constants.%F2]
// CHECK:STDOUT:   %F2.call: init %.1 = call %F2.ref()
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F();
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F2();
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_todo_main_use_other_extern.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Run.type: type = fn_type @Run [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Run: %Run.type = struct_value () [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: %F.type = import_ref Other//fn, inst+1, loaded [template = constants.%F]
// CHECK:STDOUT:   %import_ref.2 = import_ref Other//fn_extern, inst+1, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = %Other
// CHECK:STDOUT:     .Run = %Run.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT:   %Other: <namespace> = namespace %Other.import, [template] {
// CHECK:STDOUT:     import Other//fn
// CHECK:STDOUT:     import Other//fn_extern
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Run.decl: %Run.type = fn_decl @Run [template = constants.%Run] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Run() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Other.ref: <namespace> = name_ref Other, file.%Other [template = file.%Other]
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, imports.%import_ref.1 [template = constants.%F]
// CHECK:STDOUT:   %F.call: init %.1 = call %F.ref()
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F();
// CHECK:STDOUT:
// CHECK:STDOUT: --- main_unused_other_ambiguous.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = %Other
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT:   %Other: <namespace> = namespace %Other.import, [template] {
// CHECK:STDOUT:     import Other//fn
// CHECK:STDOUT:     import Other//fn_conflict
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_main_use_other_ambiguous.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Run.type: type = fn_type @Run [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Run: %Run.type = struct_value () [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: %F.type = import_ref Other//fn, inst+1, loaded [template = constants.%F]
// CHECK:STDOUT:   %import_ref.2 = import_ref Other//fn_conflict, inst+6, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = %Other
// CHECK:STDOUT:     .Run = %Run.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT:   %Other: <namespace> = namespace %Other.import, [template] {
// CHECK:STDOUT:     import Other//fn
// CHECK:STDOUT:     import Other//fn_conflict
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Run.decl: %Run.type = fn_decl @Run [template = constants.%Run] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Run() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Other.ref: <namespace> = name_ref Other, file.%Other [template = file.%Other]
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, imports.%import_ref.1 [template = constants.%F]
// CHECK:STDOUT:   %F.call: init %.1 = call %F.ref()
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F();
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_main_namespace_conflict.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref: %F.type = import_ref Other//fn, inst+1, loaded [template = constants.%F]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = %Other
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT:   %import_ref: <namespace> = import_ref Main//other_ns, inst+1, loaded
// CHECK:STDOUT:   %Other: <namespace> = namespace %import_ref, [template] {
// CHECK:STDOUT:     import Other//fn
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %F.decl: %F.type = fn_decl @F [template = constants.%F] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_main_reopen_other.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %G.type: type = fn_type @G [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %G: %G.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = %Other
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT:   %Other: <namespace> = namespace %Other.import, [template] {
// CHECK:STDOUT:     .G = %G.decl
// CHECK:STDOUT:     import Other//fn
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %.loc13: <namespace> = namespace [template] {}
// CHECK:STDOUT:   %G.decl: %G.type = fn_decl @G [template = constants.%G] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @G() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_main_reopen_other_nested.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = %Other
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT:   %Other: <namespace> = namespace %Other.import, [template] {
// CHECK:STDOUT:     .Nested = %Nested
// CHECK:STDOUT:     import Other//fn
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Nested: <namespace> = namespace [template] {
// CHECK:STDOUT:     .F = %F.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %F.decl: %F.type = fn_decl @F [template = constants.%F] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_main_add_to_other.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %G.type: type = fn_type @G [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %G: %G.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = %Other
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT:   %Other: <namespace> = namespace %Other.import, [template] {
// CHECK:STDOUT:     .G = %G.decl
// CHECK:STDOUT:     import Other//fn
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %G.decl: %G.type = fn_decl @G [template = constants.%G] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @G() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_use_other_fn_use.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %UseF.type: type = fn_type @UseF [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %UseF: %UseF.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = %Other
// CHECK:STDOUT:     .UseF = %UseF.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT:   %Other: <namespace> = namespace %Other.import, [template] {
// CHECK:STDOUT:     import Other//fn_use
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %UseF.decl: %UseF.type = fn_decl @UseF [template = constants.%UseF] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @UseF() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Other.ref: <namespace> = name_ref Other, file.%Other [template = file.%Other]
// CHECK:STDOUT:   %F.ref: <error> = name_ref F, <error> [template = <error>]
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
