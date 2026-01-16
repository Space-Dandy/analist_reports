import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/user_service.dart';
import '../widgets/button_widget.dart';
import '../widgets/glassmorphism_input.dart';
import '../widgets/gradient_background.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF6B4EFF)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
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
                    Icons.person_add_rounded,
                    size: 80,
                    color: Color(0xFF6B4EFF),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Crear Cuenta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B4EFF),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Nombre
                  GlassmorphismInput(
                    controller: _nameController,
                    labelText: 'Nombre',
                    hintText: 'Ingresa tu nombre completo',
                    prefixIcon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
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

                  // Edad
                  GlassmorphismInput(
                    controller: _ageController,
                    labelText: 'Edad',
                    hintText: 'Ingresa tu edad',
                    prefixIcon: Icons.calendar_today_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu edad';
                      }
                      final age = int.tryParse(value);
                      if (age == null) {
                        return 'Ingresa un número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
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
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirmar password
                  GlassmorphismInput(
                    controller: _confirmPasswordController,
                    labelText: 'Confirmar Contraseña',
                    hintText: 'Confirma tu contraseña',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF6B4EFF),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirma tu contraseña';
                      }
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Register Button
                  ButtonWidget(
                    buttonText: _isLoading
                        ? const Text('')
                        : const Text(
                            'Registrarse',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    icon: _isLoading
                        ? null
                        : const Icon(Icons.person_add_rounded),
                    handlePressed: _isLoading ? null : _handleSignup,
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

                  //Volver al Login
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text(
                      "¿Ya tienes una cuenta? Inicia sesión",
                      style: TextStyle(color: Color(0xFF6B4EFF)),
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

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userService = Provider.of<UserService>(context, listen: false);

      final response = await userService.createUser(
        _nameController.text.trim(),
        _emailController.text.trim(),
        int.parse(_ageController.text.trim()),
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        if (!response.error) {
          Navigator.pop(context);
        }
        await Flushbar(
          title: response.error ? 'Error' : 'Éxito',
          message: response.message,
          duration: const Duration(seconds: 3),
          backgroundColor: response.error ? Colors.redAccent : Colors.green,
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
      }
    }
  }
}
