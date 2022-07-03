import 'package:frontend_delivery/src/models/rol.dart';
import 'package:frontend_delivery/src/pages/roles/roles_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend_delivery/src/utils/my_colors.dart';
class RolesPage extends StatefulWidget {
  const RolesPage({Key key}) : super(key: key);

  @override
  _RolesPageState createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {

  RolesController _con= new RolesController();

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
        title: Text('Selecciona un rol')
      ),
        body: Container(
          margin: EdgeInsets.only(top:  MediaQuery.of(context).size.height*0.1),
          child: ListView(
            children: _con.user != null
                ? _con.user.roles.map((Rol rol) {return _cardRol(rol);}).toList()
                :[]
          ),
        )
    );
  }

  Widget _cardRol(Rol rol){
    return GestureDetector(
      onTap: (){
        _con.goToPage(rol.route);
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: CircleAvatar(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white,
              radius: 57,
              child: Container(
                height: 160,
                width: double.infinity,
                child: FadeInImage(
                  image: rol.image != null ? NetworkImage(rol.image) : AssetImage('assets/img/no-image.png'),
                  fit: BoxFit.cover,
                  fadeInDuration: Duration(milliseconds: 50),
                  placeholder: AssetImage('assets/img/no-image.png'),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
              rol.name ?? '',
              style: TextStyle(
                        fontSize: 16,
                        color: Colors.black
            ),
          ),
          SizedBox(height: 25)
        ],
      ),
    );
  }
  void refresh(){
    setState(() {});
  }
}