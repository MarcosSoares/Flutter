// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'framework.dart';

export 'package:flutter/services.dart' show AutofillHints;

/// An [AutofillScope] widget that defines a group of [AutofillClient]s.
///
/// {@macro flutter.services.autofill.AutofillScope}
///
/// {@tool dartpad --template=stateful_widget_material}
///
/// An example [Form] with autofillable username and password fields.
///
/// ```dart
///  bool isSameAddress = true;
///  final TextEditingController shippingAddress1 = TextEditingController();
///  final TextEditingController shippingAddress2 = TextEditingController();
///  final TextEditingController billingAddress1 = TextEditingController();
///  final TextEditingController billingAddress2 = TextEditingController();
///
///  final TextEditingController creditCardNumber = TextEditingController();
///  final TextEditingController creditCardSecurityCode = TextEditingController();
///
///  final TextEditingController phoneNumber = TextEditingController();
///
///  @override
///  Widget build(BuildContext context) {
///    return ListView(
///      children: <Widget>[
///        const Text('Shipping address'),
///        // The address fields are grouped together as some platforms are capable
///        // of autofilling all these fields in one go.
///        Autofill(
///          child: Column(
///            children: <Widget>[
///              TextField(
///                controller: shippingAddress1,
///                autofillHints: <String>[AutofillHints.streetAddressLine1],
///              ),
///              TextField(
///                controller: shippingAddress2,
///                autofillHints: <String>[AutofillHints.streetAddressLine2],
///              ),
///            ],
///          ),
///        ),
///        const Text('Billing address'),
///        Checkbox(
///          value: isSameAddress,
///          onChanged: (bool newValue) {
///            setState(() { isSameAddress = newValue; });
///          },
///        ),
///        // Again the address fields are grouped together for the same reason.
///        if (!isSameAddress) Autofill(
///          child: Column(
///            children: <Widget>[
///              TextField(
///                controller: billingAddress1,
///                autofillHints: <String>[AutofillHints.streetAddressLine1],
///              ),
///              TextField(
///                controller: billingAddress2,
///                autofillHints: <String>[AutofillHints.streetAddressLine2],
///              ),
///            ],
///          ),
///        ),
///        const Text('Credit Card Information'),
///        // The credit card number and the security code are grouped together as
///        // some platforms are capable of autofilling both fields.
///        Autofill(
///          child: Column(
///            children: <Widget>[
///              TextField(
///                controller: creditCardNumber,
///                autofillHints: <String>[AutofillHints.creditCardNumber],
///              ),
///              TextField(
///                controller: creditCardSecurityCode,
///                autofillHints: <String>[AutofillHints.creditCardSecurityCode],
///              ),
///            ],
///          ),
///        ),
///        const Text('Contact Phone Number'),
///        // The phone number field can still be autofilled despite lacking an
///        // `AutofillScope`.
///        TextField(
///          controller: phoneNumber,
///          autofillHints: <String>[AutofillHints.telephoneNumber],
///        ),
///      ],
///    );
///  }
/// ```
/// {@end-tool}
class AutofillGroup extends StatefulWidget {
  /// Creates a scope for autofillable input fields.
  ///
  /// The [child] argument must not be null.
  ///
  /// The [AutofillGroup] traverses its subtree using [Element.visitChildElements],
  /// looking for [Element]s or [State]s that are [AutofillClient]s. Other
  /// [AutofillGroup] nodes and their subtrees will be ignored in this process.
  const AutofillGroup({
    Key key,
    @required this.child,
  }) : assert(child != null),
       super(key: key);

  /// Returns the closest [AutofillScope]'s [State] which encloses the given context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// FormState form = Form.of(context);
  /// form.save();
  /// ```
  static _AutofillScopeState of(BuildContext context) {
    final _AutofillScope scope = context.dependOnInheritedWidgetOfExactType<_AutofillScope>();
    return scope?._scope;
  }

  /// The widget below this widget in the tree.
  ///
  /// This is the root of the widget hierarchy that contains this form.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  _AutofillScopeState createState() => _AutofillScopeState();
}

/// State associated with a [Form] widget.
///
/// A [FormState] object can be used to [save], [reset], and [validate] every
/// [FormField] that is a descendant of the associated [Form].
///
/// Typically obtained via [Form.of].
class _AutofillScopeState extends State<AutofillGroup> with AutofillScopeMixin {
  @override
  Iterable<AutofillClient> get autofillClients {
    final List<AutofillClient> clients = <AutofillClient>[];
    void visit(Element element) {
      if (element is AutofillScope)
        return;
      if (element is AutofillClient) {
        clients.add(element as AutofillClient);
      } else if (element is StatefulElement && element.state is AutofillClient) {
        clients.add(element.state as AutofillClient);
      } else {
        element.visitChildElements(visit);
      }
    }

    context.visitChildElements(visit);
    return clients;
  }

  @override
  Widget build(BuildContext context) {
    return _AutofillScope(
      formState: this,
      child: widget.child,
    );
  }
}

class _AutofillScope extends InheritedWidget {
  const _AutofillScope({
    Key key,
    Widget child,
    _AutofillScopeState formState,
  }) : _scope = formState,
       super(key: key, child: child);

  final _AutofillScopeState _scope;

  AutofillGroup get client => _scope.widget;

  @override
  bool updateShouldNotify(_AutofillScope old) => false;
}
