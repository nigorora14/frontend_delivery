import 'package:flutter/cupertino.dart';
import 'package:frontend_delivery/src/models/category.dart';
import 'package:frontend_delivery/src/models/response_api.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/provider/categories_provider.dart';
import 'package:frontend_delivery/src/utils/my_snackbar.dart';
import 'package:frontend_delivery/src/utils/shared_pref.dart';

class RestaurantProductsCreateController{
  BuildContext context;
  Function refresh;

  TextEditingController nameController= new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  CategoriesProvider _categoriesProvider= new CategoriesProvider();
  User user;

  SharedPref sharedPref= new SharedPref();

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await sharedPref.read('user'));
    _categoriesProvider.init(context, user);
  }
  void createProduct() async{
    String name = nameController.text;
    String description = descriptionController.text;


    if(name.isEmpty || description.isEmpty){
      MySnackbar.show(context, 'Debe ingresar todos los campos.');
      return;
    }

  }
}