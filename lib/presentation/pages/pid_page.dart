import 'package:flutter/material.dart';
import 'package:my_mqtt/data/model/pid_page_data.dart';
import 'package:my_mqtt/domain/state/pid_page_state.dart';

import 'package:provider/provider.dart';

import 'model/my_page.dart';

class PidPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyPage(
      title: 'Пид-регулятор',
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(8, 8, 8, 20),
                        child: Text('Значения каналов ПИД-регулятора:', style: TextStyle(fontSize: 20)),
                      ),
                      _ChannelsData(),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              _ChannelForms(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChannelForms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              Text('Поля ввода значений каналов', style: TextStyle(fontSize: 20)),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Введите желаемые значения каналов. Если изменять значения какого-либо канала не требуется - оставьте соответствующее поле пустым',
                ),
              ),
              Column(children: _buildChannelForms(context)),
              if (context.watch<PidPageState>().allInputsAreValid)
                Container(
                  margin: EdgeInsets.all(8),
                  child: (RaisedButton(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Text('Отправить'),
                    ),
                    onPressed: context.watch<PidPageState>().buttonAction,
                  )),
                )
              else
                Container(
                  margin: EdgeInsets.all(8),
                  child: (Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(8),
                        child: Text('Проверьте поля', style: TextStyle(color: Colors.red)),
                      ),
                      RaisedButton(
                        child: Text('Отправить'),
                        onPressed: context.watch<PidPageState>().buttonAction,
                      ),
                    ],
                  )),
                )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChannelForms(BuildContext context) {
    List<Widget> channelsFormsList = [];
    for (Channel channel in Channel.values) {
      channelsFormsList.add(
        TextFormField(
          controller: context.watch<PidPageState>().controllers[channel],
          validator: context.watch<PidPageState>().validatorFunction,
          decoration: InputDecoration(
            labelText: 'Введите желаемое значение ${channel.toString().split(".").last}-канала.',
          ),
        ),
      );
    }
    return channelsFormsList;
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
