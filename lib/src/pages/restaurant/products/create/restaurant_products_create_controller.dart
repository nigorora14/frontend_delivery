
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:frontend_delivery/src/models/category.dart';
import 'package:frontend_delivery/src/models/product.dart';
import 'package:frontend_delivery/src/models/response_api.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/provider/categories_provider.dart';
import 'package:frontend_delivery/src/utils/my_snackbar.dart';
import 'package:frontend_delivery/src/utils/shared_pref.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantProductsCreateController{
  BuildContext context;
  Function refresh;

  TextEditingController nameController= new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  MoneyMaskedTextController priceController= new MoneyMaskedTextController();

  CategoriesProvider _categoriesProvider= new CategoriesProvider();
  User user;
  SharedPref sharedPref= new SharedPref();

  List<Category> categories = [];
  String idCategory;//almacena el id de la cetegoria almacenada

  //Imagenes
  PickedFile pickedFile;
  File imageFile1;
  File imageFile2;
  File imageFile3;

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await sharedPref.read('user'));
    _categoriesProvider.init(context, user);
    getCategories();
  }
  void getCategories() async {
    categories = await _categoriesProvider.getAll();
    refresh();
  }

  void createProduct() async{
    String name = nameController.text;
    String description = descriptionController.text;
    double price = priceController.numberValue;

    if(name.isEmpty || description.isEmpty || price == 0){
      MySnackbar.show(context, 'Debe ingresar todos los campos.');
      return;
    }
    if(imageFile1 == null || imageFile2 == null || imageFile3 == null){
      MySnackbar.show(context, 'Selecciones 3 imagenes');
      return;
    }
    if(idCategory == null)
    {
        MySnackbar.show(context, 'Selecciona la categoria.');
        return;
    }
    Product product = new Product(
      name: name,
      description: description,
      price: price,
      idCategory: int.parse(idCategory)
    );
    print('formulario producto: ${product.toJson()}');
  }
  Future selectImage(ImageSource imageSource, int numberFile) async{
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if(pickedFile!=null){

      if(numberFile == 1) {
        imageFile1 = File(pickedFile.path);
      }
      else if(numberFile == 2){
        imageFile2 = File(pickedFile.path);
      }
      else if(numberFile == 3){
        imageFile3 = File(pickedFile.path);
      }
    }
    Navigator.pop(context);
    refresh();
  }
  void showAlertDialog(int numberFile){
    Widget galleryButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.gallery, numberFile);
        },
        child: Text('Galeria')
    );
    Widget cameraButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.camera, numberFile);
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
}