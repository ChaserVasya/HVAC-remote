import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:my_mqtt/domain/state/sensors_page_state.dart';

import 'model/my_page.dart';

import 'package:provider/provider.dart';

class SensorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyPage(
      title: 'Датчики',
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                child: Text('Температура', style: TextStyle(fontSize: 20)),
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
              ),
              Container(
                width: 350,
                height: 300,
                child: Chart(
                  data: context.watch<SensorsPageState>().temp,
                  scales: {
                    'Date': CatScale(
                      accessor: (map) => map['Date'] as String,
                      tickCount: 4,
                    ),
                    'Close': LinearScale(
                      accessor: (map) => map['Close'] as num,
                    )
                  },
                  geoms: [
                    AreaGeom(
                      position: PositionAttr(field: 'Date*Close'),
                      shape: ShapeAttr(values: [BasicAreaShape(smooth: true)]),
                      color: ColorAttr(values: [
                        Defaults.theme.colors.first.withAlpha(80),
                      ]),
                    ),
                    LineGeom(
                      position: PositionAttr(field: 'Date*Close'),
                      shape: ShapeAttr(values: [BasicLineShape(smooth: true)]),
                      size: SizeAttr(values: [0.5]),
                    ),
                  ],
                  axes: {
                    'Date': Defaults.horizontalAxis,
                    'Close': Defaults.verticalAxis,
                  },
                ),
              ),
              Padding(
                child: Text('Расход воздуха', style: TextStyle(fontSize: 20)),
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
              ),
              Container(
                width: 350,
                height: 300,
                child: Chart(
                  data: context.watch<SensorsPageState>().air,
                  scales: {
                    'Date': CatScale(
                      accessor: (map) => map['Date'] as String,
                      tickCount: 4,
                    ),
                    'Close': LinearScale(
                      accessor: (map) => map['Close'] as num,
                    )
                  },
                  geoms: [
                    AreaGeom(
                      position: PositionAttr(field: 'Date*Close'),
                      shape: ShapeAttr(values: [BasicAreaShape(smooth: true)]),
                      color: ColorAttr(
                        values: [
                          Defaults.theme.colors.first.withAlpha(80),
                        ],
                      ),
                    ),
                    LineGeom(
                      position: PositionAttr(field: 'Date*Close'),
                      shape: ShapeAttr(values: [BasicLineShape(smooth: true)]),
                      size: SizeAttr(values: [0.5]),
                    ),
                  ],
                  axes: {
                    'Date': Defaults.horizontalAxis,
                    'Close': Defaults.verticalAxis,
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
