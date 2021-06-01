import 'package:flutter/material.dart';
import 'package:my_mqtt/domain/entities/outer_device.dart';
import 'package:my_mqtt/presentation/pages/test/view_model.dart';
import 'package:my_mqtt/presentation/templates/card_template.dart';
import 'package:my_mqtt/presentation/templates/page_template.dart';
import 'package:stacked/stacked.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      drawerIsNeeded: false,
      title: 'Мониторинг сервера',
      body: ViewModelBuilder.reactive(
        builder: (context, TestViewModel model, child) => Column(
          children: [
            _CloudInputCard(model),
            _CheckingCard(model),
          ],
        ),
        viewModelBuilder: () => TestViewModel(),
      ),
    );
  }
}

class _CloudInputCard extends StatelessWidget {
  const _CloudInputCard(this.model, {Key? key}) : super(key: key);
  final TestViewModel model;

  final String cardText = '''
Прямая трансляция входящих на сервер''';

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      child: Column(
        children: [
          Text(cardText),
          if (model.switchValue)
            StreamBuilder(
              initialData: '',
              stream: model.stream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Text('''Текущее значение:
${snapshot.data}''', textAlign: TextAlign.center);
              },
            ),
          Switch(
            value: model.switchValue,
            onChanged: (bool newValue) {
              newValue ? model.setStream() : model.stopStream();
            },
          ),
        ],
      ),
    );
  }
}

class _CheckingCard extends StatelessWidget {
  _CheckingCard(this.model, {Key? key}) : super(key: key);
  final TestViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CardTemplate(
        child: Column(
          children: [
            Text('Проверить наличие подписчиков помимо данного'),
            FutureBuilder(
              future: model.checkOuterDeviceSub,
              builder: (BuildContext context, AsyncSnapshot<OuterDeviceStatuses> snap) {
                switch (snap.connectionState) {
                  case ConnectionState.none:
                    return _CheckButton(model);
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  case ConnectionState.active:
                    return CircularProgressIndicator();
                  case ConnectionState.done:
                    switch (snap.requireData) {
                      case OuterDeviceStatuses.unchecked:
                        return Column(children: [
                          _CheckButton(model),
                          Text('не удалось проверить', style: TextStyle(color: Colors.red)),
                        ]);
                      case OuterDeviceStatuses.subscribed:
                        return Column(children: [
                          _CheckButton(model),
                          Text('Есть подписчики', style: TextStyle(color: Colors.green)),
                        ]);
                      case OuterDeviceStatuses.unsubscribed:
                        return Column(children: [
                          _CheckButton(model),
                          Text('Нет подписчиков', style: TextStyle(color: Colors.red)),
                        ]);
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckButton extends StatelessWidget {
  const _CheckButton(this.model, {Key? key}) : super(key: key);
  final TestViewModel model;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        model.checkOuterDeviceStatus();
      },
      child: Text('Проверить'),
    );
  }
}
