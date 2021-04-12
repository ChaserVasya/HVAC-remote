import 'package:flutter/material.dart';
import 'package:my_mqtt/data/pid_page_data.dart';
import 'package:my_mqtt/domain/state/pid_page_state.dart';
import 'package:my_mqtt/presentation/pages/model/card_template.dart';

import 'package:provider/provider.dart';

class ChannelFormsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardTemplate(
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
