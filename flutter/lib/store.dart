import 'dart:convert';

import 'package:flutter/services.dart';

import 'contract/contract.dart';

class Fixtures {
  const Fixtures({
    required this.buildings,
    required this.entrances,
    this.me = 'field-worker',
  });

  final List<Building> buildings;
  final List<Entrance> entrances;
  final String me;

  static Future<Fixtures> load() async {
    final buildingsJson =
        jsonDecode(await rootBundle.loadString('assets/fixtures/buildings.json'))
            as List<dynamic>;
    final entrancesJson =
        jsonDecode(await rootBundle.loadString('assets/fixtures/entrances.json'))
            as List<dynamic>;
    return Fixtures(
      buildings: [
        for (final item in buildingsJson)
          Building.fromJson(item as Map<String, dynamic>),
      ],
      entrances: [
        for (final item in entrancesJson)
          Entrance.fromJson(item as Map<String, dynamic>),
      ],
    );
  }
}
