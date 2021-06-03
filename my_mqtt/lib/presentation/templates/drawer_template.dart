import 'package:flutter/material.dart';

class DrawerTemplate extends Drawer {
  DrawerTemplate({Key? key})
      : super(
          key: key,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                color: Colors.blue,
                height: 60,
                width: double.infinity,
                child: const Text('Вкладки', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              Column(
                children: const [
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      onTap: () => Navigator.pushNamed(context, pagesNames),
      title: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
