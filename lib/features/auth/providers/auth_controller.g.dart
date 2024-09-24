// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isAuthorizedHash() => r'a838b19bd598333ffccc2fb5dd35e5e0168b22ce';

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
String _$isAdminHash() => r'2273067e11a0d457106fba92466d10feb1f53077';

/// See also [isAdmin].
@ProviderFor(isAdmin)
final isAdminProvider = FutureProvider<bool>.internal(
  isAdmin,
  name: r'isAdminProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isAdminHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsAdminRef = FutureProviderRef<bool>;
String _$isDeliveryPartnerHash() => r'2d258b859d31daccb09f9924d77c5d20fe57125c';

/// See also [isDeliveryPartner].
@ProviderFor(isDeliveryPartner)
final isDeliveryPartnerProvider = FutureProvider<bool>.internal(
  isDeliveryPartner,
  name: r'isDeliveryPartnerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isDeliveryPartnerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsDeliveryPartnerRef = FutureProviderRef<bool>;
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
