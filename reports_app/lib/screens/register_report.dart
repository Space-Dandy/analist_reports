import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:reports_app/services/incidents_service.dart';
import 'package:reports_app/services/user_service.dart';
import 'package:reports_app/widgets/button_widget.dart';
import 'package:reports_app/widgets/glassmorphism_input.dart';
import 'package:reports_app/widgets/gradient_background.dart';

class RegisterReport extends StatefulWidget {
  const RegisterReport({super.key});

  @override
  State<RegisterReport> createState() => _RegisterReportState();
}

class _RegisterReportState extends State<RegisterReport> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  File? _imageFile;
  bool _submitting = false;

  Future<void> _pickImage() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (!context.mounted) return;
      Flushbar(
        title: 'Permiso denegado',
        message: 'No se pudo acceder a la cámara.',
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }
    final XFile? picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1600,
      maxHeight: 1200,
    );
    if (picked == null) return;
    setState(() => _imageFile = File(picked.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_titleCtrl.text.trim().isEmpty || _descCtrl.text.trim().isEmpty) {
      if (!context.mounted) return;
      Flushbar(
        title: 'Error',
        message: 'Llena todos los campos.',
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }

    if (_imageFile == null) {
      if (!context.mounted) return;
      Flushbar(
        title: 'Foto requerida',
        message: 'Toma una foto antes de enviar el reporte.',
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }
    final userSvc = Provider.of<UserService>(context, listen: false);
    final incidentsSvc = Provider.of<IncidentsService>(context, listen: false);

    if (userSvc.token == null) {
      Flushbar(
        title: 'Error',
        message: 'Por favor inicia sesión de nuevo.',
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }

    setState(() => _submitting = true);
    final res = await incidentsSvc.createIncident(
      userSvc.token!,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      status: 0,
      imageFilePath: _imageFile?.path,
    );
    setState(() => _submitting = false);

    if (!res.error && context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
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
          iconTheme: const IconThemeData(color: Colors.black87),
          title: const Text(
            'Registrar reporte',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 12),
                GlassmorphismInput(
                  controller: _titleCtrl,
                  labelText: 'Título',
                  hintText: 'Título del reporte',
                ),
                const SizedBox(height: 12),
                GlassmorphismInput(
                  controller: _descCtrl,
                  labelText: 'Descripción',
                  hintText: 'Describe lo ocurrido',
                  maxLines: 5,
                ),
                const SizedBox(height: 12),

                // image preview + capture
                if (_imageFile != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _imageFile!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  SizedBox(
                    height: 180,
                    child: Center(
                      child: Text(
                        'No image selected',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),

                ButtonWidget(
                  buttonText: const Text(
                    'Tomar foto',
                    style: TextStyle(color: Colors.white),
                  ),
                  handlePressed: _pickImage,
                  gradientColors: const [Color(0xFF6B4EFF), Color(0xFF78FFD6)],
                  fullWidth: true,
                  buttonHeight: 56,
                ),
                const SizedBox(height: 12),

                ButtonWidget(
                  buttonText: Text(
                    _submitting ? 'Enviando...' : 'Registrar reporte',
                    style: const TextStyle(color: Colors.white),
                  ),
                  handlePressed: _submitting ? null : _submit,
                  gradientColors: const [Color(0xFF00B09B), Color(0xFF96C93D)],
                  fullWidth: true,
                  buttonHeight: 56,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
