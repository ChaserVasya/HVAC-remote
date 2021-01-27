class PidValidator {
  String validate(String rawText) {
    InputDataType inputDataType = _checkDataType(rawText);
    String validatorText;
    switch (inputDataType) {
      case InputDataType.EmptyData:
        {
          validatorText = null;
          break;
        }
      case InputDataType.DoubleData:
        {
          validatorText = null;
          break;
        }
      case InputDataType.WrongData:
        {
          validatorText = 'Используйте символы: "[0-9]."';
          break;
        }
    }
    return validatorText;
  }

  InputDataType _checkDataType(String rawText) {
    if (rawText == '') {
      return InputDataType.EmptyData;
    }
    if (double.tryParse(rawText) == null) {
      return InputDataType.WrongData;
    } else {
      return InputDataType.DoubleData;
    }
  }
}

enum InputDataType { WrongData, EmptyData, DoubleData }
