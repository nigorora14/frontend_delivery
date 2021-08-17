import 'package:flutter/material.dart';
import 'package:frontend_delivery/src/pages/client/address/map/client_address_map_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddressCreateController{
  BuildContext context;
  Function refresh;

  TextEditingController refPointController = new TextEditingController();
  Map<String, dynamic> refPoint;

  Future init(BuildContext context, Function refresh)
  {
    this.context = context;
    this.refresh = refresh;
  }
  void openMap() async{
    refPoint = await showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => ClientAddressMapPage()
    );
    if(refPoint != null){
      refPointController.text = refPoint['address'];
      refresh();
    }
  }
}