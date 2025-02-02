import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend_delivery/src/models/address.dart';
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
      body: Stack(
        children: [
          Positioned(
            top: 0,
              child: _textSelectAddress()
          ),
          Container(
            margin: EdgeInsets.only(top: 50,left: 5),
              child: _listAddress()
          )
        ],
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
  Widget _noAddress() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 30),
            child: NoDataWidgets(
                text: 'No tienes ninguna direccion, agrega una nueva.')
        ),
        _buttonNewAddress()
      ],
    );
  }
  Widget _listAddress(){
    return FutureBuilder(
        future: _con.getAddress(),
        builder: (context, AsyncSnapshot<List<Address>> snapshot){

          if(snapshot.hasData){
            if(snapshot.data.length > 0){
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                  itemCount: snapshot.data?.length??0,
                  itemBuilder: (_, index){
                    return _radioSelectorAddress(snapshot.data[index],index);
                  }
              );
            }
            else
            {
              return _noAddress();
            }
          }
          else {
            return _noAddress();
          }

        }
    );
  }
  Widget _radioSelectorAddress(Address address, int index){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                value: index,
                groupValue: _con.radioValue,
                onChanged: _con.handleRadioValueChange,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address?.address ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    address?.neighborhood ?? '',
                    style: TextStyle(
                        fontSize: 12,
                    ),
                  )
                ],
              ),
            ],
          ),
          Divider(
            color: Colors.grey[400],
          )
        ],
      ),
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
        onPressed: _con.createOrder,
        child: Stack(
          children: [
            Align(
              child: Container(
                child: Text(
                  'PAGAR',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50,top: 0),
                height: 30,
                child: Icon(
                  Icons.payment,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            )
          ],
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            primary: MyColors.primaryColor
        )
      ),
    );
  }
  Widget _buttonNewAddress(){
    return Container(
      height: 40,
      alignment: Alignment.center,
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
