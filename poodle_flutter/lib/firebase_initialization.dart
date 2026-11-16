import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Initializes Firebase from the Android or Apple native config file.
///
/// Push setup must not prevent the rest of the app from starting when Firebase
/// is temporarily unavailable or its native configuration is incomplete.
Future<bool> initializeMobileFirebase() async {
  if (kIsWeb ||
      (defaultTargetPlatform != TargetPlatform.android &&
          defaultTargetPlatform != TargetPlatform.iOS)) {
    return false;
  }

  try {
    await Firebase.initializeApp();
    return true;
  } catch (error, stackTrace) {
    debugPrint('Firebase initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
    return false;
  }
}
