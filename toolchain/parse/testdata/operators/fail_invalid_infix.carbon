// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/parse/testdata/operators/fail_invalid_infix.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/parse/testdata/operators/fail_invalid_infix.carbon

// CHECK:STDERR: fail_invalid_infix.carbon:[[@LINE+4]]:19: ERROR: Expected expression.
// CHECK:STDERR: var a: i32 = n == ;
// CHECK:STDERR:                   ^
// CHECK:STDERR:
var a: i32 = n == ;
// CHECK:STDERR: fail_invalid_infix.carbon:[[@LINE+4]]:14: ERROR: Expected expression.
// CHECK:STDERR: var b: i32 = == n;
// CHECK:STDERR:              ^~
// CHECK:STDERR:
var b: i32 = == n;
// CHECK:STDERR: fail_invalid_infix.carbon:[[@LINE+7]]:14: ERROR: Expected expression.
// CHECK:STDERR: var c: i32 = == ;
// CHECK:STDERR:              ^~
// CHECK:STDERR:
// CHECK:STDERR: fail_invalid_infix.carbon:[[@LINE+3]]:17: ERROR: Expected expression.
// CHECK:STDERR: var c: i32 = == ;
// CHECK:STDERR:                 ^
var c: i32 = == ;

// CHECK:STDOUT: - filename: fail_invalid_infix.carbon
// CHECK:STDOUT:   parse_tree: [
// CHECK:STDOUT:     {kind: 'FileStart', text: ''},
// CHECK:STDOUT:       {kind: 'VariableIntroducer', text: 'var'},
// CHECK:STDOUT:         {kind: 'IdentifierName', text: 'a'},
// CHECK:STDOUT:         {kind: 'IntTypeLiteral', text: 'i32'},
// CHECK:STDOUT:       {kind: 'BindingPattern', text: ':', subtree_size: 3},
// CHECK:STDOUT:       {kind: 'VariableInitializer', text: '='},
// CHECK:STDOUT:         {kind: 'IdentifierNameExpr', text: 'n'},
// CHECK:STDOUT:         {kind: 'InvalidParse', text: ';', has_error: yes},
// CHECK:STDOUT:       {kind: 'InfixOperatorEqualEqual', text: '==', has_error: yes, subtree_size: 3},
// CHECK:STDOUT:     {kind: 'VariableDecl', text: ';', subtree_size: 9},
// CHECK:STDOUT:       {kind: 'VariableIntroducer', text: 'var'},
// CHECK:STDOUT:         {kind: 'IdentifierName', text: 'b'},
// CHECK:STDOUT:         {kind: 'IntTypeLiteral', text: 'i32'},
// CHECK:STDOUT:       {kind: 'BindingPattern', text: ':', subtree_size: 3},
// CHECK:STDOUT:       {kind: 'VariableInitializer', text: '='},
// CHECK:STDOUT:         {kind: 'InvalidParse', text: '==', has_error: yes},
// CHECK:STDOUT:         {kind: 'IdentifierNameExpr', text: 'n'},
// CHECK:STDOUT:       {kind: 'InfixOperatorEqualEqual', text: '==', has_error: yes, subtree_size: 3},
// CHECK:STDOUT:     {kind: 'VariableDecl', text: ';', subtree_size: 9},
// CHECK:STDOUT:       {kind: 'VariableIntroducer', text: 'var'},
// CHECK:STDOUT:         {kind: 'IdentifierName', text: 'c'},
// CHECK:STDOUT:         {kind: 'IntTypeLiteral', text: 'i32'},
// CHECK:STDOUT:       {kind: 'BindingPattern', text: ':', subtree_size: 3},
// CHECK:STDOUT:       {kind: 'VariableInitializer', text: '='},
// CHECK:STDOUT:         {kind: 'InvalidParse', text: '==', has_error: yes},
// CHECK:STDOUT:         {kind: 'InvalidParse', text: ';', has_error: yes},
// CHECK:STDOUT:       {kind: 'InfixOperatorEqualEqual', text: '==', has_error: yes, subtree_size: 3},
// CHECK:STDOUT:     {kind: 'VariableDecl', text: ';', subtree_size: 9},
// CHECK:STDOUT:     {kind: 'FileEnd', text: ''},
// CHECK:STDOUT:   ]
