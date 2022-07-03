import 'package:frontend_delivery/src/models/category.dart';
import 'package:frontend_delivery/src/models/product.dart';
import 'package:frontend_delivery/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend_delivery/src/widgets/no_data_widget.dart';
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
    return DefaultTabController(
      length: _con.categories?.length,
      child: Scaffold(
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(170),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [
              _shoppingBag()
            ],
            flexibleSpace: Column(
              children: [
                SizedBox(height: 50),
                _menuDrawer(),
                SizedBox(height: 20),
                _textFieldSearch()
              ],
            ),
            bottom: TabBar(
              indicatorColor: MyColors.primaryColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List<Widget>.generate(_con.categories.length, (index) {
                return Tab(
                 child: Text(_con.categories[index].name??''),
                );
              }),
            ),
          ),
        ),
        drawer: _drawer(),
          body: TabBarView(
            children: _con.categories.map((Category category) {
              return FutureBuilder(
                future: _con.getProducts(category.id, _con.productName),
                  builder: (context, AsyncSnapshot<List<Product>> snapshot){

                  if(snapshot.hasData){
                    if(snapshot.data.length > 0){
                      return GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7
                          ),
                          itemCount: snapshot.data?.length??0,
                          itemBuilder: (_, index){
                            return _cardProduct(snapshot.data[index]);
                          }
                      );
                    }
                    else
                      {
                        return NoDataWidgets(text: 'No hay productos');
                      }
                  }
                  else {
                    return NoDataWidgets(text: 'No hay productos');
                  }

                  }
              );
            }).toList()
          )
      ),
    );
  }
  Widget _cardProduct(Product product){
    return GestureDetector(
      onTap: (){
        _con.openBottomSheet(product);
      },
      child: Container(
        height: 250,
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            children: [
              Positioned(
                top: -1.0,
                  right: -1.0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(20)
                  )
                ),
                    child: Icon(Icons.add, color: Colors.white,),
              )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 150,
                    width: MediaQuery.of(context).size.width*0.45,
                    padding: EdgeInsets.all(20),
                    child: FadeInImage(
                      image:product.image1!=null
                      ? NetworkImage(product.image1)
                      : AssetImage('assets/img/no-image.png'),
                      fit: BoxFit.cover,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder: AssetImage('assets/img/no-image.png'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 33,
                    child: Text(
                      product.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'NimbusSans'
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                        'S/. ${product.price ?? '0.00'}',
                      style: TextStyle(
                        fontSize: 15,
                          fontWeight: FontWeight.bold,
                        fontFamily: 'NimbusSans'
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _shoppingBag() {
    return GestureDetector(
      onTap: _con.goToOrdersCreatePage,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15, top: 0),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
          ),
          Positioned(
            right: 16,
            top: 0,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(30))
            ),
          ))
        ],
      ),
    );
  }
  Widget _textFieldSearch(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: _con.onChangeText,
        decoration: InputDecoration(
          hintText: 'Buscar',
          suffixIcon: Icon(
            Icons.search,
            color: Colors.grey[400]
          ),
          hintStyle: TextStyle(
            fontSize: 17,
            color: Colors.grey[500]
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Colors.grey[300]
            )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                  color: Colors.grey[300]
              )
          ),
          contentPadding: EdgeInsets.all(15)
        ),
      ),
    );
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
    final size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding : const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 8.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    //topRight: Radius.circular(45),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                      color: MyColors.primaryColor.withOpacity(0.9),
                      blurRadius: 10,
                      offset: const Offset(0,5)
                  )
                ],
              color: MyColors.primaryColor
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_con.user?.name??''} ${_con.user?.lastname??''}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
              ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: CircleAvatar(
                          foregroundColor: Colors.white,
                          backgroundColor: MyColors.primaryColor,
                          radius: 57,
                          child: Container(
                            height: 160,
                            width: double.infinity,
                            child: FadeInImage(
                                image:_con.user?.image != null
                                    ? NetworkImage(_con.user?.image)
                                    : AssetImage('assets/img/no-image.png'),
                                fit: BoxFit.cover,
                                fadeInDuration: Duration(milliseconds: 50),
                                placeholder: AssetImage('assets/img/no-image.png')
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Telefono: ${_con.user?.phone??''}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
            ],
          )
          ),
          ListTile(

            onTap: _con.gotoUpdatePage,
            title: Text('Editar Perfil'),
            leading: Icon(Icons.edit_outlined, color: MyColors.primaryColorDarck,),
          ),
          Divider(
            color: MyColors.primaryColorDarck,
            indent: 15,
            endIndent: 15,
          ),
          ListTile(
            onTap: _con.goToOrdersList,
            title: Text('Mis pedidos'),
            leading: Icon(Icons.shopping_cart_outlined , color: MyColors.primaryColorDarck),
          ),
          Divider(
            color: MyColors.primaryColorDarck,
            indent: 15,
            endIndent: 15,
          ),
          _con.user != null ? _con.user.roles.length > 1 ?
          ListTile(
            onTap: _con.goToRoles,
            title: Text('Seleccionar rol'),
            leading: Icon(Icons.person_outline, color: MyColors.primaryColorDarck),
          ): Container(): Container(),
          SizedBox(height: size.height*0.4,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Email: ${_con.user?.email??''}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 1,),
          Divider(
            color: MyColors.primaryColorDarck,
              indent: 15,
              endIndent: 15,
          ),
          ListTile(
            onTap: _con.logout,
            title: Text('Cerrar sesion'),
            trailing: Icon(Icons.power_settings_new, color: Colors.red),
          ),


        ],
      ),
    );
  }
  void refresh(){
    setState((){});
  }
}
