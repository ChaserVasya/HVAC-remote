import 'package:flutter/material.dart';

class DrawerTemplate extends Drawer {
  DrawerTemplate()
      : super(
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
                    text: 'Тестовая страница',
                    pagesNames: '/TestPage',
                    icon: Icon(Icons.settings_input_composite),
                  ),
                  _DrawerList(
                    text: 'Об авторе',
                    pagesNames: '/AuthorPage',
                    icon: Icon(Icons.info),
                  ),
                ],
              ),
            ],
          ),
        );
}

class _DrawerList extends StatelessWidget {
  const _DrawerList({
    required this.text,
    required this.pagesNames,
    required this.icon,
  });

  final String text;
  final String pagesNames;
  final Icon icon;

  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      onTap: () => Navigator.pushNamed(context, pagesNames),
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
