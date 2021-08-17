import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend_delivery/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:frontend_delivery/src/pages/client/address/map/client_address_map_controller.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';
import 'package:frontend_delivery/src/widgets/no_data_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientAddressMapPage extends StatefulWidget {
  const ClientAddressMapPage({Key key}) : super(key: key);

  @override
  _ClientAddressMapPageState createState() => _ClientAddressMapPageState();
}

class _ClientAddressMapPageState extends State<ClientAddressMapPage> {
  @override

  ClientAddressMapController _con = new ClientAddressMapController();
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubica tu direccion en el mapa')
      ),
      body: Stack(
        children: [
          _googleMaps(),
          Container(
            alignment: Alignment.center,
            child: _iconMyLocation(),
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
            alignment: Alignment.topCenter,
            child: _cardAddress(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: _buttonAccept(),
          )
        ],
      ),
    );
  }
  Widget _cardAddress(){
    return Container(
      child: Card(
        color: Colors.grey[500],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
              _con.addressName??'',
            style: TextStyle(
              color:  Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
  Widget _iconMyLocation(){
    return Image.asset(
      'assets/img/my_ubicacion4.png',
      width: 55,
      height: 55,
    );
  }
  Widget _googleMaps(){
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position) {
        _con.initialPosition=position;
      },
      onCameraIdle: () async{
        await _con.setLocationDraggableInfo();
      },
    );
  }
  Widget _buttonAccept(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 70),
      child: ElevatedButton(
        onPressed: _con.selectRefPoint,
        child: Text(
            'SELECCIONAR ESTE PUNTO'
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            primary: MyColors.primaryColor
        ),
      ),
    );
  }

  void refresh(){
    setState(() {});
  }
}
