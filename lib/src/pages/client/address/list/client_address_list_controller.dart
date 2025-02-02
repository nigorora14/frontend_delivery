import 'package:flutter/material.dart';
import 'package:frontend_delivery/src/models/address.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/provider/address_provider.dart';
import 'package:frontend_delivery/src/provider/orders_provider.dart';
import 'package:frontend_delivery/src/utils/shared_pref.dart';

class ClientAddressListController{
  BuildContext context;
  Function refresh;

  List<Address> address = [];
  AddressProvider _addressProvider = new AddressProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();

  int radioValue = 0;
  bool isCreated;

  Map<String, dynamic> dataIsCreated;

  OrdersProvider _ordersProvider = new OrdersProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _addressProvider.init(context, user);
    _ordersProvider.init(context, user);
    refresh();
    print('---> 4'); //BORRAR

  }
  void createOrder() async{
    /*Address a = Address.fromJson(await _sharedPref.read('address') ?? {});
    List<Product> selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;
    Order order= new Order(
      idClient: user.id,
      idAddress: a.id,
      products: selectedProducts
    );
    ResponseApi responseApi = await _ordersProvider.create(order);*/
    print('---> 2'); //BORRAR
    Navigator.pushNamed(context, 'client/payments/create');

    //refresh();
    //print('Orden: ${responseApi.message}');
  }
  void handleRadioValueChange(int value) async{
    radioValue = value;
    _sharedPref.save('address', address[value]);

    refresh();
    print('----> 1: $radioValue');
  }
  Future<List<Address>> getAddress() async {

    address = await _addressProvider.getByUser(user.id);
    Address a = Address.fromJson(await _sharedPref.read('address') ?? {});
    int index = address.indexWhere((ad) => ad.id == a.id);
    if(index != -1){
      radioValue = index;
    }else{
      if(address.isNotEmpty) {
        handleRadioValueChange(0);
      }
      //
    }

    print('--- > 3 INDICE ${index} user ${address.isNotEmpty} ${a.toJson()}');
    return address;
  }
  void goToNewAddress() async {
    var result = await Navigator.pushNamed(context, 'client/address/create');
    if(result != null){
      if(result){
        refresh();
      }
    }
  }
}