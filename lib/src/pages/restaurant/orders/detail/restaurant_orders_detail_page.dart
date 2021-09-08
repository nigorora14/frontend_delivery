import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend_delivery/src/models/order.dart';
import 'package:frontend_delivery/src/models/product.dart';
import 'package:frontend_delivery/src/models/user.dart';
import 'package:frontend_delivery/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';
import 'package:frontend_delivery/src/utils/relative_time_util.dart';
import 'package:frontend_delivery/src/widgets/no_data_widget.dart';

class RestaurantOrdersDetailPage extends StatefulWidget{
  Order order;
  RestaurantOrdersDetailPage({Key key,@required this.order}) : super(key: key);

  @override
  _RestaurantOrdersDetailPageState createState() => _RestaurantOrdersDetailPageState();
}

class _RestaurantOrdersDetailPageState extends State<RestaurantOrdersDetailPage> {

  RestaurantOrdersDetailController _con = new RestaurantOrdersDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.order);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Orden #${_con.order?.id ??''}'),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height*0.55,
        child: Column(
          children: [
            Divider(
              color: Colors.grey[400],
              endIndent: 30,
              indent: 30,
            ),
            _textDescription(),
            _dropDown(_con.users),
            _textData('Cliente','${_con.order.client?.name??''} ${_con.order.client?.lastname??''}'),
            _textData('Entregar en:','${_con.order.address?.neighborhood??''}, ${_con.order.address?.address??''}'),
            _textData(
                'Fecha de pedido:',
                '${RelativeTimeUtil.getRelativeTime(_con.order.timestamp??0)}'
            ),
            _textTotalPrice(),
            _buttonNext()
          ],
        ),
      ),
        body: _con.order.products.length > 0 ? ListView(
          children: _con.order.products.map((Product product) {
            return _cardProduct(product);
          }).toList(),
        )
            : Container(
            margin: EdgeInsets.only(left: 110),
            child: NoDataWidgets(text: 'Ningun producto agregado')
        )
    );
  }
  Widget _textDescription(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Asignar repartidor',
        style: TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: MyColors.primaryColor
        ),
      ),
    );
  }
  Widget _textData(String title, String content){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(title),
        subtitle: Text(content, maxLines: 2,),
      ),
    );
  }
  Widget _dropDown(List<User> users){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text(
                      'Repartidores',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16
                      )
                  ),
                  items: _dropDownItems(users),
                  value: _con.idDelivery,
                  onChanged: (option){
                    setState(() {
                      print('Repartidor seleccionado: $option');
                      _con.idDelivery = option; // estableciendo el valor seleccionado
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  List<DropdownMenuItem<String>> _dropDownItems(List<User> users){
    List<DropdownMenuItem<String>> list = [];
    users.forEach((user) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              child: FadeInImage(
                image:user.image!=null
                    ? NetworkImage(user.image)
                    : AssetImage('assets/img/no-image.png'),
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ),
            SizedBox(width: 5),
            Text(user.name),
          ],
        ),
        value:  user.id,
      ));
    });
    return list;
  }
  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SingleChildScrollView(
        child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Cantidad: ${product.quantity}',
                style: TextStyle(
                    fontWeight: FontWeight.normal
                ),
              )
            ],
          ),
          Spacer(),
          Column(
            children: [
              _textPrice(product),
            ],
          )
        ],
      )),
    );
  }
  Widget _textPrice(Product product){
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        'S/. ${product.price*product.quantity}',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  Widget _imageProduct(Product product){
    return Container(
      width: 60,
      height: 60,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[200]
      ),
      child: FadeInImage(
          image:product.image1!=null
              ? NetworkImage(product.image1)
              : AssetImage('assets/img/no-image.png'),
          fit: BoxFit.contain,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png')
      ),
    );
  }
  Widget _textTotalPrice(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
            ),
          ),
          Text(
            'S/. ${_con.total}',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
  Widget _buttonNext(){
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30,top: 15, bottom: 20),
      child: ElevatedButton(
          onPressed: (){},
          style: ElevatedButton.styleFrom(
              primary: MyColors.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
              )
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    'DESPACHAR ORDEN',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 50,top: 5),
                  height: 30,
                  child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 30,
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
  void refresh(){
    setState(() {});
  }
}
