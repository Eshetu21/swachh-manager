import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabadmanager/core/dependency_container.dart';
import 'package:kabadmanager/core/theme/app_pallete.dart';
import 'package:kabadmanager/features/auth/logic/auth_bloc.dart';
import 'package:kabadmanager/services/session_service.dart';
import 'package:kabadmanager/shared/circular_progress_indicator.dart';
import 'package:kabadmanager/shared/show_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SessionService _sessionService = sl<SessionService>();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    final isLoggedIn = await _sessionService.isLoggedIn();
    if (isLoggedIn && mounted) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final logoSize = isPortrait ? screenHeight * 0.2 : screenWidth * 0.2;
    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.02;
    final buttonHeight = screenHeight * 0.06;
    final betweenFieldsSpace = screenHeight * 0.02;

    final theme = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSucess) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else if (state is AuthFailure) {
            ShowSnackbar.show(context, state.error);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: logoSize,
                          child: Image.asset(
                            "assets/images/swachh-logo.jpg",
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          "Admin Login",
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: isPortrait
                                ? screenHeight * 0.035
                                : screenWidth * 0.035,
                          ),
                        ),
                        SizedBox(height: betweenFieldsSpace * 2),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: theme.iconTheme.color,
                            ),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: theme.hintColor,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                              horizontal: screenWidth * 0.03,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: theme.dividerColor,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: betweenFieldsSpace),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: theme.iconTheme.color,
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: theme.hintColor,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                              horizontal: screenWidth * 0.03,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: theme.dividerColor,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: screenWidth * 0.06,
                                color: theme.iconTheme.color,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: betweenFieldsSpace * 2),
                        SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<AuthBloc>(context).add(
                                        AuthLoginRequested(
                                          email: emailController.text.trim(),
                                          password: passwordController.text,
                                        ),
                                      );
                                    }
                                  },
                            child: state is AuthLoading
                                ? SizedBox(
                                    height: buttonHeight * 0.5,
                                    width: buttonHeight * 0.5,
                                    child: const AppLoader())
                                : Text(
                                    "Login",
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenHeight * 0.02,
                                        color: AppPallete.whiteColor),
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
        },
      ),
    );
  }
}

