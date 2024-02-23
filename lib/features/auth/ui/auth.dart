import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tweet/features/auth/bloc/auth_bloc.dart';

//final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  var _isLogin = true;
  TextEditingController _enterdEmail = TextEditingController();
   TextEditingController _enterdPassword = TextEditingController();
    TextEditingController _enterdUsername = TextEditingController();

  AuthBloc authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Form(
          key: _form,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: BlocConsumer<AuthBloc, AuthState>(
                          bloc: authBloc,
                          listenWhen: (previous, current) =>
                              current is AuthActionState,
                          buildWhen: (previous, current) =>
                              current is! AuthActionState,
                          listener: (context, state) {
                            if (state is AuthErrorState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.error)));
                            } else if (state is AuthSuccesState) {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            }
                          },
                          builder: (context, state) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!_isLogin)
                                  TextFormField(
                                    controller: _enterdUsername,
                                    decoration: const InputDecoration(
                                        labelText: 'Username'),
                                    enableSuggestions: false,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value.trim().length < 4) {
                                        return 'Please enter at least 4 characters.';
                                      }
                                      return null;
                                    },
                                   
                                  ),
                                TextFormField(
                                  controller: _enterdEmail,
                                  decoration: const InputDecoration(
                                      labelText: 'Email Address'),
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty ||
                                        !value.contains('@')) {
                                      return 'Please enter a valid email address.';
                                    }
                            
                                    return null;
                                  },
                                  
                                ),
                                TextFormField(
                                  controller: _enterdPassword,
                                  decoration: const InputDecoration(
                                      labelText: 'Password'),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().length < 6) {
                                      return 'Password must be at least 6 characters long.';
                                    }
                                    return null;
                                  },
                                 
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    authBloc.add(AuthenticationEvent(
                                        authtype: _isLogin
                                            ? AuthType.login
                                            : AuthType.register,
                                        email: _enterdEmail.text.trim(),
                                        password: _enterdPassword.text.trim()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                  child: Text(_isLogin ? 'Login' : 'Signup'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Text(_isLogin
                                      ? 'Create an account'
                                      : 'I already have an account'),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
