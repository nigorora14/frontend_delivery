import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend_delivery/src/models/product.dart';
import 'package:frontend_delivery/src/utils/shared_pref.dart';

class ClientOrdersCreateController{
  BuildContext context;
  Function refresh;
  Product product;

  int counter = 1;
  double productPrice;

  SharedPref _sharedPref = new SharedPref();
  List<Product> selectedProducts= [];

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

    selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;
    refresh();
  }
}