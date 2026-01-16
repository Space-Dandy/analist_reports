import 'package:flutter/material.dart';

class RequestResponseModel extends ChangeNotifier {
  bool error;
  String message;

  RequestResponseModel({this.error = false, required this.message});
}
