// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/lower/testdata/namespace/function.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/lower/testdata/namespace/function.carbon

namespace Foo;

// Never called, just here to help catch bugs in name lookup.
fn Baz() {
}

fn Foo.Baz() {
}

fn Bar() {
  Foo.Baz();
}

// CHECK:STDOUT: ; ModuleID = 'function.carbon'
// CHECK:STDOUT: source_filename = "function.carbon"
// CHECK:STDOUT:
// CHECK:STDOUT: define void @Baz() {
// CHECK:STDOUT: entry:
// CHECK:STDOUT:   ret void
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: define void @Baz.1() {
// CHECK:STDOUT: entry:
// CHECK:STDOUT:   ret void
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: define void @Bar() {
// CHECK:STDOUT: entry:
// CHECK:STDOUT:   call void @Baz.1()
// CHECK:STDOUT:   ret void
// CHECK:STDOUT: }
