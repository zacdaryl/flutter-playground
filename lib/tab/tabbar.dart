import 'package:flutter/material.dart';

class TabBarSample extends StatelessWidget {
  const TabBarSample({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        child: Scaffold(
      appBar: AppBar(
        title: Text('TabBar'),
        bottom: TabBar(tabs: [
          Tab(icon: Icon(Icons.home), text: 'home'),
          Tab(icon: Icon(Icons.apps), text: 'ver')
        ]),
      ),
      body: TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
            ],
          ),
    ), length: 2,);
  }
}
