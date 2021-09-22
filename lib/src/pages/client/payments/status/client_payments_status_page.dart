import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:frontend_delivery/src/models/mercado_pago_document_type.dart';
import 'package:frontend_delivery/src/models/mercado_pago_installment.dart';
import 'package:frontend_delivery/src/pages/client/payments/installments/client_payments_installments_controller.dart';
import 'package:frontend_delivery/src/pages/client/payments/status/client_payments_status_controller.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';

class ClientPaymentsStatusPage extends StatefulWidget {
  const ClientPaymentsStatusPage({Key key}) : super(key: key);

  @override
  _ClientPaymentsStatusPageState createState() => _ClientPaymentsStatusPageState();
}

class _ClientPaymentsStatusPageState extends State<ClientPaymentsStatusPage> {

  ClientPaymentsStatusController _con = new ClientPaymentsStatusController();
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

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _clipPathOval(),
            _textCardDetail()
          ],
        ),
        bottomNavigationBar: Container(
          height: 85,
          child: _buttonNext()
        ),
    );
  }
  Widget _clipPathOval(){
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: 250,
        width: double.infinity,
        color: MyColors.primaryColor,
        child: SafeArea(
          child: Column(
            children: [
              _con.mercadoPagoPayment?.status=='approved'
              ? Icon(Icons.check_circle, color: Colors.green, size: 150)
              : Icon(Icons.cancel, color: Colors.red, size: 150),
              Text(
                _con.mercadoPagoPayment?.status=='approved'
                ? 'Gracias por tu compra'
                : 'Fallo la transaccion',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _textCardDetail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: _con.mercadoPagoPayment?.status=='approved'
      ?Text(
        'Tu orden fue procesada exitosamente usando '
            '(${_con.mercadoPagoPayment?.paymentMethodId?.toUpperCase()??''}**** '
            '${_con.mercadoPagoPayment?.card?.lastFourDigits??''})',
        style: TextStyle(
          fontSize: 17
        ),
        textAlign: TextAlign.center
      )
      :Text(
        'Tu pago fue rechazado',
        style: TextStyle(
            fontSize: 17
        ),
        textAlign: TextAlign.center
      ),
    );
  }
  Widget _buttonNext(){
    return Container(
      height: 50,
      margin: EdgeInsets.all(15),
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
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'FINALIZAR COMPRA',
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
                  margin: EdgeInsets.only(left: 50,top: 2),
                  height: 30,
                  child: Icon(
                    Icons.arrow_forward_ios,
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
