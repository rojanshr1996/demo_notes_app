import 'package:demo_app_bloc/bloc/authBloc/auth_event.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_state.dart';
import 'package:demo_app_bloc/services/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthServices authServices;

  AuthBloc({required this.authServices}) : super(UnAuthenticated()) {
    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignInRequested>((event, emit) async {
      emit(Loading());
      try {
        await authServices.signIn(email: event.email, password: event.password);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    // When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        await authServices.signUp(email: event.email, password: event.password);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      await authServices.signOut();
      emit(UnAuthenticated());
    });

    on<EmailVerificationRequested>((event, emit) async {
      emit(Loading());
      try {
        await authServices.sendEmailVerification();
        emit(EmailVerified());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
