import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/dialogs/content/interfaces/field.dart';
import 'package:hvac_remote_client/presentation/templates/field_template.dart';

class FieldDialog extends StatelessWidget {
  FieldDialog(this.content, {Key? key}) : super(key: key);

  final FieldDialogContent content;

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: Text(
            content.title,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                content.message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              FieldTemplate(
                labelText: content.labelText,
                controller: controller,
                onEditingComplete: () => Navigator.pop<String>(context, controller.text),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text(content.buttonText),
              onPressed: () => Navigator.pop<String>(context, controller.text),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> showFieldDialog(
  BuildContext navigatorDescendalContext,
  FieldDialogContent content,
) async {
  return showDialog<String?>(
    context: navigatorDescendalContext,
    builder: (_) => FieldDialog(content),
  );
}