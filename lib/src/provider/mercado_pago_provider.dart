import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:frontend_delivery/src/api/environment.dart';
import 'package:frontend_delivery/src/models/mercado_pago_document_type.dart';
import 'package:frontend_delivery/src/models/user.dart';

class MercadoPagoProvider{
  String _urlMercadoPage = 'api.mercadopago.com';
  final _mercadoPagoCredentials = Environment.mercadoPagoCredentials;

  BuildContext context;
  User user;

  Future init (BuildContext context, User user){
    this.context = context;
    this.user = user;
  }
  Future<List<MercadoPagoDocumentType>> getIdentificationTypes() async{
    try{
      final url = Uri.https(_urlMercadoPage, '/v1/identification_types', {
        'access_token': _mercadoPagoCredentials.accessToken
      });
      final res = await http.get(url);
      final data = json.decode(res.body);
      final result = new MercadoPagoDocumentType.fromJsonList(data);

      return result.documentTypeList;

    }catch(e){
      print('ERROR: $e');
      return null;
    }
  }
  Future<http.Response> createCardToken({
  String cvv,
    String expirationYear,
    int expirationMonth,
    String cardNumber,
    String documentNumber,
    String documentId,
    String cardHolderName
  }) async {
    try{
      final url = Uri.https(_urlMercadoPage, '/v1/card_tokens', {
        'public_key': _mercadoPagoCredentials.publicKey
      });
      final body = {
        'security_code': cvv,
        'expiration_year': expirationYear,
        'expiration_month': expirationMonth,
        'card_number': cardNumber,
        'card_holder': {
          'identification': {
            'number': documentNumber,
            'type': documentId
            },
          'name': cardHolderName
        }
      };
      final res = await http.post(url, body: json.encode(body));
      return res;
    }catch(e){
      print('ERROR: $e');
      return null;
    }
  }
}