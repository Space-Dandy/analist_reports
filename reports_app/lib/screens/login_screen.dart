import 'package:flutter/material.dart';

import '../widgets/button_widget.dart';
import '../widgets/glassmorphism_input.dart';
import '../widgets/gradient_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    const Icon(
                      Icons.assessment_rounded,
                      size: 80,
                      color: Color(0xFF6B4EFF),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Reporte de Incidentes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B4EFF),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Email Field
                    GlassmorphismInput(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Ingresa tu correo',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa tu correo';
                        }
                        if (!value.contains('@')) {
                          return 'Favor de ingresar un correo válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    GlassmorphismInput(
                      controller: _passwordController,
                      labelText: 'Contraseña',
                      hintText: 'Ingresa tu contraseña',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF6B4EFF),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa tu contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Login Button
                    ButtonWidget(
                      buttonText: _isLoading
                          ? const Text('')
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      icon: _isLoading ? null : const Icon(Icons.login_rounded),
                      handlePressed: _isLoading ? null : _handleLogin,
                      disabled: _isLoading,
                      fullWidth: true,
                      buttonHeight: 56,
                      gradientColors: const [
                        Color(0xFF6B4EFF),
                        Color(0xFF9D7FFF),
                      ],
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      borderRadius: 12,
                    ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF6B4EFF),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Register Link
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "¿No tienes una cuenta? Regístrate",
                        style: TextStyle(color: Color(0xFF6B4EFF)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Implement login API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login functionality coming soon!')),
        );
      }
    }
  }
}
