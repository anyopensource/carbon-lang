// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#ifndef CARBON_TOOLCHAIN_SEM_IR_INTERFACE_H_
#define CARBON_TOOLCHAIN_SEM_IR_INTERFACE_H_

#include "toolchain/sem_ir/ids.h"

namespace Carbon::SemIR {

// An interface.
struct Interface : public Printable<Interface> {
  auto Print(llvm::raw_ostream& out) const -> void {
    out << "{name: " << name_id << ", parent_scope: " << parent_scope_id << "}";
  }

  // Determines whether this interface has been fully defined. This is false
  // until we reach the `}` of the interface definition.
  auto is_defined() const -> bool { return associated_entities_id.is_valid(); }

  // Determines whether we're currently defining the interface. This is true
  // between the braces of the interface.
  auto is_being_defined() const -> bool {
    return definition_id.is_valid() && !is_defined();
  }

  // Determines whether this is a generic interface.
  auto is_generic() const -> bool {
    return implicit_param_refs_id.is_valid() || param_refs_id.is_valid();
  }

  // The following members always have values, and do not change throughout the
  // lifetime of the interface.

  // The interface name.
  NameId name_id;
  // The parent scope.
  NameScopeId parent_scope_id;
  // If this is a generic function, information about the generic.
  GenericId generic_id;
  // Parse tree bounds for the parameters, including both implicit and explicit
  // parameters. These will be compared to match between declaration and
  // definition.
  Parse::NodeId first_param_node_id;
  Parse::NodeId last_param_node_id;
  // A block containing a single reference instruction per implicit parameter.
  InstBlockId implicit_param_refs_id;
  // A block containing a single reference instruction per parameter.
  InstBlockId param_refs_id;
  // The first declaration of the interface. This is a InterfaceDecl.
  InstId decl_id;

  // The following members are set at the `{` of the interface definition.

  // The definition of the interface. This is a InterfaceDecl.
  InstId definition_id = InstId::Invalid;
  // The interface scope.
  NameScopeId scope_id = NameScopeId::Invalid;
  // The first block of the interface body.
  // TODO: Handle control flow in the interface body, such as if-expressions.
  InstBlockId body_block_id = InstBlockId::Invalid;
  // The implicit `Self` parameter. This is a BindSymbolicName instruction.
  InstId self_param_id = InstId::Invalid;

  // The following members are set at the `}` of the interface definition.
  InstBlockId associated_entities_id = InstBlockId::Invalid;
};

}  // namespace Carbon::SemIR

#endif  // CARBON_TOOLCHAIN_SEM_IR_INTERFACE_H_
