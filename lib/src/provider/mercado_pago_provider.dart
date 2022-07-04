import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend_delivery/src/models/mercado_pago_payment_method_installments.dart';
import 'package:frontend_delivery/src/models/order.dart';
import 'package:frontend_delivery/src/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:frontend_delivery/src/api/environment.dart';
import 'package:frontend_delivery/src/models/mercado_pago_document_type.dart';
import 'package:frontend_delivery/src/models/user.dart';

class MercadoPagoProvider{
  String _urlMercadoPage = 'api.mercadopago.com';
  String _url = Environment.API_DELIVERY;
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
  Future<http.Response> createPayment({
    @required String cardId,
    @required double transactionAmount,
    @required int installments,
    @required String paymentMethodId,
    @required String paymentTypeId,
    @required String issuerId,
    @required String emailCustomer,
    @required String cardToken,
    @required String identificationType,
    @required String identificationNumber,
    @required Order order,
  }) async{
    try{
      final url = Uri.http(_url, '/api/payments/createPay', {
        'public_key': _mercadoPagoCredentials.publicKey
      });
      Map<String, dynamic> body = {
        'order': order,
        'card_id':cardId,
        'description': 'frontend delivery',
        'transaction_amount': transactionAmount,
        'installments': installments,
        'payment_method_id': paymentMethodId,
        'payment_type_id': paymentTypeId,
        'token': cardToken,
        'issuer_id': issuerId,
        'payer': {
          'email': emailCustomer,
          'identification': {
            'type': identificationType,
            'number': identificationNumber
          }
        }
      };
      print('params---->: ${body}');
      String bodyParams = json.encode(body);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': user.sessionToken
      };
      final res = await http.post(url, headers: headers, body: bodyParams);
      if(res.statusCode==401){
        Fluttertoast.showToast(msg: 'Session Expirada');
        new SharedPref().logout(context, user.id);
      }
      return res;
    }catch(e){
      print('Error: $e');
      return null;
    }
  }
  Future<MercadoPagoPaymentMethodInstallments> getInstallments(String bin, double amount) async{
    try{
      final url = Uri.https(_urlMercadoPage, '/v1/payment_methods/installments', {
        'access_token': _mercadoPagoCredentials.accessToken,
        'bin': bin,
        'amount': '${amount}'
      });
      final res = await http.get(url);
      final data = json.decode(res.body);
      final result = new MercadoPagoPaymentMethodInstallments.fromJsonList(data);

      return result.installmentList.first;

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
        'cardholder': {
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