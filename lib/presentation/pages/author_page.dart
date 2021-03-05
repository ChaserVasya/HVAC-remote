import 'package:flutter/material.dart';
import 'package:my_mqtt/domain/state/author_page_state.dart';

import 'model/my_page.dart';

class AuthorPage extends StatelessWidget {
  final AuthorPageState authorPageState = AuthorPageState();
  @override
  Widget build(BuildContext context) {
    return MyPage(
      title: 'Об авторе',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(authorPageState.authorPageData.author, textAlign: TextAlign.center),
            Text(authorPageState.authorPageData.license, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
