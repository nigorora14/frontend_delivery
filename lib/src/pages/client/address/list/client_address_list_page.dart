import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend_delivery/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';
import 'package:frontend_delivery/src/widgets/no_data_widget.dart';

class ClientAddressListPage extends StatefulWidget {
  const ClientAddressListPage({Key key}) : super(key: key);

  @override
  _ClientAddressListPageState createState() => _ClientAddressListPageState();
}

class _ClientAddressListPageState extends State<ClientAddressListPage> {
  @override

  ClientAddressListController _con = new ClientAddressListController();
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
        title: Text('Direcciones'),
        actions: [
          _iconAdd()
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            _textSelectAddress(),
            Container(
              margin: EdgeInsets.only(top: 30),
                child: NoDataWidgets(text: 'No tienes ninguna direccion, agrega una nueva.')
            ),
            _buttonNewAddress()
          ],
        ),
      ),
      bottomNavigationBar: _buttonAccept(),
    );
  }
  Widget _iconAdd(){
    return IconButton(
        onPressed: _con.goToNewAddress,
        icon: Icon(
          Icons.add,
          color: Colors.white,
        )
    );
  }
  Widget _textSelectAddress(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Text(
        'Elige donde recibir tus compras',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  Widget _buttonAccept(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: ElevatedButton(
        onPressed: (){},
        child: Text(
            'ACEPTAR'
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
  Widget _buttonNewAddress(){
    return Container(
      height: 40,
      child: ElevatedButton(
        onPressed: _con.goToNewAddress,
        child: Text(
          'Nueva direccion'
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue
        ),
      ),
    );
  }
  void refresh(){
    setState(() {});
  }
}
