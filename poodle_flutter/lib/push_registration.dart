import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

StreamSubscription<String>? _registrationSubscription;

/// Requests Android notification permission and registers this installation.
///
/// The backend will receive the installation ID in a later integration step.
/// Until then, debug builds print it for Firebase Console test messages.
Future<void> startAndroidPushRegistration() async {
  final messaging = FirebaseMessaging.instance;
  _registrationSubscription ??= messaging.onRegistered.listen(
    (installationId) {
      if (kDebugMode) {
        debugPrint('Poodle FCM installation ID: $installationId');
      }
    },
    onError: (Object error, StackTrace stackTrace) {
      debugPrint('FCM registration event failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    },
  );

  try {
    final settings = await messaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      debugPrint('FCM notification permission was not granted.');
      return;
    }
    await messaging.register();
  } catch (error, stackTrace) {
    debugPrint('FCM registration failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}
