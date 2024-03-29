import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_remote_client/application/navigator.dart';
import 'package:hvac_remote_client/application/routes.dart';

class PageTemplate extends StatelessWidget {
  const PageTemplate({
    Key? key,
    required this.body,
    this.appBarTitle,
    this.centred = true,
    this.resizeToAvoidBottomInset = false,
  }) : super(key: key);

  final String? appBarTitle;
  final Widget body;
  final bool centred;
  final bool resizeToAvoidBottomInset;
  @override
  Widget build(BuildContext context) {
    Widget widget = body;

    if (centred) widget = Center(child: widget);

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      drawer: (appBarTitle == null) ? null : const SafeArea(child: _Drawer()),
      appBar: (appBarTitle == null)
          ? null
          : AppBar(
              title: Text(appBarTitle!),
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: widget,
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.blue,
            height: kToolbarHeight,
            width: double.infinity,
            child: const Text(
              'Вкладки',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          Column(
            children: const [
              _ListTile('Домашняя страница', RoutesNames.home, Icons.home),
              _ListTile('Настройки', RoutesNames.settings, Icons.settings),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile(
    this.text,
    this.routeName,
    this.iconData,
  );

  final String text;
  final String routeName;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData),
      onTap: () => navigator.pushNamed(routeName),
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
