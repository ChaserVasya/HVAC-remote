import 'package:flutter/material.dart';

import 'package:my_mqtt/presentation/pages/model/page_template.dart';

import 'pid_page_cards/channel_forms_card.dart';
import 'pid_page_cards/pid_value_card.dart';
import 'pid_page_cards/test_card.dart';

class PidPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Пид-регулятор',
      body: ListView(
        children: [
          PidValueCard(),
          ChannelFormsCard(),
          TestCard(),
        ],
      ),
    );
  }
}
