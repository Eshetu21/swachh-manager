// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isAuthorizedHash() => r'1f93006869ac3afced56346b1f6f2e76ba23b791';

/// See also [isAuthorized].
@ProviderFor(isAuthorized)
final isAuthorizedProvider = FutureProvider<bool>.internal(
  isAuthorized,
  name: r'isAuthorizedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isAuthorizedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsAuthorizedRef = FutureProviderRef<bool>;
String _$authControllerHash() => r'2f3061a17b0084bfa50c06f1c2b25efd2648d262';

/// See also [authController].
@ProviderFor(authController)
final authControllerProvider = Provider<AuthController>.internal(
  authController,
  name: r'authControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthControllerRef = ProviderRef<AuthController>;
String _$authStateChangesHash() => r'3e55577f2087f6c030f0c985cb73f2339c38909d';

/// See also [authStateChanges].
@ProviderFor(authStateChanges)
final authStateChangesProvider = StreamProvider<AuthState>.internal(
  authStateChanges,
  name: r'authStateChangesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateChangesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthStateChangesRef = StreamProviderRef<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
