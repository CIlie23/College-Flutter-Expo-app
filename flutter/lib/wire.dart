import 'dart:convert';

import 'contract/contract.dart';

/// Exercise 2 — what leaves the phone: the contract's fields only (a contract
/// Entrance has no local-only columns), checked by the contract's rules.
String toWire(Entrance e) {
  final errors = validateEntrance(e);
  if (errors.isNotEmpty) throw FormatException(errors.join('; '));
  return jsonEncode(e.toJson());
}

/// What arrives: JSON text back into a checked entrance. fromJson ignores the
/// keys the contract does not name, the same as zod on the Expo side.
Entrance fromWire(String json) {
  final e = Entrance.fromJson(jsonDecode(json) as Map<String, dynamic>);
  final errors = validateEntrance(e);
  if (errors.isNotEmpty) throw FormatException(errors.join('; '));
  return e;
}
