import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:frontend_delivery/src/models/mercado_pago_document_type.dart';
import 'package:frontend_delivery/src/models/mercado_pago_installment.dart';
import 'package:frontend_delivery/src/pages/client/payments/installments/client_payments_installments_controller.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';

class ClientPaymentsInstallmentsPage extends StatefulWidget {
  const ClientPaymentsInstallmentsPage({Key key}) : super(key: key);

  @override
  _ClientPaymentsInstallmentsPageState createState() => _ClientPaymentsInstallmentsPageState();
}

class _ClientPaymentsInstallmentsPageState extends State<ClientPaymentsInstallmentsPage> {

  ClientPaymentsInstallmentsController _con = new ClientPaymentsInstallmentsController();
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
        title: Text('Cuotas'),
      ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textDescription(),
            _dropDownInstallments()
          ],
        ),
        bottomNavigationBar: Container(
          height: 120,
          child: Column(
            children: [
              _textTotalPrice(),
              _buttonNext(),
            ],
          ),
        ),
    );
  }
  Widget _textTotalPrice(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total a pagar:',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            '${_con.totalPayment}',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
  Widget _textDescription(){
    return Container(
      margin: EdgeInsets.all(30),
      child: Text(
        'En cuantas cuotas?',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  Widget _dropDownInstallments(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
      child:  Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 7),
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
                      'Seleccionar numero de cuotas',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16
                      )
                  ),
                  items: _dropDownItems(_con.installmentsList),
                  value: _con.selectedInstallment,
                  onChanged: (option){
                    setState(() {
                      print('Repartidor seleccionado: $option');
                      _con.selectedInstallment = option; // estableciendo el valor seleccionado
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
  List<DropdownMenuItem<String>> _dropDownItems(List<MercadoPagoInstallment> installmentList){
    List<DropdownMenuItem<String>> list = [];
    installmentList.forEach((installment) {
      list.add(DropdownMenuItem(
        child: Container(
          margin: EdgeInsets.only(top: 7),
          child: Text('${installment.installments}'),
        ),
        value:  '${installment.installments}',
      ));
    });
    return list;
  }
  Widget _buttonNext(){
    return Container(
      height: 50,
      margin: EdgeInsets.all(15),
      child: ElevatedButton(
          onPressed: _con.createPay,
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
                    'CONFIRMAR PAGO',
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
                    Icons.attach_money,
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
