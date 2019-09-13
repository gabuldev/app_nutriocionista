import 'package:app_nutriocionista/src/pages/cliente/cliente_page.dart';
import 'package:app_nutriocionista/src/pages/consulta/consulta_page.dart';
import 'package:app_nutriocionista/src/pages/home/widgets/drawer/drawer_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
          length: 2,
          child: Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          title: Text("Home"),
          bottom: TabBar(
            
            tabs: <Widget>[
        Tab(
          child: Text("Consultas"),
        ),
        Tab(
          child: Text("Clientes"),
        )
      ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ConsultaPage(),
            ClientePage()
          ],
        ),
      ),
    );
  }
}
