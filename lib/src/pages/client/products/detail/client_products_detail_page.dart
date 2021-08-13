import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:frontend_delivery/src/models/product.dart';
import 'package:frontend_delivery/src/pages/client/products/detail/client_products_detail_controller.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';

class ClientProductsDetailPage extends StatefulWidget {
  Product product;
  ClientProductsDetailPage({Key key, @required this.product}) : super(key: key);

  @override
  _ClientProductsDetailPageState createState() => _ClientProductsDetailPageState();
}

class _ClientProductsDetailPageState extends State<ClientProductsDetailPage> {
  ClientProductsDetailController _con= new ClientProductsDetailController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.9,
      child: Column(
        children: [
          _imageSlidersho(),
          _textName(),
          _textDescription(),
          Spacer(),
          _addOrRemoveItem(),
          _standarDelivery(),
          _buttonShoppingBag()
        ],
      ),
    );
  }
  Widget _imageSlidersho(){
    return Stack(
      children: [
        ImageSlideshow(
          width: double.infinity,
          height: MediaQuery.of(context).size.height*0.4,
          initialPage: 0,
          indicatorColor: MyColors.primaryColor,
          indicatorBackgroundColor: Colors.grey,
          children: [
            FadeInImage(
              image:_con.product?.image1!=null
                  ? NetworkImage(_con.product.image1)
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
            FadeInImage(
              image:_con.product?.image2!=null
                  ? NetworkImage(_con.product.image2)
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),FadeInImage(
              image:_con.product?.image3!=null
                  ? NetworkImage(_con.product.image3)
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            )
          ],
          onPageChanged: (value) {
            print('Page changed: $value');
          },
          autoPlayInterval: 10000,
        ),
        Positioned(
          left: 15,
            top: 5,
            child: IconButton(
              onPressed: _con.close,
              icon: Icon(
                Icons.arrow_back_ios,
                color: MyColors.primaryColor),
            ))
      ],
    );
  }
  Widget _textName(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 30, left: 30, top: 30),
      child: Text(
        _con.product?.name ?? '',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  Widget _textDescription(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 30, left: 30, top: 15),
      child: Text(
        _con.product?.description ?? '',
        style: TextStyle(
            fontSize: 13,
            color: Colors.grey
        ),
      ),
    );
  }
  Widget _addOrRemoveItem(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          IconButton(
              onPressed: _con.addItem,
              icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey,
                  size: 30,
              )
          ),
          Text(
              '${_con.counter}',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.grey
            ),
          ),
          IconButton(
              onPressed: _con.removeItem,
              icon: Icon(
                Icons.remove_circle_outline,
                color: Colors.grey,
                size: 30,
              )
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Text(
              'S/. ${_con.productPrice ?? '0.00'}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),

            ),
          )
        ],
      ),
    );
  }
  Widget _standarDelivery(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          Image.asset(
            'assets/img/delivery.png',
            height: 17,
          ),
          SizedBox(width: 10),
          Text(
              'Envio estandar',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green
            ),
          )
        ],
      ),
    );
  }
  Widget _buttonShoppingBag(){
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30,top: 30, bottom: 30),
      child: ElevatedButton(
        onPressed: _con.addToBag,
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
                  'AGREGAR AL CARRITO',
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
                margin: EdgeInsets.only(left: 50,top: 10),
                height: 30,
                child: Image.asset('assets/img/bag.png'),
              ),
            )
          ],
        )
      ),
    );
  }
  void refresh(){
    setState((){
    });
  }
}

