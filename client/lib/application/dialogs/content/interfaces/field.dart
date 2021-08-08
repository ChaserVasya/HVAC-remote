abstract class FieldDialogContent {
  FieldDialogContent({
    required this.title,
    required this.labelText,
    this.buttonText = 'Готово',
    required this.message,
  });

  final String title;
  final String labelText;
  final String message;
  final String buttonText;
}
