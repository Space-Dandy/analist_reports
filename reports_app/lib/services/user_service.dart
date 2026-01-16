import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reports_app/models/auth_res.dart';
import 'package:reports_app/models/auth_user.dart';
import 'package:reports_app/models/request_response.dart';
import 'package:reports_app/models/user.dart';
import 'package:reports_app/utils/base_url.dart';

class UserService extends ChangeNotifier {
  AuthUser? _currentUser;
  AuthUser? get currentUser => _currentUser;
  String? get token => _currentUser?.token;
  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;
  bool isLoading = false;

  List<User> _users = [];
  List<User> get users => _users;

  void setCurrentUser(AuthUser? user) {
    _currentUser = user;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setIsAdmin(bool value) {
    _isAdmin = value;
    notifyListeners();
  }

  void logout() {
    setCurrentUser(null);
  }

  void setUsers(List<User> newUsers) {
    _users = newUsers;
    notifyListeners();
  }

  Future<RequestResponseModel> loginUser(String email, String password) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    Map<String, String> requestBody = {'email': email, 'password': password};

    final url = Uri.http(baseUrl, 'api/users/login');
    setIsLoading(true);
    try {
      final resp = await http
          .post(url, headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode >= 500) {
        return RequestResponseModel(
          error: true,
          message:
              'Error del servidor ${resp.statusCode}. Favor de contactar al administrador.',
        );
      }
      final authResData = AuthResData.fromJson(resp.body);
      if (!authResData.success) {
        return RequestResponseModel(
          error: true,
          message: authResData.message ?? 'Fallo en el inicio de sesión.',
        );
      }
      final authRes = authResData.authRes!;
      final authUser = AuthUser.fromUserAndToken(authRes.user, authRes.token);
      setCurrentUser(authUser);
      setIsAdmin(authRes.user.position == 1);
      return RequestResponseModel(
        error: false,
        message: '¡Bienvenido ${authUser.name}!',
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

  Future<RequestResponseModel> createUser(
    String name,
    String email,
    int age,
    String password,
  ) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    Map<String, dynamic> requestBody = {
      'name': name,
      'email': email,
      'age': age,
      'password': password,
      'position': 0,
    };

    final url = Uri.http(baseUrl, 'api/users');
    setIsLoading(true);
    try {
      final resp = await http
          .post(url, headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode >= 500) {
        return RequestResponseModel(
          error: true,
          message:
              'Error del servidor ${resp.statusCode}. Favor de contactar al administrador.',
        );
      }
      final createUserRes = CreateUserRes.fromJson(resp.body);
      if (!createUserRes.success) {
        return RequestResponseModel(
          error: true,
          message: createUserRes.message ?? 'Fallo en la creación del usuario.',
        );
      }
      return RequestResponseModel(
        error: false,
        message: '¡Usuario creado exitosamente!',
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

  Future<RequestResponseModel> getUserById(int id) async {
    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    setIsLoading(true);
    final url = Uri.http(baseUrl, 'api/users/$id');
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

      final userRes = CreateUserRes.fromJson(resp.body);
      if (!userRes.success) {
        return RequestResponseModel(
          error: true,
          message: userRes.message ?? 'Fallo al obtener el usuario.',
        );
      }

      final fetched = userRes.data;
      if (fetched != null) {
        final idx = _users.indexWhere((u) => u.id == fetched.id);
        if (idx >= 0) {
          _users[idx] = fetched;
        } else {
          _users.add(fetched);
        }
        notifyListeners();
      }

      return RequestResponseModel(
        error: false,
        message: 'Usuario obtenido correctamente.',
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

  Future<RequestResponseModel> getAllUsers(String idToken) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };
    setIsLoading(true);
    final url = Uri.http(baseUrl, 'api/users');
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
      final usersRes = UsersRes.fromJson(resp.body);
      if (!usersRes.success) {
        return RequestResponseModel(
          error: true,
          message: usersRes.message ?? 'Fallo al obtener los usuarios.',
        );
      }
      setUsers(usersRes.data!);
      return RequestResponseModel(
        error: false,
        message: 'Usuarios obtenidos correctamente.',
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
