import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'permissions.dart';

/// 0 ≤ h < 360, whatever the sensor said (-90 → 270, 360 → 0).
double normalizeHeading(double h) => ((h % 360) + 360) % 360;

const _points = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
String compassPoint(double h) => _points[(normalizeHeading(h) / 45).round() % 8];

class Fix {
  const Fix(this.lat, this.lng, this.accuracy, this.at);
  final double lat, lng;
  final double accuracy; // metres, the radius of 68 % confidence
  final String at;
}

/// Client state, not data: the last fix, kept for the photo and the missed pin.
class FixNotifier extends Notifier<Fix?> {
  @override
  Fix? build() => null;

  void set(Fix fix) => state = fix;
}

final fixProvider = NotifierProvider<FixNotifier, Fix?>(FixNotifier.new);

/// The compass, only while some widget watches it: autoDispose stops the
/// sensor when the last one goes away. No compass on the web.
final headingProvider = StreamProvider.autoDispose<double?>((ref) {
  if (kIsWeb) return Stream.value(null);
  final events = FlutterCompass.events; // null on a phone without the sensor
  if (events == null) return Stream.value(null);
  return events.map((e) => e.heading == null ? null : normalizeHeading(e.heading!));
});

/// One fix, now: the permission in context, then a single position (cheaper
/// on the battery than a subscription).
Future<Fix?> locate(BuildContext context, WidgetRef ref) async {
  if (!await ensureLocation(context)) return null;
  final p = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  );
  final fix = Fix(p.latitude, p.longitude, p.accuracy, p.timestamp.toUtc().toIso8601String());
  ref.read(fixProvider.notifier).set(fix);
  return fix;
}