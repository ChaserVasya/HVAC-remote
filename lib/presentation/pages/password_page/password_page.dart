import 'package:flutter/material.dart';
import 'package:my_mqtt/domain/state/password_page_domain.dart';
import 'package:my_mqtt/internal/application.dart';
import 'package:my_mqtt/presentation/pages/model/page_template.dart';
import 'package:my_mqtt/presentation/pages/password_page/password_page_content/password_card.dart';

import 'package:provider/provider.dart';

class PasswordPage extends StatelessWidget {
  final String title = 'Авторизация';

  @override
  Widget build(BuildContext context) {
/*    
    void _enterToApp(_) {
      Navigator.pushNamed(context, pagesNames[Pages.PidPage]);
    }

    if (context.watch<PasswordPageDomain>().needToEnterToApp) {
      WidgetsBinding.instance.addPostFrameCallback(_enterToApp);
    }
*/
    return PageTemplate(
      drawerIsNeed: false,
      title: title,
      body: PasswordCard(),
    );
  }
}
