import 'package:frontend_delivery/src/models/order.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/pages/restaurant/orders/detail/restaurant_orders_detail_page.dart';
import 'package:frontend_delivery/src/provider/orders_provider.dart';
import 'package:frontend_delivery/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RestaurantsOrdersListController{
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;

  User user;
  List<String> status = ['PAGADO','DESPACHADO','EN CAMINO','ENTREGADO'];
  OrdersProvider _ordersProvider= new OrdersProvider();

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _ordersProvider.init(context, user);
    refresh();
  }
  Future<List<Order>> getOrders(String status) async{
    return await _ordersProvider.getByStatus(status);
  }
  void openBottomSheet(Order order){
    showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => RestaurantOrdersDetailPage(order: order)
    );
  }
  void logout() {
    _sharedPref.logout(context, user.id);
  }
  void goToCategoryCreate(){
    Navigator.pushNamed(context, 'restaurant/categories/create');
  }
  void goToProductCreate(){
    Navigator.pushNamed(context, 'restaurant/products/create');
  }

  void openDrawer(){
    key.currentState.openDrawer();
  }
  void goToRoles(){
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}