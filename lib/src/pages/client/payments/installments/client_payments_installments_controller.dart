import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:frontend_delivery/src/models/mercado_pago_card_token.dart';
import 'package:frontend_delivery/src/models/mercado_pago_document_type.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/provider/mercado_pago_provider.dart';
import 'package:frontend_delivery/src/utils/my_snackbar.dart';
import 'package:frontend_delivery/src/utils/shared_pref.dart';
import 'package:http/http.dart';

class ClientPaymentsInstallmentsController{
  BuildContext context;
  Function refresh;
  GlobalKey<FormState> keyForm = new GlobalKey();

  TextEditingController documentNumberController = new TextEditingController();

  String cardNumber='';
  String expiryDate='';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  List<MercadoPagoDocumentType> documentTypeList = [];
  MercadoPagoProvider _mercadoPagoProvider = new MercadoPagoProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();

  String typeDocument = 'DNI';
  String expirationYear;
  int expirationMonth;
  MercadoPagoCardToken cardToken;

  Future init(BuildContext context, Function refresh)async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));

    _mercadoPagoProvider.init(context, user);
    getIdentificationTypes();
  }
  void getIdentificationTypes() async {
    documentTypeList = await _mercadoPagoProvider.getIdentificationTypes();
    documentTypeList.forEach((document) {
      print('Documento: ${document.toJson()}');
    });
    refresh();
  }
  void onCreditCardModelChange(CreditCardModel creditCardModel){
    cardNumber = creditCardModel.cardNumber;
    expiryDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;
    refresh();
  }
  void createCardToken()async{
    String documentNumber = documentNumberController.text;

    if(cardNumber.isEmpty){
      MySnackbar.show(context, 'Ingresa el numero de la tarjeta');
      return;
    }
    if(expiryDate.isEmpty){
      MySnackbar.show(context, 'Ingresa la fecha de expiracion');
      return;
    }
    if(cvvCode.isEmpty){
      MySnackbar.show(context, 'Ingresa el codigo de seguridad');
      return;
    }
    if(cardHolderName.isEmpty){
      MySnackbar.show(context, 'Ingresa el titular de la tarjeta');
      return;
    }
    if(documentNumber.isEmpty){
      MySnackbar.show(context, 'Ingresa el numero del documento');
      return;
    }
    if(expiryDate != null){
      List<String> list = expiryDate.split('/');
      if(list.length==2){
        expirationMonth = int.parse(list[0]);
        expirationYear = '20${list[1]}';
      }else{
        MySnackbar.show(context, 'Inserta el mes y el año de expiracion');
      }
    }
    if(cardNumber != null){
      cardNumber = cardNumber.replaceAll(RegExp(' '),'');
    }
    print('cvv: ${cvvCode}');
    print('cardNumber: ${cardNumber}');
    print('cardHolderName: ${cardHolderName}');
    print('documentId: ${typeDocument}');
    print('documentNumber: ${documentNumber}');
    print('expirationYear: ${expirationYear}');
    print('expirationMonth: ${expirationMonth}');

    Response response = await _mercadoPagoProvider.createCardToken(
      cvv: cvvCode,
      cardNumber: cardNumber,
      cardHolderName: cardHolderName,
      documentId: typeDocument,
      documentNumber: documentNumber,
      expirationYear: expirationYear,
      expirationMonth: expirationMonth
    );
    if(response != null){
      final data = json.decode(response.body);
      if(response.statusCode == 201){
        cardToken = new MercadoPagoCardToken.fromJsonMap(data);
        print('CARD TOKEN: ${cardToken.toJson()}');
      }
      else{
        print('Hubo un error al generar token');
        int status = int.tryParse(data['cause'][0]['code']??data['status']);
        String message = data['mensaje']??'Error al registrar la tarjeta';
        MySnackbar.show(context, 'Status code $status - $message');
      }
    }
  }
}