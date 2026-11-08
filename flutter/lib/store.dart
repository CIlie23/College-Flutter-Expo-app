import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'contract/contract.dart';

/// The fixtures, read once from the assets and checked against the contract.
class Fixtures {
  Fixtures(this.users, this.buildings, this.entrances, this.routes,
      this.stops, this.conversations, this.messages);

  final List<User> users;
  final List<Building> buildings;
  final List<Entrance> entrances;
  final List<Route> routes;
  final List<RouteStop> stops;
  final List<Conversation> conversations;
  final List<Message> messages;

  /// Who is "signed in" until week 4: the worker of the first route.
  String get me => routes.first.workerId;

  static Future<Fixtures> load() async {
    Future<List<Map<String, dynamic>>> read(String name) async =>
        (jsonDecode(await rootBundle.loadString('assets/fixtures/$name.json'))
                as List)
            .cast<Map<String, dynamic>>();

    T check<T>(T row, List<String> Function(T) validate) {
      final errors = validate(row);
      if (errors.isNotEmpty) throw FormatException(errors.join('; '));
      return row;
    }

    final routesJson = await read('routes');
    return Fixtures(
      [for (final j in await read('users')) check(User.fromJson(j), validateUser)],
      [for (final j in await read('buildings')) check(Building.fromJson(j), validateBuilding)],
      [for (final j in await read('entrances')) check(Entrance.fromJson(j), validateEntrance)],
      [for (final j in routesJson) check(Route.fromJson(j), validateRoute)],
      [
        for (final r in routesJson)
          for (final s in (r['stops'] as List).cast<Map<String, dynamic>>())
            check(RouteStop.fromJson(s), validateRouteStop),
      ],
      [for (final j in await read('conversations')) check(Conversation.fromJson(j), validateConversation)],
      [for (final j in await read('messages')) check(Message.fromJson(j), validateMessage)],
    );
  }
}
