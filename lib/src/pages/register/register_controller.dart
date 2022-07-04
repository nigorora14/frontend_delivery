import 'dart:convert';
import 'dart:io';
import 'package:frontend_delivery/src/models/response_api.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/provider/users_provider.dart';
import 'package:frontend_delivery/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

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

  PickedFile pickedFile;
  File imageFile;
  Function refresh;
  ProgressDialog _progressDialog;
  bool isEnable = true;

  Future init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    usersProvider.init(context);
    _progressDialog = ProgressDialog(context: context);
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
    if(imageFile==null){
      MySnackbar.show(context, 'Debe seleccionar una imagen.');
      return;
    }
    _progressDialog.show(max: 100, msg: 'Registrando...');
    isEnable = false;

    User user= new User(
      email: email,
      name: name,
      lastname:apellido,
      phone: telefono,
      password: password,
      sessionToken:"TOKEN FALTA"
    );

    Stream stream = await usersProvider.createWithImage(user, imageFile);
    stream.listen((res) {
      _progressDialog.close();
      //ResponseApi responseApi = await usersProvider.create(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      print('Respuesta: ${responseApi.toJson()}');
      MySnackbar.show(context, responseApi.message);

      if(responseApi.success){
        Future.delayed(Duration(seconds: 3),() {
          Navigator.pushReplacementNamed(context, 'login');
        });
      }else{
        isEnable=true;
      }
    });
  }
  Future selectImage(ImageSource imageSource) async{
    //pickedFile = (await ImagePicker().pickImage(source: imageSource)) as PickedFile;
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if(pickedFile!=null){
      imageFile=File(pickedFile.path);
    }
    Navigator.pop(context);
    refresh();
  }
  void showAlertDialog(){
    Widget galleryButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.gallery);
        },
        child: Text('Galeria')
    );
    Widget cameraButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.camera);
        },
        child: Text('Camara')
    );
    AlertDialog alertDialog=AlertDialog(
      title: Text('seleccionar imagen'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context){
        return alertDialog;
      }
    );
  }
  void back(){
    Navigator.pop(context);
  }
}