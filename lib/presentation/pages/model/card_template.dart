import 'package:flutter/material.dart';

class CardTemplate extends StatelessWidget {
  const CardTemplate({
    Key key,
    @required this.child,
    this.elevation = 4,
    this.width = double.infinity,
    EdgeInsetsGeometry padding,
  })  : padding = padding ?? const EdgeInsets.all(8),
        super(key: key);

  final Widget child;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      child: Container(
        padding: padding,
        width: width,
        child: child,
      ),
    );
  }
}
