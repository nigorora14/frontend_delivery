import 'package:frontend_delivery/src/models/response_api.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/provider/users_provider.dart';
import 'package:frontend_delivery/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';

class RegisterController {

  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController apellidoController = new TextEditingController();
  TextEditingController telefonoController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmarPasswordController = new TextEditingController();
  TextEditingController imageController = new TextEditingController();
  TextEditingController sessionTokenController = new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();

  Future init(BuildContext context) {
    this.context = context;
    usersProvider.init(context);
  }

  void register() async{
    String email= emailController.text.trim();
    String name= nameController.text.trim();
    String apellido= apellidoController.text.trim();
    String telefono= telefonoController.text.trim();
    String password= passwordController.text.trim();
    String confirmarPassword= confirmarPasswordController.text.trim();
    String image=imageController.text.trim();
    String sessionToken = sessionTokenController.text.trim();

    if(email.isEmpty || name.isEmpty || apellido.isEmpty || telefono.isEmpty || password.isEmpty || confirmarPassword.isEmpty){
      MySnackbar.show(context, 'Debes ingresar todos los campos.');
      return;
    }
    if(confirmarPassword != password){
      MySnackbar.show(context, 'La contraseña no coincide.');
      return;
    }
    if(password.length < 6){
      MySnackbar.show(context, 'La contraseña como minimo debe contener 6 digitos.');
      return;
    }

    User user= new User(
      email: email,
      name: name,
      lastname:apellido,
      phone: telefono,
      password: password,
      image: "FOTO FALTA",
      sessionToken:"TOKEN FALTA"
    );
    ResponseApi responseApi = await usersProvider.create(user);
    MySnackbar.show(context, responseApi.message);

    if(responseApi.success){
        Future.delayed(Duration(seconds: 3),() {
          Navigator.pushReplacementNamed(context, 'login');
        });
    }

    print('Respuesta: ${responseApi.toJson()}');
  }
  void back(){
    Navigator.pop(context);
  }
}