import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend_delivery/src/models/order.dart';
import 'package:frontend_delivery/src/models/product.dart';
import 'package:frontend_delivery/src/models/response_api.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/provider/orders_provider.dart';
import 'package:frontend_delivery/src/provider/push_notifications_provider.dart';
import 'package:frontend_delivery/src/provider/users_provider.dart';
import 'package:frontend_delivery/src/utils/shared_pref.dart';

class RestaurantOrdersDetailController{
  BuildContext context;
  Function refresh;
  Product product;

  int counter = 1;
  double productPrice;

  SharedPref _sharedPref = new SharedPref();
  double total=0;
  Order order;

  User user;
  List<User> users = [];
  UsersProvider _usersProvider = new UsersProvider();
  OrdersProvider _ordersProvider = new OrdersProvider();
  String idDelivery;
  PushNotificationsProvider pushNotificationsProvider= new PushNotificationsProvider();

  Future init(BuildContext context, Function refresh, Order order) async{
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    user = User.fromJson(await _sharedPref.read('user'));
    _usersProvider.init(context, sessionUser: user);
    _ordersProvider.init(context, user);
    getTotal();
    getUsers();
    refresh();
  }
  void sendNotification(String tokenDelivery){
    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    };
    pushNotificationsProvider.sendMessage(
        tokenDelivery,
        data,
        'PEDIDO ASIGNADO',
        'Te han asignado un pedido.'
    );
  }
  void updateOrder()async{
    if(idDelivery != null){
      order.idDelivery = idDelivery;
      ResponseApi responseApi = await _ordersProvider.updateToDispatched(order);
      User deliveryUser = await _usersProvider.getById(order.idDelivery);
      print('TOKEN DE NOTIFICACIONES DEL DELIVERY: ${deliveryUser.notificationToken}');
      sendNotification(deliveryUser.notificationToken);
      Fluttertoast.showToast(msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context, true);
    } else {
     Fluttertoast.showToast(msg: 'Selecciona el repartidor');
    }
  }
  void getUsers() async{
    users = await _usersProvider.getDeliveryMen();
    refresh();
  }
  void getTotal(){
    total=0;
    order.products.forEach((product) {
      total = total + (product.price * product.quantity);
    });
    refresh();
  }
}