import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/dialog/content/interfaces/field.dart';
import 'package:hvac_remote_client/application/navigator.dart';
import 'package:hvac_remote_client/presentation/template/field_template.dart';

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
                onEditingComplete: () => navigator.pop<String>(controller.text),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text(content.buttonText),
              onPressed: () => navigator.pop<String>(controller.text),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> showFieldDialog(
  FieldDialogContent content,
) async {
  return showDialog<String?>(
    context: navigator.context,
    builder: (_) => FieldDialog(content),
  );
}
