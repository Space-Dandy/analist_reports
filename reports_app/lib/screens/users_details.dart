import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reports_app/models/user.dart';
import 'package:reports_app/services/user_service.dart';
import 'package:reports_app/widgets/gradient_background.dart';

class UsersDetails extends StatefulWidget {
  final int? id;
  final String name;

  const UsersDetails({super.key, this.id, required this.name});

  @override
  State<UsersDetails> createState() => _UsersDetailsState();
}

class _UsersDetailsState extends State<UsersDetails> {
  bool _loading = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    if (widget.id == null) return;
    final userSvc = Provider.of<UserService>(context, listen: false);

    User? cached;
    try {
      cached = userSvc.users.firstWhere((u) => u.id == widget.id);
    } catch (_) {
      cached = null;
    }
    if (cached != null) {
      setState(() => _user = cached);
      return;
    }

    setState(() => _loading = true);
    final res = await userSvc.getUserById(widget.id!);
    setState(() => _loading = false);

    if (res.error) {
      if (context.mounted) {
        Flushbar(
          title: 'Error',
          message: res.message,
          duration: const Duration(seconds: 3),
        ).show(context);
      }
      return;
    }

    try {
      final fetched = userSvc.users.firstWhere((u) => u.id == widget.id);
      setState(() => _user = fetched);
    } catch (_) {}
  }

  String _positionText(int? p) {
    if (p == null) return 'N/A';
    switch (p) {
      case 1:
        return 'Analista';
      default:
        return 'Usuario';
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _user?.name ?? widget.name;
    final email = _user?.email;
    final age = _user?.age;
    final position = _user?.position;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
          title: const Text('Usuario', style: TextStyle(color: Colors.black87)),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.grey.shade200,
                      child: const Icon(
                        Icons.person,
                        size: 44,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (email != null) ...[
                      const Text(
                        'Correo',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    const Text(
                      'Detalles',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.badge, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'ID: ${_user?.id ?? widget.id ?? '-'}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.cake_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Edad: ${age ?? '-'}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_user,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Rol: ${_positionText(position)}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_user == null)
                      const Text(
                        'Detalles completos no disponibles',
                        style: TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
