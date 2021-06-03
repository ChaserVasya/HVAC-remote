import 'package:flutter/material.dart';

enum PageModes {
  beforeAuth,
  afterAuth,
}

class PageTemplate extends StatelessWidget {
  const PageTemplate({
    Key? key,
    required this.body,
    this.mode = PageModes.afterAuth,
    this.appBarTitle,
    this.padding = const EdgeInsets.all(16),
  })  : assert((mode == PageModes.afterAuth) && (appBarTitle != null)),
        super(key: key);

  final PageModes mode;
  final String? appBarTitle;
  final Widget body;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case PageModes.beforeAuth:
        return Scaffold(
          body: Padding(
            padding: padding,
            child: body,
          ),
        );

      case PageModes.afterAuth:
        return Scaffold(
          drawer: _DrawerTemplate(),
          appBar: AppBar(title: Text(appBarTitle!)),
          body: Padding(
            padding: padding,
            child: body,
          ),
        );
    }
  }
}

class _DrawerList extends StatelessWidget {
  const _DrawerList({
    required this.text,
    required this.routeName,
    required this.icon,
  });

  final String text;
  final String routeName;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      onTap: () => Navigator.pushNamed(context, routeName),
      title: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}

class _DrawerTemplate extends Drawer {
  _DrawerTemplate()
      : super(
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
                    routeName: '/TestPage',
                    icon: Icon(Icons.settings_input_composite),
                  ),
                  _DrawerList(
                    text: 'Об авторе',
                    routeName: '/AuthorPage',
                    icon: Icon(Icons.info),
                  ),
                ],
              ),
            ],
          ),
        );
}
