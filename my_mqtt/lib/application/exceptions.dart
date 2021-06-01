abstract class CustomException implements Exception {
  CustomException({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;
}

class EmailVerifyingException extends CustomException {
  EmailVerifyingException()
      : super(
          title: 'Почта не подтверждена',
          message:
              'Почта, привязанная к реквизитам, должна быть подтверждена. Перейдите по ссылке в письме, автоматически отправленном вам на почту. Отправить сообщение повторно?',
        );
}
