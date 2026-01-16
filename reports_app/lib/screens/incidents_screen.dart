import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reports_app/models/incidents.dart';
import 'package:reports_app/models/request_response.dart';
import 'package:reports_app/screens/incident_details.dart';
import 'package:reports_app/services/incidents_service.dart';
import 'package:reports_app/services/user_service.dart';
import 'package:reports_app/widgets/gradient_background.dart';
import 'package:reports_app/widgets/incident_card.dart';

class IncidentsScreen extends StatefulWidget {
  const IncidentsScreen({super.key});

  @override
  State<IncidentsScreen> createState() => _IncidentsScreenState();
}

// ...existing code...
class _IncidentsScreenState extends State<IncidentsScreen> {
  bool _loading = false;
  String? _error;
  int? _selectedUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load({int? userId}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final userService = Provider.of<UserService>(context, listen: false);
    if (userService.token == null) {
      Navigator.pushReplacementNamed(context, '/login');
      Flushbar(
        title: 'Error',
        message: 'Por favor inicia sesión de nuevo.',
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }
    final service = Provider.of<IncidentsService>(context, listen: false);
    final RequestResponseModel res = await service.fetchIncidents(
      userService.token!,
      userService.isAdmin,
      userId: userId,
    );

    if (res.error) {
      setState(() => _error = res.message);
      if (mounted) {
        Flushbar(
          title: 'Error',
          message: res.message,
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    }

    if (userService.isAdmin) {
      await userService.getAllUsers(userService.token!);
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _refresh() async => await _load(userId: _selectedUserId);

  List<Map<String, dynamic>> _extractUsers(List<Incident> incidents) {
    final map = <int, String>{};
    for (final i in incidents) {
      map[i.userId] = i.userName;
    }
    return map.entries.map((e) => {'id': e.key, 'name': e.value}).toList();
  }

  void _applyFilter(int? userId) {
    setState(() => _selectedUserId = userId);
    _load(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<IncidentsService>(context);
    final List<Incident> incidents = service.incidents;

    return Consumer<UserService>(
      builder: (context, userService, child) {
        final isAdmin = userService.isAdmin;
        final userOptions = (userService.users.isNotEmpty)
            ? userService.users
                  .map((u) => {'id': u.id, 'name': u.name})
                  .toList()
            : _extractUsers(incidents);

        return GradientBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Reporte de Incidentes'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () {
                    userService.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),

            body: Column(
              children: [
                if (isAdmin)
                  SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1 + userOptions.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, idx) {
                          if (idx == 0) {
                            final selected = _selectedUserId == null;
                            return ChoiceChip(
                              label: const Text('Todos'),
                              selected: selected,
                              onSelected: (_) => _applyFilter(null),
                            );
                          }

                          final user = userOptions[idx - 1];
                          final int id = user['id'] as int;
                          final String name = user['name'] as String;
                          final bool selected = _selectedUserId == id;

                          return ChoiceChip(
                            label: Text(name),
                            selected: selected,
                            onSelected: (_) => _applyFilter(id),
                          );
                        },
                      ),
                    ),
                  ),

                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 200),
                              Center(
                                child: Text(
                                  _error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _refresh,
                          child: incidents.isEmpty
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: const [
                                    SizedBox(height: 200),
                                    Center(child: Text('No hay incidentes')),
                                  ],
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  itemCount: incidents.length,
                                  itemBuilder: (context, index) => IncidentCard(
                                    incident: incidents[index],
                                    onTap: () {
                                      final inc = incidents[index];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              IncidentDetails(incident: inc),
                                        ),
                                      ).then(
                                        (_) => _load(userId: _selectedUserId),
                                      );
                                    },
                                  ),
                                ),
                        ),
                ),
              ],
            ),

            floatingActionButton: userService.isAdmin
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/create-incident',
                      ).then((_) => _load(userId: _selectedUserId));
                    },
                    child: const Icon(Icons.add),
                  ),
          ),
        );
      },
    );
  }
}
// ...existing code...