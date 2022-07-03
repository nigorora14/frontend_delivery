import 'package:frontend_delivery/src/models/order.dart';
import 'package:frontend_delivery/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend_delivery/src/widgets/no_data_widget.dart';
class RestaurantOrdersListPage extends StatefulWidget {
  const RestaurantOrdersListPage({Key  key}) : super(key: key);

  @override
  _RestaurantOrdersListPageState createState() => _RestaurantOrdersListPageState();
}

class _RestaurantOrdersListPageState extends State<RestaurantOrdersListPage> {

  RestaurantsOrdersListController _con= new RestaurantsOrdersListController();
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
      length: _con.status?.length,
      child: Scaffold(
          key: _con.key,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              flexibleSpace: Column(
                children: [
                  SizedBox(height: 50),
                  _menuDrawer(),
                ],
              ),
              bottom: TabBar(
                indicatorColor: MyColors.primaryColor,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[400],
                isScrollable: true,
                tabs: List<Widget>.generate(_con.status.length, (index) {
                  return Tab(
                      child: Text(_con.status[index]??''),
                    );
                }),
              ),
            ),
          ),
          drawer: _drawer(),
          body: TabBarView(
              children: _con.status.map((String status) {
                //return _cardOrder(null);
                return FutureBuilder(
                    future: _con.getOrders(status),
                    builder: (context, AsyncSnapshot<List<Order>> snapshot){

                      if(snapshot.hasData){
                        if(snapshot.data.length > 0){
                          return ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                              itemCount: snapshot.data?.length??0,
                              itemBuilder: (_, index){
                                return _cardOrder(snapshot.data[index]);
                              }
                          );
                        }
                        else
                        {
                          return NoDataWidgets(text: 'No hay ordenes');
                        }
                      }
                      else {
                        return NoDataWidgets(text: 'No hay ordenes');
                      }

                    }
                );
              }).toList()
          )
      ),
    );
  }
  Widget _cardOrder(Order order){
    return GestureDetector(
      onTap: (){
        _con.openBottomSheet(order);
      },
      child: Container(
        height: 155,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            children: [
              Positioned(child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width*1,
                decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)
                  )
                ),
                child: Container(
                  width: double.infinity,
                    alignment: Alignment.center,
                  child: Text(
                      'Orden #${order.id}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: 'NimbusSans'
                    ),
                  ),
                ),
              )
              ),
              Container(
                margin: EdgeInsets.only(top: 40, left: 20,right: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      child: Text(
                        'Pedido: 2015-05-23',
                        style: TextStyle(
                            fontSize: 13
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      child: Text(
                        'Cliente: ${order.client?.name ??'' } ${order.client?.lastname??''}',
                        style: TextStyle(
                            fontSize: 13
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      child: Text(
                        'Entregar: ${order.address?.neighborhood??''}, ${order.address?.address??''}',
                        style: TextStyle(
                            fontSize: 13
                        ),
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _menuDrawer(){
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
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
                                    : AssetImage('assets/img/satelite.gif'),
                                fit: BoxFit.cover,
                                fadeInDuration: Duration(milliseconds: 50),
                                placeholder: AssetImage('assets/img/satelite.gif')
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
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
            onTap: _con.goToCategoryCreate,
            title: Text('Crear categoria'),
            leading: Icon(Icons.list_alt, color: MyColors.primaryColorDarck),
          ),
          Divider(
            color: MyColors.primaryColorDarck,
            indent: 15,
            endIndent: 15,
          ),
          ListTile(
            onTap: _con.goToProductCreate,
            title: Text('Crear Producto'),
            leading: Icon(Icons.local_mall_outlined, color: MyColors.primaryColorDarck),
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
