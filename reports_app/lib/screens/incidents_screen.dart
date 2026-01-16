import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reports_app/models/incidents.dart';
import 'package:reports_app/models/request_response.dart';
import 'package:reports_app/services/incidents_service.dart';
import 'package:reports_app/services/user_service.dart';
import 'package:reports_app/widgets/gradient_background.dart';
import 'package:reports_app/widgets/incident_card.dart';

class IncidentsScreen extends StatefulWidget {
  const IncidentsScreen({super.key});

  @override
  State<IncidentsScreen> createState() => _IncidentsScreenState();
}

class _IncidentsScreenState extends State<IncidentsScreen> {
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
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

    setState(() {
      _loading = false;
    });
  }

  Future<void> _refresh() async => await _load();

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<IncidentsService>(context);
    final List<Incident> incidents = service.incidents;

    return Consumer<UserService>(
      builder: (context, userService, child) {
        return GradientBackground(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Incidentes'),
              actions: [
                IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
              ],
            ),
            body: _loading
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
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 200),
                              Center(child: Text('No hay incidentes')),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            itemCount: incidents.length,
                            itemBuilder: (context, index) =>
                                IncidentCard(incident: incidents[index]),
                          ),
                  ),
            floatingActionButton: userService.isAdmin
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/create-incident',
                      ).then((_) => _load());
                    },
                    child: const Icon(Icons.add),
                  ),
          ),
        );
      },
    );
  }
}
