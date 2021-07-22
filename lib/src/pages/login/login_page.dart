import 'package:frontend_delivery/src/pages/login/login_controller.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key); // Key? se cambio a Key

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  LoginController _con = new LoginController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('1');
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
      print('3');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('2');
    //se ejecuta cada vez que se actualiza
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
                top: -80,
                left: -80,
                child: _circleLogin()
            ),
            Positioned(
                child: _textLogin(),
              top: 60,
              left: 40,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top:150),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _lottieAnimation(),
                    _textFieldEmail(),
                    _textFieldPassword(),
                    _buttonLogin(),
                    _textDontHaveAccount(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _lottieAnimation() {
    return Container(
      margin: EdgeInsets.only(
          top: 25,
          bottom: MediaQuery.of(context).size.height*0.005
      ),
      child: Lottie.asset(
          'assets/json/delivery7.json',
          width: 300,
          height: 300,
          fit: BoxFit.fill
      ),
    );
  }
  Widget _textLogin(){
    return Text(
        'LOGIN',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'NimbusSans'
        )
    );
  }
  Widget _circleLogin(){
    return Container(
      width: 230,
      height: 230,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primaryColor
      ),
    );
  }
  Widget _textDontHaveAccount(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            '¿No tienes cuenta?',
            style: TextStyle(
                color: MyColors.primaryColor
            )
        ),
        SizedBox(width: 7),
        GestureDetector(
          onTap: _con.goToRegisterPage,
          child: Text(
            'Registrate',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MyColors.primaryColor
            ),
          ),
        )
      ],
    );
  }
  Widget _buttonLogin(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.login,
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
  Widget _imageBanner(){
    return Container(
      margin: EdgeInsets.only(
          top: 150,
          bottom: 70//MediaQuery.of(context).size.height*0.25
      ),
      child: Image.asset(
        'assets/img/Login.png',
        width: 250,
        height: 250,
      ),
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
              Icons.lock,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }
}


