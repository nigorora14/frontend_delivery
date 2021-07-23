//stf
import 'package:frontend_delivery/src/pages/client/update/client_update_controller.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientUpdatePage extends StatefulWidget {
  const ClientUpdatePage({Key key}) : super(key: key);// Key? se cambio a Key

  @override
  _ClientUpdatePageState createState() => _ClientUpdatePageState();
}

class _ClientUpdatePageState extends State<ClientUpdatePage> {

  ClientUpdateController _con= new ClientUpdateController();

  @override
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
        title: Text('Editar Perfil'),
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              _imageUser(),
              SizedBox(height: 30),
              _textFieldName(),
              _textFieldApellido(),
              _textFieldTelefono(),
            ],
          ),
        )
      ),
      bottomNavigationBar: _buttonUpdate(),
    );
  }
  Widget _imageUser(){
    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: CircleAvatar(
        backgroundImage: _con.imageFile != null
            ? FileImage(_con.imageFile)
            : _con.user?.image != null 
              ? NetworkImage(_con.user?.image)
              : AssetImage('assets/img/user_profile_2.png'),
        radius: 60,
        backgroundColor: Colors.grey[200],
      ),
    );
  }
  Widget _textFieldName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(15)
      ),
      child: TextField(
        controller: _con.nameController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            hintText: 'Nombre',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDarck
            ),
            prefixIcon: Icon(
              Icons.person_outline,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }
  Widget _textFieldApellido(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(15)
      ),
      child: TextField(
        controller: _con.apellidoController,
        decoration: InputDecoration(
            hintText: 'Apellido',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDarck
            ),
            prefixIcon: Icon(
              Icons.person,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }
  Widget _textFieldTelefono(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(15)
      ),
      child: TextField(
        controller: _con.telefonoController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Telefono',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDarck
            ),
            prefixIcon: Icon(
              Icons.phone,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }

  Widget _buttonUpdate(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.isEnable ? _con.update : null,
        child: _con.isEnable? Text('ACTUALIZAR PERFIL') : Text('ACTUALIZANDO...'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            padding: EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }
  void refresh(){
    setState(() {});
  }
}
