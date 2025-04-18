import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } else {
      debugPrint("Uncaught Error: $error");
    }
  });
}

Future<void> initializeServices() async {
  try {
    await dotenv.load(fileName: ".env");
    await setUpDependencies();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (!kDebugMode) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
    await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL'] ?? '',
        anonKey: dotenv.env['SUPABASE_KEY'] ?? '');
  } catch (e, stack) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
    }
    debugPrint("Initialization error: $e");
    rethrow;
  }
}

