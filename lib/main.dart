import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabadmanager/app/app.dart';
import 'package:kabadmanager/core/dependency_container.dart';
import 'package:kabadmanager/features/auth/logic/auth_bloc.dart';
import 'package:kabadmanager/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await initializeServices();

    runApp(
      BlocProvider(
        create: (_) => sl<AuthBloc>(),
        child: const KabadWalaApp(),
      ),
    );
  }, (error, stack) {
    // Report all uncaught errors to Crashlytics in release mode
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } else {
      debugPrint("Uncaught Error: $error");
    }
  });
}

Future<void> initializeServices() async {
  try {
    // Setup dependency injection
    await setUpDependencies();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Enable Flutter error handling in release mode
    if (!kDebugMode) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    // Initialize Supabase
    await Supabase.initialize(
      url: "https://kbfzdoqimcdqltudyeht.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtiZnpkb3FpbWNkcWx0dWR5ZWh0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDU5MzY3MTUsImV4cCI6MjAyMTUxMjcxNX0.b768qlfIDEb9P6mCoReJTTAXYtIYc9d6RIlGkhLKuMg",
    );
  } catch (e, stack) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
    }
    debugPrint("Initialization error: $e");
    rethrow;
  }
}
