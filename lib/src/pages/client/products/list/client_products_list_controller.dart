import 'package:frontend_delivery/src/models/category.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/provider/categories_provider.dart';
import 'package:frontend_delivery/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class ClientProductsListController{
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;

  User user;
  CategoriesProvider _categoriesProvider= new CategoriesProvider();
  List<Category> categories =[];

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _categoriesProvider.init(context, user);
    getCategories();
    refresh();
  }
  void getCategories() async {
    categories =await _categoriesProvider.getAll();
    refresh();
  }
  void logout() {
    _sharedPref.logout(context,  user.id);
  }
  void openDrawer(){
    key.currentState.openDrawer();
  }
  void gotoUpdatePage(){
    Navigator.pushNamed(context, 'client/update');
  }
  void goToRoles(){
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}