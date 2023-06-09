import 'package:firebase_auth/firebase_auth.dart';

import '../utils/request_status.dart';

class Qqq {
  const Qqq();
}

final undefined = {} as User;

class AuthState {
  RequestStatus requestStatus;
  String? token;
  bool? isGuest;
  User? user;
  String? error;

  AuthState({
    this.token,
    this.isGuest,
    this.user,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  @override
  String toString() {
    return 'Auth{token: $token, isGuest: $isGuest, status: $requestStatus, error: $error}, user: $user';
  }

  AuthState copyWith({
    bool? isGuest,
    String? token,
    User? user,
    RequestStatus? requestStatus,
    String? error,
    bool logout = false,
  }) {
    return AuthState(
      token: logout ? null : (token ?? this.token),
      isGuest: isGuest ?? this.isGuest,
      user: logout ? null : (user ?? this.user),
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }
}