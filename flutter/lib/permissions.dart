import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Ask for the location when the user does the thing that needs it — never at
/// launch. Granted: true. Denied once: false, and the next press asks again.
/// Denied for good ("Don't allow" twice on Android 11+): the system will not
/// show its dialog any more, request() answers permanentlyDenied at once, so
/// offer the app's Settings.
Future<bool> ensureLocation(BuildContext context) async {
  // The phone's location switch first (geolocator's check also works on the web).
  if (!await Geolocator.isLocationServiceEnabled()) {
    if (context.mounted) {
      await _offer(context, 'Location is off on this phone', Geolocator.openLocationSettings);
    }
    return false;
  }
  // Permission.location: the location permission permission_handler knows on
  // every target, the web included.
  final status = await Permission.location.request();
  if (status.isGranted || status.isLimited) return true;
  if (status.isPermanentlyDenied && context.mounted) {
    await _offer(context, 'Location is off for the field app', openAppSettings);
  }
  return false;
}

Future<void> _offer(BuildContext context, String title, Future<bool> Function() open) =>
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text(
            'The field app tags your photos and new pins with where you stand. '
                'You can turn it on in Settings → Permissions.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Not now')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              open();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );