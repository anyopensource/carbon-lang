// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

fn ReturnSecond(_: i32, x: i32) -> i32 {
  return x;
}

fn Main() -> i32 {
  return ReturnSecond(1, 0);
}

// CHECK:STDOUT: result: 0
