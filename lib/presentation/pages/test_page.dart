import 'package:flutter/material.dart';
import 'package:my_mqtt/data/enums.dart';
import 'package:my_mqtt/domain/domain_components/dataflow_component.dart';
import 'package:my_mqtt/domain/domain_components/server_connection_component.dart';
import 'package:my_mqtt/presentation/pages/model/card_template.dart';
import 'package:my_mqtt/presentation/pages/model/page_template.dart';
import 'package:provider/provider.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Тест',
      body: Text('test'),
    );
  }
}

class _CloudInputCard extends StatefulWidget {
  const _CloudInputCard(Key? key) : super(key: key);

  final String cardText = '''
При нахождении переключателя в положении "вкл" сервер пересылает 
получаемые данные с определённого топика на данный агрегат. Данные 
отображаются ниже. При положении "выкл" получение данных останавливается.''';

  @override
  __CloudInputCardState createState() => __CloudInputCardState();
}

class __CloudInputCardState extends State<_CloudInputCard> {
  bool _giveVerse = false;

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      child: Column(
        children: [
          Text(widget.cardText),
          Text('Данные: ${context.watch<DataflowComponent>().inputData}'),
          Switch(
            value: _giveVerse,
            onChanged: (bool newValue) {
              if (newValue == true) {
                context.watch<DataflowComponent>().startDataflow(context);
              } else {
                context.watch<DataflowComponent>().stopDataflow();
              }
              setState(() {
                _giveVerse = newValue;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _ServerConnectionCheckingCard extends StatefulWidget {
  const _ServerConnectionCheckingCard(Key? key) : super(key: key);

  @override
  __ServerConnectionCheckingCardState createState() => __ServerConnectionCheckingCardState();
}

class __ServerConnectionCheckingCardState extends State<_ServerConnectionCheckingCard> {
  ServerConnectionStatuses cardState = ServerConnectionStatuses.notChecked;

  @override
  Widget build(BuildContext context) {
    cardState = context.read<ServerConnectionComponent>().serverConnectionStatus;

    Widget refreshWidget(ServerConnectionStatuses cardState) {
      switch (cardState) {
        case ServerConnectionStatuses.notChecked:
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<ServerConnectionComponent>().checkServerConnection(context);
                },
                child: Text('Проверить'),
              )
            ],
          );
        case ServerConnectionStatuses.checking:
          return CircularProgressIndicator();
        case ServerConnectionStatuses.good:
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<ServerConnectionComponent>().checkServerConnection(context);
                },
                child: Text('Проверить'),
              ),
              Text('Сервер доступен', style: TextStyle(color: Colors.green)),
            ],
          );

        case ServerConnectionStatuses.bad:
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<ServerConnectionComponent>().checkServerConnection(context);
                },
                child: Text('Проверить'),
              ),
              Text('Сервер недоступен', style: TextStyle(color: Colors.red)),
            ],
          );
      }
    }

    return Container(
      child: CardTemplate(
        child: Column(
          children: [
            Text('Проверьте работоспособность сервера нажав на кнопку.'),
            refreshWidget(cardState),
          ],
        ),
      ),
    );
  }
}
