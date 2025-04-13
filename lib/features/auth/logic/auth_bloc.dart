import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabadmanager/features/auth/data/auth_repository.dart';

abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}

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
        final isAdmin = await authRepository.loginAndVerifyAdmin(
            event.email, event.password);
        if (isAdmin) {
          emit(AuthSucess(message: "Is Admin"));
        } else {
          emit(AuthFailure(error: "You are not an admin"));
        }
      } catch (e) {
        emit(AuthFailure(error: "Login failed: ${e.toString()}"));
      }
    });
  }
}

