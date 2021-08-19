import 'package:flutter/material.dart';
import 'package:frontend_delivery/src/models/address.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/provider/address_provider.dart';
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
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));

    _addressProvider.init(context, user);
    refresh();
  }
  void handleRadioValueChange(int value) async{
    radioValue = value;
    _sharedPref.save('address', address[value]);
    Address a = Address.fromJson(await _sharedPref.read('address') ?? {});
    print(a.toJson());
    refresh();
    print('Valor seleccionado: $radioValue');
  }
  Future<List<Address>> getAddress() async {
    address = await _addressProvider.getByUser(user.id);
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