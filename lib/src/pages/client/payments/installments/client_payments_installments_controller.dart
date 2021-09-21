import 'package:flutter/material.dart';
import 'package:frontend_delivery/src/models/mercado_pago_card_token.dart';
import 'package:frontend_delivery/src/models/mercado_pago_installment.dart';
import 'package:frontend_delivery/src/models/mercado_pago_issuer.dart';
import 'package:frontend_delivery/src/models/mercado_pago_payment_method_installments.dart';
import 'package:frontend_delivery/src/models/product.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/provider/mercado_pago_provider.dart';
import 'package:frontend_delivery/src/utils/shared_pref.dart';

class ClientPaymentsInstallmentsController{
  BuildContext context;
  Function refresh;

  MercadoPagoProvider _mercadoPagoProvider = new MercadoPagoProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();

  MercadoPagoCardToken cardToken;
  List<Product> selectedProducts = [];
  double totalPayment = 0;

  MercadoPagoPaymentMethodInstallments installments;
  List<MercadoPagoInstallment> installmentsList = [];
  MercadoPagoIssuer issuer;

  String selectedInstallment;

  Future init(BuildContext context, Function refresh)async{
    this.context = context;
    this.refresh = refresh;

    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    cardToken = MercadoPagoCardToken.fromJsonMap(arguments);
    print('CARD TOKEN ARGUMENT: ${cardToken.toJson()}');

    selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;
    user = User.fromJson(await _sharedPref.read('user'));

    _mercadoPagoProvider.init(context, user);

    getTotalPayment();
    getInstallments();
  }
  void getInstallments() async {
    installments = await _mercadoPagoProvider.getInstallments(cardToken.firstSixDigits, totalPayment);
    installmentsList = installments.payerCosts;
    issuer = installments.issuer;

    print('InstallMENTS: ${installments.toJson()}');
    refresh();
  }
  void getTotalPayment(){
    selectedProducts.forEach((product) {
      //print('aqui...........${product.toJson()}');
      totalPayment = totalPayment + (product.quantity*product.price);
    });
    refresh();
  }
}