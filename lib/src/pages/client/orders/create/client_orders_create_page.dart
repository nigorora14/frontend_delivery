import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend_delivery/src/models/product.dart';
import 'package:frontend_delivery/src/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';
import 'package:frontend_delivery/src/widgets/no_data_widget.dart';

class ClienteOrdersCreatePage extends StatefulWidget {
  const ClienteOrdersCreatePage({Key key}) : super(key: key);

  @override
  _ClienteOrdersCreatePageState createState() => _ClienteOrdersCreatePageState();
}

class _ClienteOrdersCreatePageState extends State<ClienteOrdersCreatePage> {

  ClientOrdersCreateController _con = new ClientOrdersCreateController();

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

      appBar: AppBar(
        title: Text('Mi orden'),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height*0.235,
        child: Column(
          children: [
            Divider(
              color: Colors.grey[400],
              endIndent: 30,
              indent: 30,
            ),
            _textTotalPrice(),
            _buttonNext()
          ],
        ),
      ),
        body: _con.selectedProducts.length > 0 ? ListView(
          children: _con.selectedProducts.map((Product product) {
            return _cardProduct(product);
          }).toList(),
        )
            : Container(
            margin: EdgeInsets.only(left: 110),
            child: NoDataWidgets(text: 'Ningun producto agregado')
        )
    );
  }
  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              SizedBox(height: 10),
              _AddOrRemoveItem(product)
            ],
          ),
          Spacer(),
          Column(
            children: [
              _textPrice(product),
              _iconDelete(product)
            ],
          )
        ],
      ),
    );
  }
  Widget _iconDelete(Product product){
    return IconButton(
        onPressed: (){
          _con.deleteItem(product);
        },
        icon: Icon(
          Icons.delete,
          color: MyColors.primaryColor,
        )
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
      width: 90,
      height: 90,
      padding: EdgeInsets.all(10),
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
  Widget _AddOrRemoveItem(Product product){
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            _con.remove(product);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)
                ),
                color: Colors.grey[200]
            ),
            child: Text('-'),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          color: Colors.grey[200],
          child: Text(
              '${product?.quantity??0}'
          ),
        ),
        GestureDetector(
          onTap: (){
            _con.addItem(product);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)
                ),
                color: Colors.grey[200]
            ),
            child: Text('+'),
          ),
        )
      ],
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
      margin: EdgeInsets.only(left: 30, right: 30,top: 30, bottom: 30),
      child: ElevatedButton(
          onPressed: _con.goToAddress,
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
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'CONTINUAR',
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
                  margin: EdgeInsets.only(left: 80,top: 10),
                  height: 30,
                  child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
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
