import 'dart:convert';
import 'dart:io' show Directory, File;

import 'package:drift/drift.dart' show Value;
import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'db/database.dart';
import 'location.dart';
import 'providers.dart';

/// What the photo file says about itself (EXIF), as far as we read it tonight.
class ExifSummary {
  const ExifSummary(this.camera, this.shotAt, this.gpsInExif);
  final String? camera;
  final String? shotAt; // "2026:10:20 18:41:07", the camera's local time, no zone
  final bool gpsInExif;
}

Future<ExifSummary> readExif(List<int> bytes) async {
  final tags = await readExifFromBytes(bytes);
  String? s(String key) => tags[key]?.printable;
  final camera = [s('Image Make'), s('Image Model')].whereType<String>().join(' ');
  return ExifSummary(
    camera.isEmpty ? null : camera,
    s('EXIF DateTimeOriginal') ?? s('Image DateTime'),
    tags.containsKey('GPS GPSLatitude'),
  );
}

/// Keep the picture: copy it out of the picker's cache (the system may empty
/// it) into the app's documents folder, named after the photo row's id.
Future<String> _keep(XFile picked, List<int> bytes, String id) async {
  // No file system on the web: keep the bytes in the row, as a data: URI.
  if (kIsWeb) return 'data:image/jpeg;base64,${base64Encode(bytes)}';
  final docs = await getApplicationDocumentsDirectory();
  final folder = await Directory('${docs.path}/photos').create(recursive: true);
  final file = await File(picked.path).copy('${folder.path}/$id.jpg');
  return file.path;
}

Future<ExifSummary> _save(WidgetRef ref, String entranceId, XFile picked,
    {Fix? where, double? heading, required String takenAt}) async {
  final id = const Uuid().v4(); // the photo's id, born on the phone
  final now = DateTime.now().toUtc().toIso8601String();
  final bytes = await picked.readAsBytes();
  final db = ref.read(databaseProvider);
  await db.into(db.photos).insert(PhotosCompanion.insert(
        id: id,
        createdAt: now,
        updatedAt: now,
        entranceId: entranceId,
        fileName: '$id.jpg',
        takenAt: takenAt,
        lat: Value(where?.lat),
        lng: Value(where?.lng),
        heading: Value(heading),
        localUri: await _keep(picked, bytes, id),
        // uploadState, reviewStatus and syncState start as 'pending' (the defaults)
      ));
  return readExif(bytes);
}

/// The camera: the system camera app takes the picture, then a row. The row's
/// lat/lng are where the PHONE is at the shutter (the contract's meaning) — not
/// the EXIF, which the camera may leave out and the photo picker removes.
Future<ExifSummary?> takePhoto(BuildContext context, WidgetRef ref, String entranceId) async {
  final picked = await ImagePicker().pickImage(source: ImageSource.camera);
  if (picked == null || !context.mounted) return null; // cancelled
  final takenAt = DateTime.now().toUtc().toIso8601String(); // the shutter has just fired
  final fix = await locate(context, ref).catchError((_) => null);
  return _save(ref, entranceId, picked,
      where: fix, heading: fix == null ? null : ref.read(headingProvider).value, takenAt: takenAt);
}

/// EXIF's "2026:10:20 18:41:07" is the camera's local time: read it as this phone's.
String? _exifTime(String? shotAt) {
  final m = RegExp(r'^(\d{4}):(\d{2}):(\d{2}) (\d{2}):(\d{2}):(\d{2})').firstMatch(shotAt ?? '');
  if (m == null) return null;
  final n = [for (var i = 1; i <= 6; i++) int.parse(m.group(i)!)];
  return DateTime(n[0], n[1], n[2], n[3], n[4], n[5]).toUtc().toIso8601String();
}

/// The gallery: Android's photo picker needs no permission (the user picks,
/// the app sees only that file). Where and which way it was taken we do not
/// know — the phone was somewhere else then — so lat, lng and heading stay null.
Future<ExifSummary?> pickPhoto(WidgetRef ref, String entranceId) async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (picked == null) return null;
  final exif = await readExif(await picked.readAsBytes());
  final takenAt = _exifTime(exif.shotAt) ?? DateTime.now().toUtc().toIso8601String();
  return _save(ref, entranceId, picked, takenAt: takenAt);
}
