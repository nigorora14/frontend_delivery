//stf
import 'package:frontend_delivery/src/pages/register/register_controller.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);// Key? se cambio a Key

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  RegisterController _con= new RegisterController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
                top: -80,
                left: -80,
                child: _circleRegister()
            ),
            Positioned(
              child: _textRegister(),
              top: 60,
              left: 30,
            ),
            Positioned(
              child: _iconBack(),
              top: 45,
              left: -5,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top:150),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                  _ImageUser(),
                  SizedBox(height: 30),
                  _textFieldEmail(),
                  _textFieldName(),
                  _textFieldApellido(),
                  _textFieldTelefono(),
                  _textFieldPassword(),
                  _textFieldConfirmPassword(),
                  _buttonRegister(),
                ],
              ),
            )
            ),
          ],
        ),
      ),
    );
  }
  Widget _ImageUser(){
    return CircleAvatar(
      backgroundImage: AssetImage(
        'assets/img/user_profile_2.png'
      ),
      radius: 60,
      backgroundColor: Colors.grey[200],
    );
  }
  Widget _circleRegister(){
    return Container(
      width: 230,
      height: 230,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primaryColor
      ),
    );
  }
  Widget _iconBack(){
    return IconButton(
        onPressed: _con.back,
        icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white
        )
    );
  }
  Widget _textRegister(){
    return
        Text(
            'REGISTRO',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'NimbusSans'
            )
        );
  }
  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(15)
      ),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Correo Electronico',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDarck
            ),
            prefixIcon: Icon(
              Icons.email,
              color: MyColors.primaryColor,
            )
        ),
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
  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(15)
      ),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Contraseña',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDarck
            ),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }
  Widget _textFieldConfirmPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(15)
      ),
      child: TextField(
        controller: _con.confirmarPasswordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Confirmar Contraseña',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDarck
            ),
            prefixIcon: Icon(
              Icons.lock,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }
  Widget _buttonRegister(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.register,
        child: Text('INGRESAR'),
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
}
