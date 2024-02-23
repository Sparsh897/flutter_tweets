import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tweet/app.dart';
import 'package:flutter_tweet/features/auth/models/user_model.dart';
import 'package:flutter_tweet/features/auth/repos/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

enum AuthType { login, register }

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthenticationEvent>(authenticationEvent);
  }

  FutureOr<void> authenticationEvent(
      AuthenticationEvent event, Emitter<AuthState> emit) async {
    UserCredential? credential;

    switch (event.authtype) {
      case AuthType.login:
        try {
          credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: event.email, password: event.password);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
            emit(AuthErrorState(error: 'No user found for that email.'));
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
            emit(AuthErrorState(
                error: 'Wrong password provided for that user.'));
          }
        }
        break;
      case AuthType.register:
        try {
          credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
            emit(AuthErrorState(error: "The password provided is too weak"));
          } else if (e.code == 'email-already-in-use') {
            print('The account already exists for that email.');
            emit(AuthErrorState(
                error: 'The account already exists for that email.'));
          }
        } catch (e) {
          print(e.toString());
        }
        break;
    }
    if (credential != null) {
      if (event.authtype == AuthType.login) {
        UserModel? userModel =
            await Authrepo.getuserRepo(credential.user?.uid ?? "");
        if (userModel != null) {
          DecidePage.authStream.add(credential.user?.uid ?? "");
          emit(AuthSuccesState());
        }
      } else if (event.authtype == AuthType.register) {
        bool success = await Authrepo.createUserRepo(UserModel(
            createdAt: DateTime.now(),
            email: event.email,
            firstName: "Sparsh",
            lastName: "Chauhan",
            tweets: [],
            uid: credential.user?.uid ?? ""));
        if (success) {
          DecidePage.authStream.add(credential.user?.uid ?? "");
          emit(AuthSuccesState());
        }
      }
    }
  }
}
