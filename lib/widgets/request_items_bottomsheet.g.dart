// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_items_bottomsheet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getCartItemHash() => r'ed572035f9a5ff733d8dedf56aca4aba2b15ee3d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getCartItem].
@ProviderFor(getCartItem)
const getCartItemProvider = GetCartItemFamily();

/// See also [getCartItem].
class GetCartItemFamily extends Family<AsyncValue<List<CartModel>>> {
  /// See also [getCartItem].
  const GetCartItemFamily();

  /// See also [getCartItem].
  GetCartItemProvider call({
    required String requestId,
  }) {
    return GetCartItemProvider(
      requestId: requestId,
    );
  }

  @override
  GetCartItemProvider getProviderOverride(
    covariant GetCartItemProvider provider,
  ) {
    return call(
      requestId: provider.requestId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getCartItemProvider';
}

/// See also [getCartItem].
class GetCartItemProvider extends AutoDisposeFutureProvider<List<CartModel>> {
  /// See also [getCartItem].
  GetCartItemProvider({
    required String requestId,
  }) : this._internal(
          (ref) => getCartItem(
            ref as GetCartItemRef,
            requestId: requestId,
          ),
          from: getCartItemProvider,
          name: r'getCartItemProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getCartItemHash,
          dependencies: GetCartItemFamily._dependencies,
          allTransitiveDependencies:
              GetCartItemFamily._allTransitiveDependencies,
          requestId: requestId,
        );

  GetCartItemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.requestId,
  }) : super.internal();

  final String requestId;

  @override
  Override overrideWith(
    FutureOr<List<CartModel>> Function(GetCartItemRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCartItemProvider._internal(
        (ref) => create(ref as GetCartItemRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        requestId: requestId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CartModel>> createElement() {
    return _GetCartItemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCartItemProvider && other.requestId == requestId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, requestId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetCartItemRef on AutoDisposeFutureProviderRef<List<CartModel>> {
  /// The parameter `requestId` of this provider.
  String get requestId;
}

class _GetCartItemProviderElement
    extends AutoDisposeFutureProviderElement<List<CartModel>>
    with GetCartItemRef {
  _GetCartItemProviderElement(super.provider);

  @override
  String get requestId => (origin as GetCartItemProvider).requestId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
