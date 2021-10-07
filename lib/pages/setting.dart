import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanjul_front/pages/setting_account.dart';
import 'package:hanjul_front/pages/setting_password.dart';
import 'package:hanjul_front/widgets/main_app_bar.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key key, this.me, this.onLoggedOut});
  final me;
  final Function onLoggedOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        appBar: AppBar(),
        title: "설정",
        leading: true,
      ),
      body: Center(
        child: Container(
          width: kIsWeb ? 420 : null,
          child: SettingsList(
            sections: [
              SettingsSection(
                title: '계정',
                tiles: [
                  SettingsTile(
                    title: '계정 정보 변경',
                    leading: Icon(Icons.account_circle),
                    onPressed: (BuildContext context) {
                      Get.to(
                        () => SettingAccountPage(me: me),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  SettingsTile(
                    title: '비밀번호 변경',
                    leading: Icon(Icons.vpn_key),
                    onPressed: (BuildContext context) {
                      Get.to(
                        () => SettingPasswordPage(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  SettingsTile(
                    title: '로그아웃',
                    leading: Icon(Icons.logout),
                    onPressed: (BuildContext context) {
                      onLoggedOut();
                      Get.back();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
