import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabadmanager/core/error_handler/error_handler.dart';
import 'package:kabadmanager/features/auth/data/auth_repository.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}

class AuthLogout extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSucess extends AuthState {
  final String message;

  AuthSucess({required this.message});
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
  on<AuthLoginRequested>((event, emit) async {
  emit(AuthLoading());
  try {
    final (userId, isAdmin) = await authRepository.loginAndVerifyAdmin(
      event.email,
      event.password,
    );
    if (isAdmin) {
      OneSignal.login(userId);
      debugPrint(userId);
      emit(AuthSucess(message: "Is Admin"));
    } else {
      emit(AuthFailure(error: "You are not an admin"));
    }
  } catch (e) {
    final handled = errorHandler(e);
    emit(AuthFailure(error: handled.message));
  }
});


    on<AuthLogout>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.logOut();
        emit(AuthInitial());
      } catch (e) {
        final handled = errorHandler(e);
        emit(AuthFailure(error: handled.message));
      }
    });
  }
}

