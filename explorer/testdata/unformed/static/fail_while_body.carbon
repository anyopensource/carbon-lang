// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

fn Foo() -> i32;

fn Main() -> i32 {
  var (x: i32, y: i32);
  while (Foo() == 0) {
    // CHECK:STDERR: COMPILATION ERROR: fail_while_body.carbon:[[@LINE+1]]: use of uninitialized variable x
    y = x;
  }
  return 1;
}
