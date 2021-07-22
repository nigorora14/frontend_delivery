import 'package:frontend_delivery/src/models/response_api.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/provider/users_provider.dart';
import 'package:frontend_delivery/src/utils/my_snackbar.dart';
import 'package:frontend_delivery/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class LoginController {

  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  UsersProvider usersProvider= new UsersProvider();
  SharedPref _sharedPref= new SharedPref();

  Future init(BuildContext context) async{
    this.context = context;
    await usersProvider.init(context);

    User user = User.fromJson(await _sharedPref.read('user') ?? {});

    if(user?.sessionToken != null){
      if(user.roles.length > 1){
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      }else{
        Navigator.pushNamedAndRemoveUntil(context, user.roles[0].route, (route) => false);
      }
    }
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context, 'register');
  }

  void login() async{
    String email= emailController.text.trim();
    String password= passwordController.text.trim();
    ResponseApi responseApi = await usersProvider.login(email, password);
    if(responseApi.success){
      User user = User.fromJson(responseApi.data);
      _sharedPref.save('user', user.toJson());

      print(user.toJson());
      if(user.roles.length > 1){
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      }else{
        Navigator.pushNamedAndRemoveUntil(context, user.roles[0].route, (route) => false);
      }
    }else{
      MySnackbar.show(context, responseApi.message);
    }
    MySnackbar.show(context, responseApi.message);
  }
}