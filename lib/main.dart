import 'package:frontend_delivery/src/pages/client/address/create/client_address_create_page.dart';
import 'package:frontend_delivery/src/pages/client/address/list/client_address_list_page.dart';
import 'package:frontend_delivery/src/pages/client/address/map/client_address_map_page.dart';
import 'package:frontend_delivery/src/pages/client/orders/create/client_orders_create_page.dart';
import 'package:frontend_delivery/src/pages/client/products/list/client_products_list_page.dart';
import 'package:frontend_delivery/src/pages/client/update/client_update_page.dart';
import 'package:frontend_delivery/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:frontend_delivery/src/pages/login/login_page.dart';
import 'package:frontend_delivery/src/pages/register/register_page.dart';
import 'package:frontend_delivery/src/pages/restaurant/categories/create/restaurant_categories_create_page.dart';
import 'package:frontend_delivery/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:frontend_delivery/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:frontend_delivery/src/pages/roles/roles_page.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);// Key? se cambio a Key

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery App Flutter',
      initialRoute: 'login',
      debugShowCheckedModeBanner: false,
      routes: {
       'login' : (BuildContext context) => LoginPage(),
       'register' :(BuildContext context) => RegisterPage(),
       'roles' :(BuildContext context) => RolesPage(),
       'client/products/list' :(BuildContext context) => ClientProductsListPage(),
       'client/update' :(BuildContext context) => ClientUpdatePage(),
       'client/orders/create' :(BuildContext context) => ClienteOrdersCreatePage(),
       'client/address/create' :(BuildContext context) => ClientAddressCreatePage(),
       'client/address/list' :(BuildContext context) => ClientAddressListPage(),
       'client/address/map' :(BuildContext context) => ClientAddressMapPage(),
       'restaurant/orders/list' :(BuildContext context) => RestaurantOrdersListPage(),
       'delivery/orders/list' :(BuildContext context) => DeliveryOrdersListPage(),
       'restaurant/categories/create': (BuildContext context) => RestaurantCategoriesCreatePage(),
       'restaurant/products/create': (BuildContext context) => RestaurantProductsCreatePage()
      },
      theme: ThemeData(
        //fontFamily: 'NimbusSans',
        primaryColor: MyColors.primaryColor,
        appBarTheme: AppBarTheme(elevation: 0)
      ),
    );
  }
}
