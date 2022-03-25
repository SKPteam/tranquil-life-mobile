import 'package:http/http.dart';
import 'dart:convert';

class HttpClass{
  Future<Response?> httpPostRequest(Map<String, String>? headers, Map<String, dynamic>? body, Uri url) async{
    final response = await post(url,headers: headers, body: jsonEncode(body));
    return response;
  }

  Future<Response?> httpGetRequest(Map<String, String>? headers, Uri url) async{
    final response = await get(url, headers: headers,);
    return response;
  }

  Future<Response?> httpPatchRequest(Map<String, String>? headers, Map<String, dynamic>? body, Uri url) async{
    final response = await patch(url, headers: headers, body: jsonEncode(body));
    return response;
  }
}