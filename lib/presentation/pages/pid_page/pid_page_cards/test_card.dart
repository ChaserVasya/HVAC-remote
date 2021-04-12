import 'package:flutter/material.dart';
import 'package:my_mqtt/domain/state/pid_page_state.dart';
import 'package:my_mqtt/presentation/pages/model/card_template.dart';

import 'package:provider/provider.dart';

class TestCard extends StatelessWidget {
  const TestCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
        child: Container(
      child: (RaisedButton(
        child: Container(
          margin: EdgeInsets.all(8),
          child: Text('Отправить'),
        ),
        onPressed: context.watch<PidPageState>().testCommandState.receiveCommand,
      )),
    ));
  }
}
