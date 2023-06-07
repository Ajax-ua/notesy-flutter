import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repos/repos.dart';
import '../../shared/models/models.dart' as models;
import '../user/user.dart';
import '../utils/request_status.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit._() : super(AuthState());
  static final AuthCubit _instance = AuthCubit._();
  factory AuthCubit() {
    return _instance;
  }

  final _authRepository = AuthRepository();
  FirebaseAuth fbAuth = FirebaseAuth.instance;
  StreamSubscription? subscription;

  emitError(error) {
    emit(state.copyWith(
      requestStatus: RequestStatus.failed,
      error: error.toString().replaceFirst('Exception: ', ''),
    ));
  }

  Future<void> setInitialState() async {
    final Completer<void> completer = Completer();
    subscription = fbAuth.idTokenChanges().listen((User? user) async {
      if (user == null) {
        emit(state.copyWith(
          isGuest: true,
          logout: true,
        ));
        if (!completer.isCompleted) {
          completer.complete();
        }
        return;
      }

      // add logged in user to user state
      final appUser = models.User(
        email: user.email ?? '',
        name: user.displayName ?? '',
        id: user.uid,
      );
      UserCubit().itemsLoadSuccess([appUser]);

      emit(state.copyWith(
        user: user,
        isGuest: false,
        token: await user.getIdToken(),
      ));
      
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    return completer.future;
  }

  @override
  Future<void> close() async {
    subscription?.cancel();
    super.close();
  }

  Future<void> signup({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(requestStatus: RequestStatus.inProgress));
      await _authRepository.signup(email: email, password: password);
      emit(state.copyWith(requestStatus: RequestStatus.succeed));
    } catch(error) {
      emitError(error);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(requestStatus: RequestStatus.inProgress));
      await _authRepository.login(email: email, password: password);
      emit(state.copyWith(requestStatus: RequestStatus.succeed));
    } catch(error) {
      emitError(error);
    }
  }

  Future<void> logout() async {
    try {
      emit(state.copyWith(requestStatus: RequestStatus.inProgress));
      await _authRepository.logout();
      emit(state.copyWith(requestStatus: RequestStatus.succeed));
    } catch(error) {
      emitError(error);
    }
  }

}