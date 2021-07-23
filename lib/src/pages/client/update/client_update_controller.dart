import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend_delivery/src/models/response_api.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/provider/users_provider.dart';
import 'package:frontend_delivery/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:frontend_delivery/src/utils/shared_pref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientUpdateController {

  BuildContext context;
  TextEditingController nameController = new TextEditingController();
  TextEditingController apellidoController = new TextEditingController();
  TextEditingController telefonoController = new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;
  ProgressDialog _progressDialog;
  bool isEnable = true;
  User user;
  SharedPref _sharedPref= new SharedPref();

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

    _progressDialog = ProgressDialog(context: context);
    user= User.fromJson(await _sharedPref.read('user'));
    usersProvider.init(context, token: user.sessionToken);

    nameController.text = user.name;
    apellidoController.text = user.lastname;
    telefonoController.text = user.phone;
    refresh();
  }

  void update() async{
    String name= nameController.text.trim();
    String apellido= apellidoController.text.trim();
    String telefono= telefonoController.text.trim();

    if(name.isEmpty || apellido.isEmpty || telefono.isEmpty){
      MySnackbar.show(context, 'Debes ingresar todos los campos.');
      return;
    }
    /*if(password.length < 6){
      MySnackbar.show(context, 'La contraseña como minimo debe contener 6 digitos.');
      return;
    }*/
    /*(imageFile==null){
      MySnackbar.show(context, 'Debe seleccionar una imagen.');
      return;
    }*/
    /*_progressDialog.show(
        max: 100,
        msg: 'Registrando...',
        progressType: ProgressType.valuable,
        backgroundColor: Color(0xff212121),
        progressValueColor: Color(0xff3550B4),
        progressBgColor: Colors.white70,
        msgColor: Colors.white,
        valueColor: Colors.white
    );*/
    await Future.delayed(Duration(milliseconds: 3000));
    for(int i=0; i<=100; i++)
      {
        _progressDialog.update(value: i, msg: 'Actualizando...');
        i++;
        await Future.delayed(Duration(milliseconds: 100));
      }

    isEnable = false;

    User myUser= new User(
        id: user.id,
        name: name,
        lastname:apellido,
        phone: telefono,
        image: user.image
    );

    Stream stream = await usersProvider.update(myUser, imageFile);
    stream.listen((res) async{
      _progressDialog.close();
      //ResponseApi responseApi = await usersProvider.create(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      //print('Respuesta: ${responseApi.toJson()}');
      //MySnackbar.show(context, responseApi.message);
      Fluttertoast.showToast(msg: responseApi.message);

      if(responseApi.success){
        /*Future.delayed(Duration(seconds: 3),() {
          Navigator.pushReplacementNamed(context, 'login');
        });*/
        user = await usersProvider.getById(myUser.id); //obteniendo el usuario
        _sharedPref.save('user', user.toJson());
        Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
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