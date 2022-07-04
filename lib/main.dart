import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:frontend_delivery/src/provider/push_notifications_provider.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';
import 'package:flutter/material.dart';

import 'src/pages/pages.dart';

PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  pushNotificationsProvider.initNotifications();
  runApp(MyApp());
}
class MyApp extends StatefulWidget {

  const MyApp({Key key}) : super(key: key);// Key? se cambio a Key
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pushNotificationsProvider.onMessageListener();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery App Flutter',
      initialRoute: 'login',
      debugShowCheckedModeBanner: false,
      routes: {
       'login' : ( _ ) => LoginPage(),
       'register' :( _ ) => RegisterPage(),
       'roles' :( _ ) => RolesPage(),
       'client/products/list' :( _ ) => ClientProductsListPage(),
       'client/update' :( _ ) => ClientUpdatePage(),
       'client/orders/create' :( _ ) => ClienteOrdersCreatePage(),
       'client/address/create' :( _ ) => ClientAddressCreatePage(),
       'client/payments/create' :( _ ) => ClientPaymentsCreatePage(),
       'client/payments/installments' :( _ ) => ClientPaymentsInstallmentsPage(),
       'client/payments/status' :( _ ) => ClientPaymentsStatusPage(),
       'client/address/list' :( _ ) => ClientAddressListPage(),
       'client/orders/list' :( _ ) => ClientOrdersListPage(),
       'client/orders/map' :( _ ) => ClientOrdersMapPage(),
       'client/address/map' :( _ ) => ClientAddressMapPage(),
       'restaurant/orders/list' :( _ ) => RestaurantOrdersListPage(),
       'delivery/orders/list' :( _ ) => DeliveryOrdersListPage(),
       'restaurant/categories/create': ( _ ) => RestaurantCategoriesCreatePage(),
       'restaurant/products/create': ( _ ) => RestaurantProductsCreatePage(),
        'delivery/orders/map' : ( _ ) => DeliveryOrdersMapPage()
      },
      theme: ThemeData(
        //fontFamily: 'NimbusSans',
        primaryColor: MyColors.primaryColor,
        appBarTheme: AppBarTheme(elevation: 0)
      ),
    );
  }
}
