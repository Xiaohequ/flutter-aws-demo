
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';

class JsonResult{
  bool success;
  String? message;

  JsonResult(this.success, this.message);

  static JsonResult fromJson(Map<String, dynamic> jsonDecode) {
    //return JsonResult(jsonDecode["success"], jsonDecode["message"]);
      return switch(jsonDecode){
        {'success': bool success, "message" : String? message} => JsonResult(success, message),
        _ => throw const FormatException('Failed to load JsonResult.'),
      };
  }

}