import 'package:flutter/material.dart';
import 'package:my_mqtt/data/pid_page_data.dart';
import 'package:my_mqtt/domain/state/pid_page_state.dart';
import 'package:my_mqtt/presentation/pages/model/card_template.dart';

import 'package:provider/provider.dart';

class PidValueCard extends StatelessWidget {
  const PidValueCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 20),
            child: Text('Значения каналов ПИД-регулятора:', style: TextStyle(fontSize: 20)),
          ),
          _ChannelsData(),
        ],
      ),
    );
  }
}

class _ChannelsData extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: _buildChannelsData(context),
    );
  }

  List<Widget> _buildChannelsData(BuildContext context) {
    List<Widget> channelsDataList = [];
    for (Channel channel in Channel.values) {
      channelsDataList.add(
        Container(
          alignment: Alignment.centerLeft,
          constraints: BoxConstraints(
            minHeight: 30,
          ),
          child: Text(
            '${channel.toString().split('.').last}-канал: ${context.watch<PidPageState>().channels[channel]}',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }
    return channelsDataList;
  }
}
