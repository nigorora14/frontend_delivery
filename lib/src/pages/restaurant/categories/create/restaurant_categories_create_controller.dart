import 'package:flutter/cupertino.dart';
import 'package:frontend_delivery/src/utils/my_snackbar.dart';

class RestaurantCategoriesCreateController{
  BuildContext context;
  Function refresh;

  TextEditingController nameController= new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  Future init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh = refresh;
  }
  void createCategory(){
    String name = nameController.text;
    String description = descriptionController.text;
    print('datos $name $description');

    if(name.isEmpty || description.isEmpty){
      MySnackbar.show(context, 'Debe ingresar todos los campos.');
      return;
    }

  }
}