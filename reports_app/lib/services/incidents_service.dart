import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';
import 'package:reports_app/models/incidents.dart';
import 'package:reports_app/models/request_response.dart';
import 'package:reports_app/utils/base_url.dart';

class IncidentsService extends ChangeNotifier {
  List<Incident> _incidents = [];
  List<Incident> get incidents => _incidents;

  bool isLoading = false;

  void setIncidents(List<Incident> newIncidents) {
    _incidents = newIncidents;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<RequestResponseModel> fetchIncidents(
    String idToken,
    bool isAdmin, {
    int? userId,
  }) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };
    setIsLoading(true);
    final path = isAdmin ? 'api/incidents' : 'api/incidents/my';
    final query = (isAdmin && userId != null)
        ? {'userId': userId.toString()}
        : null;
    final url = Uri.http(baseUrl, path, query);
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

  Future<RequestResponseModel> resolveIncident(
    String idToken,
    int id,
    int status,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };

    setIsLoading(true);
    final url = Uri.http(baseUrl, 'api/incidents/$id/authorize');
    try {
      final resp = await http
          .post(url, headers: requestHeaders, body: json.encode(status))
          .timeout(const Duration(seconds: 10));
      Logger().i('resp body: ${resp.body}');
      if (resp.statusCode >= 500) {
        return RequestResponseModel(
          error: true,
          message:
              'Error del servidor ${resp.statusCode}. Favor de contactar al administrador.',
        );
      }
      final resolveRes = IncidentResolveRes.fromJson(resp.body);
      if (!resolveRes.success) {
        return RequestResponseModel(
          error: true,
          message: resolveRes.message ?? 'Fallo al resolver el incidente.',
        );
      }
      return RequestResponseModel(
        error: false,
        message: 'Incidente resuelto correctamente.',
      );
    } catch (e) {
      return RequestResponseModel(
        error: true,
        message: 'Ocurrió un error inesperado: $e',
      );
    } finally {
      setIsLoading(false);
    }
  }
}
