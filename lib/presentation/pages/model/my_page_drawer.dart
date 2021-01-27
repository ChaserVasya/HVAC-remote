import 'package:flutter/material.dart';
import 'package:my_mqtt/internal/application.dart';

class MyPageDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.blue,
            height: 60,
            width: double.infinity,
            child: Text('Вкладки', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          Column(
            children: [
              _DrawerList(
                  text: 'ПИД-регулятор',
                  pageNames: pageNames[Pages.PidPage],
                  icon: Icon(Icons.settings_input_composite)),
              _DrawerList(
                text: 'Датчики',
                pageNames: pageNames[Pages.SensorsPage],
                icon: Icon(Icons.track_changes),
              ),
              _DrawerList(
                text: 'Об авторе',
                pageNames: pageNames[Pages.AuthorPage],
                icon: Icon(Icons.info),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerList extends StatelessWidget {
  const _DrawerList({
    @required this.text,
    @required this.pageNames,
    @required this.icon,
  });

  final String text;
  final String pageNames;
  final Icon icon;

  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      onTap: () => Navigator.pushNamed(context, pageNames),
      title: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
