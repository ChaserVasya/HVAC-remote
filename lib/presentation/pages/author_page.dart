import 'package:flutter/material.dart';
import 'package:my_mqtt/domain/state/author_page_state.dart';

import 'model/page_template.dart';

class AuthorPage extends StatelessWidget {
  final AuthorPageState authorPageState = AuthorPageState();
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
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
