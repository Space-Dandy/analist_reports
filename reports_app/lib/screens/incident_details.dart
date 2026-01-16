import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reports_app/models/incidents.dart';
import 'package:reports_app/services/user_service.dart';
import 'package:reports_app/utils/base_url.dart';
import 'package:reports_app/utils/format_date.dart';
import 'package:reports_app/widgets/button_widget.dart';
import 'package:reports_app/widgets/gradient_background.dart';

class IncidentDetails extends StatelessWidget {
  final Incident? incident;
  const IncidentDetails({super.key, this.incident});

  String _statusText(int s) {
    switch (s) {
      case 1:
        return 'Aceptado';
      case 2:
        return 'Rechazado';
      default:
        return 'Pendiente';
    }
  }

  Color _statusColor(int s) {
    switch (s) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userSvc = Provider.of<UserService>(context, listen: false);
    final Incident? inc = incident;

    if (inc == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle del incidente')),
        body: const Center(
          child: Text(
            'No incident selected',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }

    final statusColor = _statusColor(inc.status);

    String? formattedResolution;
    if (inc.resolutionDate != null && inc.resolutionDate!.isNotEmpty) {
      formattedResolution = formatDate(inc.resolutionDate!);
    }

    const captionStyle = TextStyle(color: Colors.grey, fontSize: 12);
    const headingStyle = TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );
    const bodyStyle = TextStyle(color: Colors.black87, fontSize: 16);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Detalle del incidente')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (inc.imagePath.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    Uri.http(baseUrl, inc.imagePath).toString(),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              const Text('Folio', style: captionStyle),
              Text(inc.folioNumber, style: headingStyle),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Estado del Reporte: ', style: captionStyle),
                  const SizedBox(width: 8),
                  Text(
                    _statusText(inc.status),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    formatDate(inc.dateReported),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Título', style: captionStyle),
              Text(inc.title, style: bodyStyle),
              const SizedBox(height: 12),
              const Text('Descripción', style: captionStyle),
              Text(inc.description, style: bodyStyle),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text('Usuario que reportó', style: captionStyle),
              Text(inc.userName, style: bodyStyle),
              const SizedBox(height: 8),
              if (inc.authUserName != null && inc.authUserName!.isNotEmpty) ...[
                const Text('Autorizado por', style: captionStyle),
                Text(inc.authUserName!, style: bodyStyle),
                const SizedBox(height: 8),
              ],
              if (formattedResolution != null) ...[
                const Text('Resolution date', style: captionStyle),
                Text(formattedResolution, style: bodyStyle),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 20),
              if (userSvc.isAdmin) ...[
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        buttonText: Text(
                          'Aprobar',
                          style: TextStyle(color: Colors.green[700]),
                        ),
                        handlePressed: () {},
                        gradientColors: [
                          Colors.white,
                          const Color.fromARGB(255, 213, 255, 235),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ButtonWidget(
                        buttonText: Text(
                          'Rechazar',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                        handlePressed: () {},
                        gradientColors: [
                          Colors.white,
                          const Color.fromARGB(255, 255, 207, 207),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
