import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend_delivery/src/api/environment.dart';
import 'package:frontend_delivery/src/models/order.dart';
import 'package:frontend_delivery/src/models/response_api.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/utils/shared_pref.dart';
import 'package:http/http.dart' as http;

class OrdersProvider {
  String _url = Environment.API_DELIVERY;
  String _api = '/api/order';
  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) async{
    this.context = context;
    this.sessionUser = sessionUser;
  }
  Future<List<Order>> getByStatus(String status) async{
    try{
      Uri url = Uri.http(_url, '$_api/findByStatus/$status');
      Map<String, String> headers = {
        'Content-type':'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res= await http.get(url, headers: headers);
      if(res.statusCode==401){
        Fluttertoast.showToast(msg: 'Session Expirada');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data= json.decode(res.body);//Categorias
      Order order= Order.fromJsonList(data);
      return order.toList;
    }
    catch(e){
      print('Error: $e');
      return[];
    }
  }
  Future<ResponseApi> create(Order order) async{
    try{
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams=json.encode(order);
      Map<String, String> headers = {
        'Content-type':'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res= await http.post(url, headers: headers, body: bodyParams);
      if(res.statusCode==401){
        Fluttertoast.showToast(msg: 'Session Expirada');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data= json.decode(res.body);

      ResponseApi responseApi= ResponseApi.fromJson(data);
      return responseApi;
    }
    catch(e){
      print(e);
      return null;
    }
  }
}