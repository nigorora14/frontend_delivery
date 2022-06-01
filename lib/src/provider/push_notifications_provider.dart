import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/provider/users_provider.dart';
import 'package:http/http.dart' as http;

class PushNotificationsProvider{
  AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void initNotifications()async{
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
//Segundo plano
  void onMessageListener(){
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print('Nueva notificacion: $message');
      }
    });
///recibir las notificaciones en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      //para que me envia a una pagina
      /*Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));*/
    });
  }
  void saveToken(User user, BuildContext context) async{
    String token= await FirebaseMessaging.instance.getToken();
    UsersProvider usersProvider = new UsersProvider();
    usersProvider.init(context, sessionUser: user);
    usersProvider.updateNotificationToken(user.id, token);
  }
  Future<void> sendMessage(String to, Map<String, dynamic> data, String title, String body) async{
    Uri uri= Uri.https('fcm.googleapis.com', '/fcm/send');
    await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'AAAAApEEuP0:APA91bHNjBhBCoHpER6viMn_i31fSvZhElZAuOf3b6jxoVtcCIIWojgyiTnvHg5pss8EGMtpueCW04nM3FwLHMZw6EZvaRFkpu3X_ZnohWXhUdE2WWzFHkdaF8_hXrg6bEUP1bCftep2'
      },
      body: jsonEncode(
        <String,dynamic> {
          'notification': <String, dynamic>{
            'body': body,
            'title': title
          },
          'priority': 'high',
          'ttl':'4500s',
          'data': data,
          'to':to
        }
      )
    );
  }
  Future<void> sendMessageMultiple(List<String> toList, Map<String, dynamic> data, String title, String body) async{
    Uri uri= Uri.https('fcm.googleapis.com', '/fcm/send');
    await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAApEEuP0:APA91bHNjBhBCoHpER6viMn_i31fSvZhElZAuOf3b6jxoVtcCIIWojgyiTnvHg5pss8EGMtpueCW04nM3FwLHMZw6EZvaRFkpu3X_ZnohWXhUdE2WWzFHkdaF8_hXrg6bEUP1bCftep2'
        },
        body: jsonEncode(
            <String,dynamic> {
              'notification': <String, dynamic>{
                'body': body,
                'title': title
              },
              'priority': 'high',
              'ttl':'4500s',
              'data': data,
              'registration_ids': toList
            }
        )
    );
  }
}

