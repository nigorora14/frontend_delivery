import 'package:frontend_delivery/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
class ClientProductsListPage extends StatefulWidget {
  const ClientProductsListPage({Key key}) : super(key: key);
  @override
  _ClientProductsListPageState createState() => _ClientProductsListPageState();
}
class _ClientProductsListPageState extends State<ClientProductsListPage> {

  ClientProductsListController _con = new ClientProductsListController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      appBar: AppBar(
        leading:_menuDrawer()
      ),
      drawer: _drawer(),
        body: Center(
          child: ElevatedButton(
            onPressed: _con.logout,
            child: Text('Cerrar Sesion'),
      )
    ));
  }
  Widget _menuDrawer(){
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 30),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/menu.png',width: 20,height: 20),
      ),
    );
  }
  Widget _drawer(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyColors.primaryColor
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cliente: ${_con.user?.name??''} ${_con.user?.lastname??''}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    maxLines: 1,
              ),
                  Text(
                    'Email: ${_con.user?.email??''}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    'Telefono: ${_con.user?.phone??''}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                    ),
                    maxLines: 1,
                  ),
                  Container(
                    height: 60,
                    width: 80,
                    margin: EdgeInsets.only(top: 10),
                    child: FadeInImage(
                      image:_con.user?.image != null
                            ? NetworkImage(_con.user?.image)
                            : AssetImage('assets/img/no-image.png'),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder: AssetImage('assets/img/no-image.png')
                    ),
                  )
            ],
          )
          ),
          ListTile(
            onTap: _con.gotoUpdatePage,
            title: Text('Editar Perfil'),
            trailing: Icon(Icons.edit_outlined),
          ),
          ListTile(
            title: Text('Mis pedidos'),
            trailing: Icon(Icons.shopping_cart_outlined),
          ),
          _con.user != null ? _con.user.roles.length > 1 ?
          ListTile(
            onTap: _con.goToRoles,
            title: Text('Seleccionar rol'),
            trailing: Icon(Icons.person_outline),
          ): Container(): Container(),
          ListTile(
            onTap: _con.logout,
            title: Text('Cerrar sesion'),
            trailing: Icon(Icons.power_settings_new),
          )
        ],
      ),
    );
  }
  void refresh(){
    setState((){});
  }
}
