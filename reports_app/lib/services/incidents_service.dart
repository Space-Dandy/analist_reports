import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reports_app/models/incidents.dart';
import 'package:reports_app/models/request_response.dart';
import 'package:reports_app/utils/base_url.dart';

class IncidentsService extends ChangeNotifier {
  List<Incident> _incidents = [];
  List<Incident> get incidents => _incidents;

  Incident? _selectedIncident;
  Incident? get selectedIncident => _selectedIncident;

  bool isLoading = false;

  void setIncidents(List<Incident> newIncidents) {
    _incidents = newIncidents;
    notifyListeners();
  }

  void setSelectedIncident(Incident? incident) {
    _selectedIncident = incident;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<RequestResponseModel> fetchIncidents(
    String idToken,
    bool isAdmin,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };
    setIsLoading(true);
    final url = Uri.http(
      baseUrl,
      isAdmin ? 'api/incidents' : 'api/incidents/my',
    );
    try {
      final resp = await http
          .get(url, headers: requestHeaders)
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode >= 500) {
        return RequestResponseModel(
          error: true,
          message:
              'Error del servidor ${resp.statusCode}. Favor de contactar al administrador.',
        );
      }
      final incidentsRes = IncidentsRes.fromJson(resp.body);
      if (!incidentsRes.success) {
        return RequestResponseModel(
          error: true,
          message: incidentsRes.message ?? 'Fallo al obtener los incidentes.',
        );
      }
      setIncidents(incidentsRes.data);
      return RequestResponseModel(
        error: false,
        message: 'Incidentes obtenidos correctamente.',
      );
    } on Exception catch (e) {
      setIsLoading(false);
      return RequestResponseModel(
        error: true,
        message: 'Error de conexión. Favor de intentar más tarde. $e',
      );
    } finally {
      setIsLoading(false);
    }
  }
}
