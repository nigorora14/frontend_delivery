import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend_delivery/src/api/environment.dart';
import 'package:frontend_delivery/src/models/order.dart';
import 'package:frontend_delivery/src/models/response_api.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/provider/orders_provider.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';
import 'package:frontend_delivery/src/utils/my_snackbar.dart';
import 'package:frontend_delivery/src/utils/shared_pref.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ClientOrdersMapController{
  BuildContext context;
  Function refresh;
  Position _position;

  String addressName;
  LatLng addressLatLng;

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(-11.8859844,-77.0570906),
      zoom: 14
  );
  Completer<GoogleMapController> _mapController = Completer();
  BitmapDescriptor deliveryMarker;
  BitmapDescriptor homeMarker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Order order;
  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  OrdersProvider _ordersProvider = new OrdersProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();

  double _distanceBetween;
  IO.Socket socket;

  Future<void> setPolylines(LatLng from, LatLng to) async{
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS,
        pointFrom,
        pointTo
    );
    for(PointLatLng point in result.points){
      points.add(LatLng(point.latitude, point.longitude));
    }
    Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      color: MyColors.primaryColor,
      points: points,
      width: 6
    );
    polylines.add(polyline);
    refresh();
  }

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    order = Order.fromJson(ModalRoute.of(context).settings.arguments as Map<String, dynamic>);
    deliveryMarker = await createMarkerFromAsset('assets/img/delivery2.png');
    homeMarker = await createMarkerFromAsset('assets/img/home.png');

    socket = IO.io('http://${Environment.API_DELIVERY}/orders/delivery',<String, dynamic> {
      'transports': ['websocket'],
      'autoConnect': false
    });

    socket.connect();
    socket.on('position/${order.id}', (data) {
      print('DATA EMITIDA: ${data}');
      addMarker(
          'delivery',
          data['lat'],
          data['lng'],
          'Tu Repartidor',
          '',
          deliveryMarker
      );
    });

    user = User.fromJson(await _sharedPref.read('user'));
    _ordersProvider.init(context, user);

    print('order ${order.toJson()}');
    checkGPS();
  }
  void isCloseToDeliveryPosition(){
    _distanceBetween = Geolocator.distanceBetween(
        _position.latitude,
        _position.longitude,
        order.address.lat,
        order.address.lng
    );
    print('diatancia: ${_distanceBetween} -----------');
  }

  void addMarker(
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker){
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: content)
    );
    markers[id] = marker;
    refresh();
  }
  void selectRefPoint(){
    Map<String, dynamic> data = {
      'address' : addressName,
      'lat' : addressLatLng.latitude,
      'lng' : addressLatLng.longitude
    };
    Navigator.pop(context, data);
  }
  Future<BitmapDescriptor> createMarkerFromAsset(String path) async{
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(configuration, path);
    return descriptor;
  }
  Future<Null> setLocationDraggableInfo() async{
    if(initialPosition != null){
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat, lng);
      if(address != null){
        if(address.length > 0){
          String direction = address[0].thoroughfare;
          //String street = address[0].subThoroughfare;
          String distrito = address[0].locality;
          String department = address[0].administrativeArea;
          String country = address[0].country;
          //String num = address[0].subAdministrativeArea;
          String CategResidencial = address[0].subLocality;
          String numero = address[0].name;

          addressName = '$direction, $CategResidencial, $numero, $distrito, $department, $country';//, #$street,$num
          addressLatLng = new LatLng(lat, lng);

          refresh();
        }
      }
    }
  }
  void onMapCreated(GoogleMapController controller){
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#242f3e"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},{"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}]');
    _mapController.complete(controller);
  }
  void dispose(){
    socket?.disconnect();
  }
  void updateLocation() async {
    try{
      await _determinePosition();//obtiene la posicion actual y los permisos.

      animateCameraToPosition(order.lat,order.lng);
      addMarker(
          'delivery',
          order.lat,
          order.lng,
          'Tu Repartidor',
          '',
          deliveryMarker
      );

      addMarker(
          'home',
          order.address.lat,
          order.address.lng,
          'lugar de entrega',
          '',
          homeMarker
      );
      LatLng from = new LatLng(order.lat, order.lng);
      LatLng to = new LatLng(order.address.lat, order.address.lng);
      setPolylines(from, to);

      refresh();

    }catch(e){
      print('Error: $e');
    }
  }
  void call() {
    launch("tel://${order.client.phone}");
  }
  void checkGPS() async{
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if(isLocationEnabled){
      updateLocation();
    }
    else {
      bool locationGPS = await location.Location().requestService();
      if(locationGPS){
        updateLocation();
      }
    }
  }
  Future animateCameraToPosition(double lat, double lng) async{
    GoogleMapController controller = await _mapController.future;
    if(controller != null)
      {
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lng),
            zoom: 14,
            bearing: 0
            )
        ));
      }
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están desactivados.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Se niegan los permisos de ubicación');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación se niegan permanentemente, no podemos solicitar permisos.');
    }
    return await Geolocator.getCurrentPosition();
  }
}