// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/namespace/fail_modifiers.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/namespace/fail_modifiers.carbon

// CHECK:STDERR: fail_modifiers.carbon:[[@LINE+33]]:1: ERROR: `private` not allowed on `namespace` declaration.
// CHECK:STDERR: private extern abstract base default final namespace A;
// CHECK:STDERR: ^~~~~~~
// CHECK:STDERR:
// CHECK:STDERR: fail_modifiers.carbon:[[@LINE+29]]:9: ERROR: `extern` not allowed on `namespace` declaration.
// CHECK:STDERR: private extern abstract base default final namespace A;
// CHECK:STDERR:         ^~~~~~
// CHECK:STDERR:
// CHECK:STDERR: fail_modifiers.carbon:[[@LINE+25]]:16: ERROR: `abstract` not allowed on `namespace` declaration.
// CHECK:STDERR: private extern abstract base default final namespace A;
// CHECK:STDERR:                ^~~~~~~~
// CHECK:STDERR:
// CHECK:STDERR: fail_modifiers.carbon:[[@LINE+21]]:25: ERROR: `base` not allowed on declaration with `abstract`.
// CHECK:STDERR: private extern abstract base default final namespace A;
// CHECK:STDERR:                         ^~~~
// CHECK:STDERR: fail_modifiers.carbon:[[@LINE+18]]:16: `abstract` previously appeared here.
// CHECK:STDERR: private extern abstract base default final namespace A;
// CHECK:STDERR:                ^~~~~~~~
// CHECK:STDERR:
// CHECK:STDERR: fail_modifiers.carbon:[[@LINE+14]]:30: ERROR: `default` not allowed on declaration with `abstract`.
// CHECK:STDERR: private extern abstract base default final namespace A;
// CHECK:STDERR:                              ^~~~~~~
// CHECK:STDERR: fail_modifiers.carbon:[[@LINE+11]]:16: `abstract` previously appeared here.
// CHECK:STDERR: private extern abstract base default final namespace A;
// CHECK:STDERR:                ^~~~~~~~
// CHECK:STDERR:
// CHECK:STDERR: fail_modifiers.carbon:[[@LINE+7]]:38: ERROR: `final` not allowed on declaration with `abstract`.
// CHECK:STDERR: private extern abstract base default final namespace A;
// CHECK:STDERR:                                      ^~~~~
// CHECK:STDERR: fail_modifiers.carbon:[[@LINE+4]]:16: `abstract` previously appeared here.
// CHECK:STDERR: private extern abstract base default final namespace A;
// CHECK:STDERR:                ^~~~~~~~
// CHECK:STDERR:
private extern abstract base default final namespace A;

// CHECK:STDERR: fail_modifiers.carbon:[[@LINE+4]]:1: ERROR: `impl` not allowed on `namespace` declaration.
// CHECK:STDERR: impl namespace B;
// CHECK:STDERR: ^~~~
// CHECK:STDERR:
impl namespace B;

// CHECK:STDERR: fail_modifiers.carbon:[[@LINE+3]]:1: ERROR: `extern` not allowed on `namespace` declaration.
// CHECK:STDERR: extern namespace C;
// CHECK:STDERR: ^~~~~~
extern namespace C;

// CHECK:STDOUT: --- fail_modifiers.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .A = %A
// CHECK:STDOUT:     .B = %B
// CHECK:STDOUT:     .C = %C
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
// CHECK:STDOUT:   %A: <namespace> = namespace [template] {}
// CHECK:STDOUT:   %B: <namespace> = namespace [template] {}
// CHECK:STDOUT:   %C: <namespace> = namespace [template] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
