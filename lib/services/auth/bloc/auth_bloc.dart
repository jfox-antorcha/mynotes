import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        }
        if (user != null && !user.isEmailVerified) {
          emit(const AuthStateNeedsVerification());
        }
        emit(AuthStateLoggedIn(user!));
      },
    );
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(exception: null, isLoading: true));
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(email: email, password: password);
          emit(
            const AuthStateLoggedOut(exception: null, isLoading: false),
          );
          if (user.isEmailVerified) {
            emit(AuthStateLoggedIn(user));
          } else {
            emit(const AuthStateNeedsVerification());
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
    on<AuthEventShouldRegister>(
      (event, emit) async {
        emit(const AuthStateRegistering(null));
      },
    );
    on<AuthEventRegister>(
      (event, emit) async {
        final String email = event.email;
        final String password = event.password;
        try {
          await provider.createUser(email: email, password: password);
          emit(const AuthStateNeedsVerification());
        } on Exception catch (e) {
          emit(AuthStateRegistering(e));
        }
      },
    );
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        final user = provider.currentUser;
        if (user?.isEmailVerified == false) {
          await provider.sendEmailVerification();
        }
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      },
    );
  }
}
