// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/lower/testdata/return/return_var.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/lower/testdata/return/return_var.carbon

class C {
  var data: i32;
  var next: C*;
}

fn Make() -> C {
  returned var c: C;
  c = {.data = 42, .next = &c};
  return var;
}

// CHECK:STDOUT: ; ModuleID = 'return_var.carbon'
// CHECK:STDOUT: source_filename = "return_var.carbon"
// CHECK:STDOUT:
// CHECK:STDOUT: define void @Make(ptr sret({ i32, ptr }) %return) {
// CHECK:STDOUT: entry:
// CHECK:STDOUT:   %.loc18_30.2.data = getelementptr inbounds { i32, ptr }, ptr %return, i32 0, i32 0
// CHECK:STDOUT:   %.loc18_30.4.next = getelementptr inbounds { i32, ptr }, ptr %return, i32 0, i32 1
// CHECK:STDOUT:   store ptr %return, ptr %.loc18_30.4.next, align 8
// CHECK:STDOUT:   ret void
// CHECK:STDOUT: }
